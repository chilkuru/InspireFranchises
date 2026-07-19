#!/usr/bin/env node
/**
 * TestLink MCP Server — Inspire Brands Franchising edition
 *
 * A self-contained Model Context Protocol server exposing the TestLink
 * XML-RPC API as 27 Copilot tools. Inspired by dogkeeper886/testlink-mcp
 * but rewritten so that EVERY array parameter declares an `items` schema —
 * VS Code Copilot enforces strict JSON Schema and rejects any tool whose
 * array type lacks `items` ("tool parameters array type must have items").
 *
 * Required environment variables:
 *   TESTLINK_URL     – e.g. http://host.docker.internal:8080
 *   TESTLINK_API_KEY – TestLink → My Settings → API interface → Generate key
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import xmlrpc from "xmlrpc";

// ── Config ────────────────────────────────────────────────────────────────────

const TESTLINK_URL = process.env.TESTLINK_URL || "http://localhost:8080";
const API_KEY = process.env.TESTLINK_API_KEY || "";

if (!API_KEY) {
  process.stderr.write("[testlink-mcp] ERROR: TESTLINK_API_KEY is not set.\n");
  process.exit(1);
}

// ── XML-RPC client ────────────────────────────────────────────────────────────

const parsed = new URL(TESTLINK_URL);
const client = xmlrpc.createClient({
  host: parsed.hostname,
  port: Number(parsed.port) || (parsed.protocol === "https:" ? 443 : 80),
  path: (parsed.pathname === "/" ? "" : parsed.pathname) +
    "/lib/api/xmlrpc/v1/xmlrpc.php",
});

/** Promisified XML-RPC call; injects devKey and maps TestLink error arrays. */
function tl(method, params = {}) {
  return new Promise((resolve, reject) => {
    client.methodCall(method, [{ devKey: API_KEY, ...params }], (err, val) => {
      if (err) return reject(new Error(`XML-RPC transport error: ${err.message}`));
      if (Array.isArray(val) && val.length === 1 && typeof val[0]?.code === "number") {
        return reject(new Error(`TestLink API error ${val[0].code}: ${val[0].message}`));
      }
      resolve(val);
    });
  });
}

// ── Reusable schema fragments (all arrays carry `items`) ───────────────────────

const stepsArray = {
  type: "array",
  description:
    "Test steps. Each item: { step_number, actions, expected_results, execution_type }. " +
    "actions/expected_results are HTML-formatted (escape < > & \" as HTML entities).",
  items: {
    type: "object",
    properties: {
      step_number: { type: "number" },
      actions: { type: "string" },
      expected_results: { type: "string" },
      execution_type: { type: "number", description: "1=manual, 2=automated" },
    },
  },
};

const requirementIdsArray = {
  type: "array",
  description: "Requirement IDs to assign for coverage.",
  items: { type: "string" },
};

// ── Tool definitions (27) ──────────────────────────────────────────────────────

