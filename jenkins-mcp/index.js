#!/usr/bin/env node
/**
 * Jenkins MCP Server — Inspire Brands Franchising edition
 *
 * A self-contained Model Context Protocol server that wraps the Jenkins REST
 * API as 6 Copilot tools. Modelled after the testlink-mcp server in this repo.
 *
 * No credentials are required — the local Jenkins instance runs without
 * authentication. CSRF crumbs are fetched automatically for every POST.
 *
 * Environment variables (all optional — defaults suit the local Docker setup):
 *   JENKINS_URL  – e.g. http://localhost:8090   (default: http://localhost:8090)
 *
 * Tools exposed:
 *   list_jobs           – list all pipeline jobs and their last-build status
 *   get_build_status    – status + result for a specific build (or lastBuild)
 *   trigger_build       – trigger a parameterised build; returns queue item URL
 *   get_console_log     – fetch console output (last N lines, default 100)
 *   list_builds         – list recent builds for a job with result + duration
 *   get_build_artifacts – list downloadable artifact URLs for a build
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";

// ── Config ────────────────────────────────────────────────────────────────────

const JENKINS_URL = (process.env.JENKINS_URL || "http://localhost:8090").replace(/\/$/, "");

// ── Jenkins REST helpers ───────────────────────────────────────────────────────

/** GET <path>/api/json and return parsed JSON. */
async function jenkinsGet(path) {
  const url = `${JENKINS_URL}${path}${path.includes("?") ? "&" : "?"}tree=*`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`Jenkins GET ${path} → HTTP ${res.status}`);
  return res.json();
}

/** GET raw text (used for consoleText). */
async function jenkinsGetText(path) {
  const res = await fetch(`${JENKINS_URL}${path}`);
  if (!res.ok) throw new Error(`Jenkins GET ${path} → HTTP ${res.status}`);
  return res.text();
}

/** Fetch a CSRF crumb (Jenkins blocks unauthenticated POSTs without it). */
async function getCrumb() {
  try {
    const res = await fetch(`${JENKINS_URL}/crumbIssuer/api/json`);
    if (!res.ok) return null;          // CSRF disabled — no crumb needed
    const data = await res.json();
    return { [data.crumbRequestField]: data.crumb };
  } catch {
    return null;
  }
}

/** POST to Jenkins (with auto crumb). */
async function jenkinsPost(path, queryParams = {}) {
  const crumbHeaders = await getCrumb() ?? {};
  const qs = new URLSearchParams(queryParams).toString();
  const url = `${JENKINS_URL}${path}${qs ? "?" + qs : ""}`;
  const res = await fetch(url, {
    method: "POST",
    headers: { ...crumbHeaders, "Content-Type": "application/x-www-form-urlencoded" },
  });
  return { status: res.status, location: res.headers.get("Location") };
}

// ── MCP server ────────────────────────────────────────────────────────────────

const server = new Server(
  { name: "jenkins-mcp-inspire", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// ── Tool definitions ──────────────────────────────────────────────────────────

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "list_jobs",
      description:
        "List all Jenkins pipeline jobs with their last-build status and result. " +
        "Use this to discover job names before triggering or inspecting builds.",
      inputSchema: { type: "object", properties: {}, required: [] },
    },
    {
      name: "get_build_status",
      description:
        "Get the status and result of a specific build. " +
        "Pass buildNumber as a number or the string 'lastBuild' (default).",
      inputSchema: {
        type: "object",
        properties: {
          jobName: {
            type: "string",
            description: "Jenkins job name, e.g. 'Inspire-Arbys-Full-Regression'",
          },
          buildNumber: {
            type: "string",
            description: "Build number or 'lastBuild' (default: 'lastBuild')",
          },
        },
        required: ["jobName"],
      },
    },
    {
      name: "trigger_build",
      description:
        "Trigger a parameterised Jenkins pipeline build. " +
        "Returns the queue item URL so you can poll for the build number. " +
        "Common parameters: BRAND_PROFILE (e.g. 'arbys'), TEST_GROUPS (e.g. 'smoke' or 'all'), HEADLESS ('true'/'false').",
      inputSchema: {
        type: "object",
        properties: {
          jobName: {
            type: "string",
            description: "Jenkins job name, e.g. 'Inspire-Arbys-Smoke'",
          },
          parameters: {
            type: "object",
            description: "Build parameters as key-value pairs",
            additionalProperties: { type: "string" },
          },
        },
        required: ["jobName"],
      },
    },
    {
      name: "get_console_log",
      description:
        "Fetch the console output (log) for a Jenkins build. " +
        "Returns the last `tailLines` lines (default 100). " +
        "Pass tailLines: 0 to get the full log.",
      inputSchema: {
        type: "object",
        properties: {
          jobName: {
            type: "string",
            description: "Jenkins job name",
          },
          buildNumber: {
            type: "string",
            description: "Build number or 'lastBuild' (default: 'lastBuild')",
          },
          tailLines: {
            type: "number",
            description: "Number of trailing lines to return (default: 100, 0 = full log)",
          },
        },
        required: ["jobName"],
      },
    },
    {
      name: "list_builds",
      description:
        "List recent builds for a Jenkins job. Returns build number, status, result, duration, and timestamp.",
      inputSchema: {
        type: "object",
        properties: {
          jobName: {
            type: "string",
            description: "Jenkins job name",
          },
          limit: {
            type: "number",
            description: "Maximum number of builds to return (default: 10)",
          },
        },
        required: ["jobName"],
      },
    },
    {
      name: "get_build_artifacts",
      description:
        "List downloadable artifact URLs for a Jenkins build. " +
        "Returns direct download links for the Extent HTML report, screenshots ZIP, and logs.",
      inputSchema: {
        type: "object",
        properties: {
          jobName: {
            type: "string",
            description: "Jenkins job name",
          },
          buildNumber: {
            type: "string",
            description: "Build number or 'lastBuild' (default: 'lastBuild')",
          },
        },
        required: ["jobName"],
      },
    },
  ],
}));

