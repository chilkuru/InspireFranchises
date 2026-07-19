# TestLink MCP Server (Inspire Brands)

A self-contained [Model Context Protocol](https://modelcontextprotocol.io) server that
exposes the TestLink XML-RPC API as **27 tools** for GitHub Copilot (and any MCP client).

This is a custom implementation inspired by
[`dogkeeper886/testlink-mcp`](https://github.com/dogkeeper886/testlink-mcp), rewritten so
that **every array-typed parameter includes an `items` schema** — a requirement of VS Code
Copilot's strict JSON Schema validation. (The upstream project's `steps` and
`requirement_ids` arrays omit `items`, which causes Copilot to reject the tools.)

## Prerequisites

- Node.js 18+
- A running TestLink instance (see [`../testlink`](../testlink) for the Docker stack)
- A TestLink API key (TestLink → *My Settings* → *Generate a new key*)

## Setup

```powershell
cd testlink-mcp
npm install
```

Create `../testlink/.env` (copy from `../testlink/.env.example`) with your API key:

```env
TESTLINK_API_KEY=your_api_key_here
```

The MCP server is wired up in [`../.vscode/mcp.json`](../.vscode/mcp.json). VS Code launches
it automatically; it reads `TESTLINK_API_KEY` from `testlink/.env` and defaults
`TESTLINK_URL` to `http://localhost:8080`.

## Environment variables

| Variable            | Required | Default                  | Notes                                    |
| ------------------- | -------- | ------------------------ | ---------------------------------------- |
| `TESTLINK_API_KEY`  | yes      | —                        | Server exits if missing.                 |
| `TESTLINK_URL`      | no       | `http://localhost:8080`  | Base URL of the TestLink instance.       |

## Tools (27)

**Test Cases:** `read_test_case`, `create_test_case`, `update_test_case`, `delete_test_case`

**Test Suites:** `list_test_suites`, `list_test_cases_in_suite`, `create_test_suite`,
`update_test_suite`, `delete_test_suite`

**Projects:** `list_projects`

**Test Plans:** `list_test_plans`, `create_test_plan`, `delete_test_plan`,
`get_test_cases_for_test_plan`, `add_test_case_to_test_plan`

**Builds:** `list_builds`, `create_build`, `close_build`

**Executions:** `read_test_execution`, `create_test_execution`

**Requirements:** `list_requirements`, `get_requirement`, `list_requirement_specifications`,
`create_requirement_specification`, `create_requirement`,
`delete_requirement_specification`, `assign_requirements`

## Manual test

```powershell
$env:TESTLINK_API_KEY = "your_key"
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}' | node index.js
```