const TOOLS = [
  // ── Test Cases (4) ──────────────────────────────────────────────────────────
  {
    name: "read_test_case",
    description: "Read a test case from TestLink by ID (numeric or PREFIX-123).",
    inputSchema: {
      type: "object",
      properties: {
        test_case_id: { type: "string", description: "Numeric (123) or external (PREFIX-123)." },
      },
      required: ["test_case_id"],
    },
  },
  {
    name: "create_test_case",
    description: "Create a new test case in a suite.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Test case data.",
          properties: {
            testprojectid: { type: "string", description: "Test project ID." },
            testsuiteid: { type: "string", description: "Test suite ID." },
            name: { type: "string", description: "Test case name." },
            authorlogin: { type: "string", description: "Author login." },
            summary: { type: "string", description: "HTML-formatted summary." },
            preconditions: { type: "string", description: "HTML-formatted preconditions." },
            steps: stepsArray,
            importance: { type: "number", description: "1=low, 2=medium, 3=high." },
            execution_type: { type: "number", description: "1=manual, 2=automated." },
            status: { type: "number", description: "1=draft, 7=final." },
          },
          required: ["testprojectid", "testsuiteid", "name", "authorlogin"],
        },
      },
      required: ["data"],
    },
  },
  {
    name: "update_test_case",
    description: "Update an existing test case.",
    inputSchema: {
      type: "object",
      properties: {
        test_case_id: { type: "string", description: "Numeric or external ID." },
        data: {
          type: "object",
          description: "Fields to update.",
          properties: {
            name: { type: "string" },
            summary: { type: "string", description: "HTML-formatted." },
            preconditions: { type: "string", description: "HTML-formatted." },
            steps: stepsArray,
            importance: { type: "number", description: "1=low, 2=medium, 3=high." },
            execution_type: { type: "number", description: "1=manual, 2=automated." },
            status: { type: "number", description: "1=draft, 7=final." },
          },
        },
      },
      required: ["test_case_id", "data"],
    },
  },
  {
    name: "delete_test_case",
    description: "Delete a test case from TestLink.",
    inputSchema: {
      type: "object",
      properties: {
        test_case_id: { type: "string", description: "Numeric or external ID." },
      },
      required: ["test_case_id"],
    },
  },

  // ── Test Suites (5) ─────────────────────────────────────────────────────────
  {
    name: "list_test_suites",
    description:
      "List test suites for a project. Without parent_suite_id returns top-level suites; " +
      "with it returns immediate child suites of that parent.",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string", description: "Test project ID." },
        parent_suite_id: { type: "string", description: "Optional parent SUITE ID (not project ID)." },
      },
      required: ["project_id"],
    },
  },
  {
    name: "list_test_cases_in_suite",
    description: "List all test cases in a test suite.",
    inputSchema: {
      type: "object",
      properties: {
        suite_id: { type: "string", description: "The test suite ID." },
      },
      required: ["suite_id"],
    },
  },
  {
    name: "create_test_suite",
    description: "Create a new test suite in a project (optionally nested).",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string", description: "Test project ID." },
        suite_name: { type: "string", description: "Name of the new suite." },
        details: { type: "string", description: "Description (optional)." },
        parent_id: { type: "string", description: "Parent suite ID (optional)." },
      },
      required: ["project_id", "suite_name"],
    },
  },
  {
    name: "update_test_suite",
    description: "Update test suite properties.",
    inputSchema: {
      type: "object",
      properties: {
        suite_id: { type: "string", description: "Suite ID to update." },
        project_id: { type: "string", description: "Test project ID." },
        data: {
          type: "object",
          description: "Fields to update.",
          properties: {
            name: { type: "string" },
            details: { type: "string" },
          },
        },
      },
      required: ["suite_id", "project_id", "data"],
    },
  },
  {
    name: "delete_test_suite",
    description: "Delete a test suite (and its contents).",
    inputSchema: {
      type: "object",
      properties: {
        suite_id: { type: "string", description: "Suite ID to delete." },
      },
      required: ["suite_id"],
    },
  },

  // ── Test Plans (5) ──────────────────────────────────────────────────────────
  {
    name: "list_test_plans",
    description: "List all test plans for a project.",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string", description: "The project ID." },
      },
      required: ["project_id"],
    },
  },
  {
    name: "create_test_plan",
    description: "Create a new test plan.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Test plan data.",
          properties: {
            project_id: { type: "string", description: "Project ID or prefix." },
            name: { type: "string", description: "Test plan name." },
            notes: { type: "string", description: "Notes (optional)." },
            active: { type: "number", description: "1/0 (optional)." },
            is_public: { type: "number", description: "1/0 (optional)." },
          },
          required: ["project_id", "name"],
        },
      },
      required: ["data"],
    },
  },
  {
    name: "delete_test_plan",
    description: "Delete a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        plan_id: { type: "string", description: "Test plan ID to delete." },
      },
      required: ["plan_id"],
    },
  },
  {
    name: "get_test_cases_for_test_plan",
    description: "List all test cases assigned to a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        plan_id: { type: "string", description: "The test plan ID." },
      },
      required: ["plan_id"],
    },
  },
  {
    name: "add_test_case_to_test_plan",
    description: "Add a test case to a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Assignment data.",
          properties: {
            testcaseid: { type: "string", description: "Numeric or external ID." },
            testplanid: { type: "string", description: "Test plan ID." },
            testprojectid: { type: "string", description: "Test project ID." },
            version: { type: "number", description: "Version (optional, default 1)." },
            platformid: { type: "string", description: "Platform ID (optional)." },
            urgency: { type: "number", description: "1=low, 2=medium, 3=high (optional)." },
            overwrite: { type: "boolean", description: "Overwrite existing (optional)." },
          },
          required: ["testcaseid", "testplanid", "testprojectid"],
        },
      },
      required: ["data"],
    },
  },

  // ── Builds (3) ──────────────────────────────────────────────────────────────
  {
    name: "list_builds",
    description: "List all builds for a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        plan_id: { type: "string", description: "The test plan ID." },
      },
      required: ["plan_id"],
    },
  },
  {
    name: "create_build",
    description: "Create a new build in a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Build data.",
          properties: {
            plan_id: { type: "string", description: "Test plan ID." },
            name: { type: "string", description: "Build name." },
            notes: { type: "string", description: "Notes (optional)." },
            active: { type: "number", description: "1/0 (optional)." },
            open: { type: "number", description: "1/0 (optional)." },
          },
          required: ["plan_id", "name"],
        },
      },
      required: ["data"],
    },
  },
  {
    name: "close_build",
    description: "Close a build (prevents new executions).",
    inputSchema: {
      type: "object",
      properties: {
        build_id: { type: "string", description: "Build ID to close." },
      },
      required: ["build_id"],
    },
  },

  // ── Executions (2) ──────────────────────────────────────────────────────────
  {
    name: "read_test_execution",
    description:
      "Get the last execution result for a test case in a plan. Both plan_id and test_case_id required.",
    inputSchema: {
      type: "object",
      properties: {
        plan_id: { type: "string", description: "The test plan ID." },
        test_case_id: { type: "string", description: "Numeric or external ID." },
        build_id: { type: "string", description: "Build ID (optional)." },
      },
      required: ["plan_id", "test_case_id"],
    },
  },
  {
    name: "create_test_execution",
    description: "Record a test execution result (pass/fail/block).",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Execution data.",
          properties: {
            test_case_id: { type: "string", description: "Numeric or external ID." },
            plan_id: { type: "string", description: "Test plan ID." },
            build_id: { type: "string", description: "Build ID." },
            status: { type: "string", description: "p=pass, f=fail, b=block." },
            notes: { type: "string", description: "Execution notes (optional)." },
            platform_id: { type: "string", description: "Platform ID (optional)." },
            steps: stepsArray,
          },
          required: ["test_case_id", "plan_id", "build_id", "status"],
        },
      },
      required: ["data"],
    },
  },

  // ── Requirements (7) ────────────────────────────────────────────────────────
  {
    name: "list_requirement_specifications",
    description: "List requirement specifications for a project.",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string", description: "The test project ID." },
      },
      required: ["project_id"],
    },
  },
  {
    name: "create_requirement_specification",
    description: "Create a requirement specification in a project.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Requirement spec data.",
          properties: {
            project_id: { type: "string", description: "Test project ID." },
            doc_id: { type: "string", description: "Unique document ID." },
            title: { type: "string", description: "Specification title." },
            scope: { type: "string", description: "Free-text description (optional)." },
          },
          required: ["project_id", "doc_id", "title"],
        },
      },
      required: ["data"],
    },
  },
  {
    name: "delete_requirement_specification",
    description: "Delete a requirement specification (and its requirements).",
    inputSchema: {
      type: "object",
      properties: {
        reqspec_id: { type: "string", description: "Requirement specification ID to delete." },
      },
      required: ["reqspec_id"],
    },
  },
  {
    name: "list_requirements",
    description: "Get all requirements for a project.",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string", description: "The test project ID." },
      },
      required: ["project_id"],
    },
  },
  {
    name: "get_requirement",
    description: "Get details about a specific requirement.",
    inputSchema: {
      type: "object",
      properties: {
        requirement_id: { type: "string", description: "The requirement ID." },
        project_id: { type: "string", description: "The test project ID." },
      },
      required: ["requirement_id", "project_id"],
    },
  },
  {
    name: "create_requirement",
    description: "Create a requirement inside a requirement specification.",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Requirement data.",
          properties: {
            project_id: { type: "string", description: "Test project ID." },
            reqspec_id: { type: "string", description: "Parent requirement spec ID." },
            doc_id: { type: "string", description: "Unique document ID." },
            title: { type: "string", description: "Requirement title." },
            scope: { type: "string", description: "Free-text description (optional)." },
          },
          required: ["project_id", "reqspec_id", "doc_id", "title"],
        },
      },
      required: ["data"],
    },
  },
  {
    name: "assign_requirements",
    description: "Link requirements to a test case (requirement coverage).",
    inputSchema: {
      type: "object",
      properties: {
        data: {
          type: "object",
          description: "Requirement coverage assignment.",
          properties: {
            test_case_id: { type: "string", description: "Numeric or external ID." },
            project_id: { type: "string", description: "Test project ID." },
            reqspec_id: { type: "string", description: "Requirement specification ID." },
            requirement_ids: requirementIdsArray,
          },
          required: ["test_case_id", "project_id", "reqspec_id", "requirement_ids"],
        },
      },
      required: ["data"],
    },
  },

  // ── Projects (1) ────────────────────────────────────────────────────────────
  {
    name: "list_projects",
    description: "List all test projects in TestLink.",
    inputSchema: { type: "object", properties: {} },
  },
];

