#!/usr/bin/env node
/**
 * TestLink MCP Server
 *
 * Exposes the TestLink XML-RPC API as GitHub Copilot tools so the agent can:
 *   - query projects, test plans, builds and test cases
 *   - report execution results directly from a conversation
 *
 * Required environment variables (set in .vscode/mcp.json):
 *   TESTLINK_URL     – e.g. http://localhost:8080
 *   TESTLINK_API_KEY – generated in TestLink → My Settings → API interface
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
const API_KEY = process.env.TESTLINK_API_KEY;
const XMLRPC_PATH = "/lib/api/xmlrpc/v1/xmlrpc.php";

if (!API_KEY) {
  process.stderr.write(
    "[testlink-mcp] ERROR: TESTLINK_API_KEY environment variable is not set.\n"
  );
  process.exit(1);
}

// ── XML-RPC client ────────────────────────────────────────────────────────────

const parsed = new URL(TESTLINK_URL);
const client = xmlrpc.createClient({
  host: parsed.hostname,
  port: Number(parsed.port) || (parsed.protocol === "https:" ? 443 : 80),
  path: XMLRPC_PATH,
});

/** Promisified XML-RPC call. Every TestLink method receives devKey as first arg. */
function tl(method, params = {}) {
  return new Promise((resolve, reject) => {
    client.methodCall(method, [{ devKey: API_KEY, ...params }], (err, val) => {
      if (err) return reject(new Error(`XML-RPC error: ${err.message}`));
      // TestLink signals errors as an array containing a single object with
      // a numeric 'code' key and a message.
      if (
        Array.isArray(val) &&
        val.length === 1 &&
        typeof val[0]?.code === "number"
      ) {
        return reject(new Error(`TestLink API error ${val[0].code}: ${val[0].message}`));
      }
      resolve(val);
    });
  });
}

// ── Tool definitions ──────────────────────────────────────────────────────────

const TOOLS = [
  {
    name: "testlink_get_projects",
    description:
      "List all TestLink test projects visible to the current API key.",
    inputSchema: { type: "object", properties: {}, required: [] },
  },
  {
    name: "testlink_get_test_plans",
    description: "List all test plans for a given TestLink project.",
    inputSchema: {
      type: "object",
      properties: {
        project_name: {
          type: "string",
          description: "Exact TestLink project name (e.g. 'Inspire Brands Franchising')",
        },
      },
      required: ["project_name"],
    },
  },
  {
    name: "testlink_get_builds",
    description: "List all builds (test runs) for a given test plan.",
    inputSchema: {
      type: "object",
      properties: {
        test_plan_id: {
          type: "number",
          description: "Numeric ID of the test plan.",
        },
      },
      required: ["test_plan_id"],
    },
  },
  {
    name: "testlink_create_build",
    description: "Create a new build (test run) inside a test plan.",
    inputSchema: {
      type: "object",
      properties: {
        test_plan_id: { type: "number", description: "Numeric ID of the test plan." },
        build_name: { type: "string", description: "Name for the new build (e.g. 'CI #42')." },
        build_notes: { type: "string", description: "Optional notes for the build." },
      },
      required: ["test_plan_id", "build_name"],
    },
  },
  {
    name: "testlink_get_test_cases",
    description:
      "List all test cases assigned to a test plan, optionally filtered by build.",
    inputSchema: {
      type: "object",
      properties: {
        test_plan_id: { type: "number", description: "Numeric ID of the test plan." },
        build_id: {
          type: "number",
          description: "Optional — filter results by a specific build ID.",
        },
      },
      required: ["test_plan_id"],
    },
  },
  {
    name: "testlink_report_result",
    description:
      "Report a test execution result (Passed / Failed / Blocked) for a test case in a build.",
    inputSchema: {
      type: "object",
      properties: {
        test_case_external_id: {
          type: "string",
          description: "External TC ID in TestLink format, e.g. 'IBF-3'.",
        },
        test_plan_id: { type: "number", description: "Numeric ID of the test plan." },
        build_id: { type: "number", description: "Numeric ID of the build." },
        status: {
          type: "string",
          enum: ["p", "f", "b"],
          description: "'p' = passed, 'f' = failed, 'b' = blocked.",
        },
        notes: {
          type: "string",
          description: "Optional execution notes or failure details.",
        },
      },
      required: ["test_case_external_id", "test_plan_id", "build_id", "status"],
    },
  },
  {
    name: "testlink_get_project_summary",
    description:
      "Return a summary of a TestLink project: number of test plans, total test cases, and latest build results.",
    inputSchema: {
      type: "object",
      properties: {
        project_name: {
          type: "string",
          description: "Exact TestLink project name.",
        },
      },
      required: ["project_name"],
    },
  },
];