// ── Tool handlers ─────────────────────────────────────────────────────────────

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {

      // ── list_jobs ──────────────────────────────────────────────────────────
      case "list_jobs": {
        const data = await jenkinsGet("/api/json?tree=jobs[name,url,lastBuild[number,result,building,duration]]");
        const jobs = (data.jobs ?? []).map((j) => ({
          name: j.name,
          url: j.url,
          lastBuild: j.lastBuild
            ? {
                number: j.lastBuild.number,
                result: j.lastBuild.building ? "RUNNING" : (j.lastBuild.result ?? "PENDING"),
                durationSec: Math.round((j.lastBuild.duration ?? 0) / 1000),
              }
            : null,
        }));
        return { content: [{ type: "text", text: JSON.stringify(jobs, null, 2) }] };
      }

      // ── get_build_status ───────────────────────────────────────────────────
      case "get_build_status": {
        const { jobName, buildNumber = "lastBuild" } = args;
        const path = `/job/${encodeURIComponent(jobName)}/${buildNumber}/api/json` +
          `?tree=number,result,building,duration,timestamp,url,description`;
        const b = await jenkinsGet(path);
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              job: jobName,
              build: b.number,
              status: b.building ? "RUNNING" : (b.result ?? "PENDING"),
              durationSec: Math.round((b.duration ?? 0) / 1000),
              timestamp: new Date(b.timestamp).toISOString(),
              url: b.url,
            }, null, 2),
          }],
        };
      }

      // ── trigger_build ──────────────────────────────────────────────────────
      case "trigger_build": {
        const { jobName, parameters = {} } = args;
        const path = `/job/${encodeURIComponent(jobName)}/buildWithParameters`;
        const { status, location } = await jenkinsPost(path, parameters);
        if (status !== 201) {
          throw new Error(`Jenkins returned HTTP ${status} — expected 201 Created`);
        }
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              queued: true,
              job: jobName,
              parameters,
              queueItemUrl: location,
              hint: `Build is queued. Check status with get_build_status after ~10 seconds.`,
            }, null, 2),
          }],
        };
      }

      // ── get_console_log ────────────────────────────────────────────────────
      case "get_console_log": {
        const { jobName, buildNumber = "lastBuild", tailLines = 100 } = args;
        const path = `/job/${encodeURIComponent(jobName)}/${buildNumber}/consoleText`;
        const fullLog = await jenkinsGetText(path);
        const lines = fullLog.split("\n");
        const output = tailLines > 0 ? lines.slice(-tailLines).join("\n") : fullLog;
        return {
          content: [{
            type: "text",
            text: `[Console log: ${jobName} #${buildNumber}` +
              (tailLines > 0 ? ` — last ${tailLines} lines` : " — full log") +
              `]\n\n${output}`,
          }],
        };
      }

      // ── list_builds ────────────────────────────────────────────────────────
      case "list_builds": {
        const { jobName, limit = 10 } = args;
        const path = `/job/${encodeURIComponent(jobName)}/api/json` +
          `?tree=builds[number,result,building,duration,timestamp,url]{0,${limit}}`;
        const data = await jenkinsGet(path);
        const builds = (data.builds ?? []).map((b) => ({
          number: b.number,
          result: b.building ? "RUNNING" : (b.result ?? "PENDING"),
          durationSec: Math.round((b.duration ?? 0) / 1000),
          timestamp: new Date(b.timestamp).toISOString(),
          url: b.url,
        }));
        return { content: [{ type: "text", text: JSON.stringify(builds, null, 2) }] };
      }

      // ── get_build_artifacts ────────────────────────────────────────────────
      case "get_build_artifacts": {
        const { jobName, buildNumber = "lastBuild" } = args;
        const path = `/job/${encodeURIComponent(jobName)}/${buildNumber}/api/json` +
          `?tree=number,url,artifacts[fileName,relativePath]`;
        const b = await jenkinsGet(path);
        const base = `${JENKINS_URL}/job/${encodeURIComponent(jobName)}/${b.number}/artifact`;
        const artifacts = (b.artifacts ?? []).map((a) => ({
          fileName: a.fileName,
          downloadUrl: `${base}/${a.relativePath}`,
        }));
        return {
          content: [{
            type: "text",
            text: JSON.stringify({
              job: jobName,
              build: b.number,
              artifactBrowserUrl: `${b.url}artifact/`,
              downloadAllZip: `${b.url}artifact/*zip*/archive.zip`,
              artifacts,
            }, null, 2),
          }],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (err) {
    return {
      content: [{ type: "text", text: `Error: ${err.message}` }],
      isError: true,
    };
  }
});

// ── Start ─────────────────────────────────────────────────────────────────────

const transport = new StdioServerTransport();
await server.connect(transport);
process.stderr.write(`[jenkins-mcp] Server started. Jenkins URL: ${JENKINS_URL}\n`);