// ── ID helpers ─────────────────────────────────────────────────────────────────

const EXTERNAL_TC_ID = /^[A-Za-z0-9]+-(\d+)$/;

/** Route a test case identifier to the correct TestLink param. */
function tcParam(id) {
  return EXTERNAL_TC_ID.test(id)
    ? { testcaseexternalid: id }
    : { testcaseid: id };
}

// ── Tool handlers ──────────────────────────────────────────────────────────────

async function handleTool(name, args) {
  switch (name) {
    // Test Cases
    case "read_test_case":
      return tl("tl.getTestCase", tcParam(args.test_case_id));
    case "create_test_case": {
      const d = args.data;
      return tl("tl.createTestCase", {
        testprojectid: d.testprojectid,
        testsuiteid: d.testsuiteid,
        testcasename: d.name,
        authorlogin: d.authorlogin,
        summary: d.summary || "",
        preconditions: d.preconditions || "",
        steps: d.steps || [],
        importance: d.importance ?? 2,
        executiontype: d.execution_type ?? 1,
        status: d.status ?? 1,
      });
    }
    case "update_test_case": {
      const d = args.data || {};
      const p = { ...tcParam(args.test_case_id) };
      if (d.name) p.testcasename = d.name;
      if (d.summary) p.summary = d.summary;
      if (d.preconditions) p.preconditions = d.preconditions;
      if (d.steps) p.steps = d.steps;
      if (d.importance !== undefined) p.importance = d.importance;
      if (d.execution_type !== undefined) p.executiontype = d.execution_type;
      if (d.status !== undefined) p.status = d.status;
      return tl("tl.updateTestCase", p);
    }
    case "delete_test_case":
      return tl("tl.deleteTestCase", tcParam(args.test_case_id));

    // Test Suites
    case "list_test_suites":
      return args.parent_suite_id
        ? tl("tl.getTestSuitesForTestSuite", { testsuiteid: args.parent_suite_id })
        : tl("tl.getFirstLevelTestSuitesForTestProject", { testprojectid: args.project_id });
    case "list_test_cases_in_suite":
      return tl("tl.getTestCasesForTestSuite", {
        testsuiteid: args.suite_id,
        deep: true,
        details: "full",
      });
    case "create_test_suite": {
      const p = {
        testprojectid: args.project_id,
        testsuitename: args.suite_name,
        details: args.details || "",
      };
      if (args.parent_id) p.parentid = args.parent_id;
      return tl("tl.createTestSuite", p);
    }
    case "update_test_suite": {
      const d = args.data || {};
      const p = { testsuiteid: args.suite_id, testprojectid: args.project_id };
      if (d.name) p.testsuitename = d.name;
      if (d.details) p.details = d.details;
      return tl("tl.updateTestSuite", p);
    }
    case "delete_test_suite":
      return tl("tl.deleteTestSuite", { testsuiteid: args.suite_id });

    // Test Plans
    case "list_test_plans":
      return tl("tl.getProjectTestPlans", { testprojectid: args.project_id });
    case "create_test_plan": {
      const d = args.data;
      return tl("tl.createTestPlan", {
        testprojectname: d.project_id,
        testplanname: d.name,
        notes: d.notes || "",
        active: d.active ?? 1,
        is_public: d.is_public ?? 1,
      });
    }
    case "delete_test_plan":
      return tl("tl.deleteTestPlan", { testplanid: args.plan_id });
    case "get_test_cases_for_test_plan":
      return tl("tl.getTestCasesForTestPlan", { testplanid: args.plan_id });
    case "add_test_case_to_test_plan": {
      const d = args.data;
      return tl("tl.addTestCaseToTestPlan", {
        testprojectid: d.testprojectid,
        testplanid: d.testplanid,
        ...tcParam(d.testcaseid),
        version: d.version ?? 1,
        platformid: d.platformid,
        urgency: d.urgency ?? 2,
        overwrite: d.overwrite ?? false,
      });
    }

    // Builds
    case "list_builds":
      return tl("tl.getBuildsForTestPlan", { testplanid: args.plan_id });
    case "create_build": {
      const d = args.data;
      return tl("tl.createBuild", {
        testplanid: d.plan_id,
        buildname: d.name,
        buildnotes: d.notes || "",
        active: d.active ?? 1,
        open: d.open ?? 1,
        releasedate: d.release_date || new Date().toISOString().split("T")[0],
      });
    }
    case "close_build":
      return tl("tl.closeBuild", { buildid: args.build_id });

    // Executions
    case "read_test_execution": {
      const p = { testplanid: args.plan_id, ...tcParam(args.test_case_id) };
      if (args.build_id) p.buildid = args.build_id;
      return tl("tl.getLastExecutionResult", p);
    }
    case "create_test_execution": {
      const d = args.data;
      return tl("tl.reportTCResult", {
        testplanid: d.plan_id,
        buildid: d.build_id,
        status: d.status,
        notes: d.notes || "",
        platformid: d.platform_id,
        steps: d.steps || [],
        ...tcParam(d.test_case_id),
      });
    }

    // Requirements
    case "list_requirement_specifications":
      return tl("tl.getRequirementSpecificationsForTestProject", {
        testprojectid: args.project_id,
      });
    case "create_requirement_specification": {
      const d = args.data;
      return tl("tl.createRequirementSpecification", {
        testprojectid: d.project_id,
        requirementdocid: d.doc_id,
        title: d.title,
        scope: d.scope || "",
      });
    }
    case "delete_requirement_specification":
      return tl("tl.deleteRequirementSpecification", { reqspecid: args.reqspec_id });
    case "list_requirements":
      return tl("tl.getRequirements", { testprojectid: args.project_id });
    case "get_requirement":
      return tl("tl.getRequirement", {
        requirementid: args.requirement_id,
        testprojectid: args.project_id,
      });
    case "create_requirement": {
      const d = args.data;
      return tl("tl.createRequirement", {
        testprojectid: d.project_id,
        reqspecid: d.reqspec_id,
        requirementdocid: d.doc_id,
        title: d.title,
        scope: d.scope || "",
      });
    }
    case "assign_requirements": {
      const d = args.data;
      const reqs = (Array.isArray(d.requirement_ids) ? d.requirement_ids : [d.requirement_ids]);
      return tl("tl.assignRequirements", {
        ...tcParam(d.test_case_id),
        testprojectid: d.project_id,
        requirements: [{ req_spec: d.reqspec_id, requirements: reqs }],
      });
    }

    // Projects
    case "list_projects":
      return tl("tl.getProjects");

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

// ── MCP wiring ─────────────────────────────────────────────────────────────────

const server = new Server(
  { name: "testlink-mcp-inspire", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  try {
    const result = await handleTool(name, args ?? {});
    return { content: [{ type: "text", text: JSON.stringify(result, null, 2) }] };
  } catch (err) {
    return { content: [{ type: "text", text: `Error: ${err.message}` }], isError: true };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
process.stderr.write(`[testlink-mcp] Running — ${TOOLS.length} tools, TestLink at ${TESTLINK_URL}\n`);