// ── Tool handlers ─────────────────────────────────────────────────────────────

async function handleTool(name, args) {
  switch (name) {
    // ── get_projects ──────────────────────────────────────────────────────────
    case "testlink_get_projects": {
      const projects = await tl("tl.getProjects");
      return JSON.stringify(
        projects.map((p) => ({
          id: p.id,
          name: p.name,
          prefix: p.prefix,
          active: p.active === "1",
          description: p.notes || "",
        })),
        null,
        2
      );
    }

    // ── get_test_plans ────────────────────────────────────────────────────────
    case "testlink_get_test_plans": {
      const plans = await tl("tl.getProjectTestPlans", {
        testprojectname: args.project_name,
      });
      return JSON.stringify(
        plans.map((p) => ({
          id: Number(p.id),
          name: p.name,
          active: p.active === "1",
          is_open: p.is_open === "1",
        })),
        null,
        2
      );
    }

    // ── get_builds ────────────────────────────────────────────────────────────
    case "testlink_get_builds": {
      const builds = await tl("tl.getBuildsForTestPlan", {
        testplanid: args.test_plan_id,
      });
      return JSON.stringify(
        builds.map((b) => ({
          id: Number(b.id),
          name: b.name,
          active: b.active === "1",
          notes: b.notes || "",
        })),
        null,
        2
      );
    }

    // ── create_build ──────────────────────────────────────────────────────────
    case "testlink_create_build": {
      const result = await tl("tl.createBuild", {
        testplanid: args.test_plan_id,
        buildname: args.build_name,
        buildnotes: args.build_notes || "",
      });
      return JSON.stringify({ created: true, build_id: Number(result[0]?.id) }, null, 2);
    }

    // ── get_test_cases ────────────────────────────────────────────────────────
    case "testlink_get_test_cases": {
      const params = { testplanid: args.test_plan_id };
      if (args.build_id) params.buildid = args.build_id;
      const cases = await tl("tl.getTestCasesForTestPlan", params);
      // cases is an object keyed by tc_id
      const list = Object.values(cases).flatMap((byPlatform) =>
        Object.values(byPlatform).map((tc) => ({
          external_id: tc.full_external_id,
          name: tc.name,
          status: tc.exec_status || "n",
          priority: tc.priority,
        }))
      );
      return JSON.stringify(list, null, 2);
    }

    // ── report_result ─────────────────────────────────────────────────────────
    case "testlink_report_result": {
      const result = await tl("tl.reportTCResult", {
        testcaseexternalid: args.test_case_external_id,
        testplanid: args.test_plan_id,
        buildid: args.build_id,
        status: args.status,
        notes: args.notes || "",
      });
      return JSON.stringify(result[0] || result, null, 2);
    }

    // ── get_project_summary ───────────────────────────────────────────────────
    case "testlink_get_project_summary": {
      const plans = await tl("tl.getProjectTestPlans", {
        testprojectname: args.project_name,
      });
      const summary = { project: args.project_name, test_plans: [] };
      for (const plan of plans) {
        let builds = [];
        let latestBuild = null;
        try {
          builds = await tl("tl.getBuildsForTestPlan", { testplanid: plan.id });
          latestBuild = builds.sort((a, b) => Number(b.id) - Number(a.id))[0] || null;
        } catch (_) { /* plan may have no builds yet */ }

        summary.test_plans.push({
          id: Number(plan.id),
          name: plan.name,
          active: plan.active === "1",
          total_builds: builds.length,
          latest_build: latestBuild ? latestBuild.name : null,
        });
      }
      return JSON.stringify(summary, null, 2);
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

// ── MCP Server ────────────────────────────────────────────────────────────────

const server = new Server(
  { name: "testlink-mcp", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({ tools: TOOLS }));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  try {
    const text = await handleTool(name, args ?? {});
    return { content: [{ type: "text", text }] };
  } catch (err) {
    return {
      content: [{ type: "text", text: `Error: ${err.message}` }],
      isError: true,
    };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
process.stderr.write("[testlink-mcp] Server running — connected to " + TESTLINK_URL + "\n");
