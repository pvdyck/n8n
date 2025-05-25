# Complete API Key Scopes for n8n

Based on the `API_KEY_RESOURCES` constant in `/packages/@n8n/permissions/src/constants.ee.ts`, here are ALL available API key scopes:

## Tag Operations (5 scopes)
- `tag:create`
- `tag:read` 
- `tag:update`
- `tag:delete`
- `tag:list`

## Workflow Operations (8 scopes)
- `workflow:create`
- `workflow:read`
- `workflow:update` 
- `workflow:delete`
- `workflow:list`
- `workflow:move`
- `workflow:activate`
- `workflow:deactivate`

## Variable Operations (3 scopes)
- `variable:create`
- `variable:delete`
- `variable:list`

## Security Audit Operations (1 scope)
- `securityAudit:generate`

## Project Operations (4 scopes)
- `project:create`
- `project:update`
- `project:delete`
- `project:list`

## User Operations (5 scopes)
- `user:read`
- `user:list`
- `user:create`
- `user:changeRole`
- `user:delete`

## Execution Operations (4 scopes)
- `execution:delete`
- `execution:read`
- `execution:list`
- `execution:get`

## Credential Operations (3 scopes)
- `credential:create`
- `credential:move`
- `credential:delete`

## Source Control Operations (1 scope)
- `sourceControl:pull`

## Workflow Tags Operations (2 scopes)
- `workflowTags:update`
- `workflowTags:list`

## Total: 36 API Key Scopes

All of these scopes should be included for maximum API access.