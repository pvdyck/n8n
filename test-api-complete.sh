#!/bin/bash

echo "======================================"
echo "n8n Public API Complete Test Suite"
echo "======================================"

API_KEY="n8n_api_test_key_123456789"
BASE_URL="http://localhost:7001/api/v1"

echo ""
echo "1. Testing API Access:"
echo "---------------------"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "X-N8N-API-KEY: $API_KEY" $BASE_URL/workflows)
if [ "$RESPONSE" = "200" ]; then
    echo "✅ API Access: Working"
else
    echo "❌ API Access: Failed (HTTP $RESPONSE)"
fi

echo ""
echo "2. Testing Workflow Operations:"
echo "------------------------------"

# Create workflow
echo -n "Creating workflow... "
CREATE_RESPONSE=$(curl -s -X POST -H "X-N8N-API-KEY: $API_KEY" -H "Content-Type: application/json" \
    $BASE_URL/workflows -d '{
        "name": "API Test Workflow",
        "nodes": [
            {
                "id": "1",
                "name": "Start",
                "type": "n8n-nodes-base.start",
                "typeVersion": 1,
                "position": [100, 100]
            },
            {
                "id": "2",
                "name": "Set",
                "type": "n8n-nodes-base.set",
                "typeVersion": 3,
                "position": [300, 100],
                "parameters": {
                    "assignments": {
                        "assignments": [
                            {
                                "id": "1",
                                "name": "message",
                                "value": "Hello from API",
                                "type": "string"
                            }
                        ]
                    }
                }
            }
        ],
        "connections": {
            "Start": {
                "main": [[{"node": "Set", "type": "main", "index": 0}]]
            }
        },
        "settings": {
            "executionOrder": "v1"
        }
    }')

WORKFLOW_ID=$(echo $CREATE_RESPONSE | jq -r '.id')
if [ -n "$WORKFLOW_ID" ] && [ "$WORKFLOW_ID" != "null" ]; then
    echo "✅ Created (ID: $WORKFLOW_ID)"
else
    echo "❌ Failed"
    echo $CREATE_RESPONSE | jq .
fi

# Get workflow
echo -n "Getting workflow... "
GET_RESPONSE=$(curl -s -H "X-N8N-API-KEY: $API_KEY" $BASE_URL/workflows/$WORKFLOW_ID)
if echo $GET_RESPONSE | jq -e '.id' > /dev/null 2>&1; then
    echo "✅ Success"
else
    echo "❌ Failed"
fi

# Update workflow (activate it)
echo -n "Activating workflow... "
UPDATE_RESPONSE=$(curl -s -X PATCH -H "X-N8N-API-KEY: $API_KEY" -H "Content-Type: application/json" \
    $BASE_URL/workflows/$WORKFLOW_ID -d '{"active": true}')
if echo $UPDATE_RESPONSE | jq -e '.active == true' > /dev/null 2>&1; then
    echo "✅ Activated"
else
    echo "❌ Failed"
fi

# List workflows
echo -n "Listing workflows... "
LIST_RESPONSE=$(curl -s -H "X-N8N-API-KEY: $API_KEY" $BASE_URL/workflows)
WORKFLOW_COUNT=$(echo $LIST_RESPONSE | jq '.data | length')
echo "✅ Found $WORKFLOW_COUNT workflow(s)"

# Deactivate workflow
echo -n "Deactivating workflow... "
DEACTIVATE_RESPONSE=$(curl -s -X PATCH -H "X-N8N-API-KEY: $API_KEY" -H "Content-Type: application/json" \
    $BASE_URL/workflows/$WORKFLOW_ID -d '{"active": false}')
if echo $DEACTIVATE_RESPONSE | jq -e '.active == false' > /dev/null 2>&1; then
    echo "✅ Deactivated"
else
    echo "❌ Failed"
fi

# Delete workflow
echo -n "Deleting workflow... "
DELETE_RESPONSE=$(curl -s -X DELETE -o /dev/null -w "%{http_code}" -H "X-N8N-API-KEY: $API_KEY" \
    $BASE_URL/workflows/$WORKFLOW_ID)
if [ "$DELETE_RESPONSE" = "200" ]; then
    echo "✅ Deleted"
else
    echo "❌ Failed (HTTP $DELETE_RESPONSE)"
fi

echo ""
echo "3. Testing Execution Operations:"
echo "-------------------------------"

# List executions
echo -n "Listing executions... "
EXEC_RESPONSE=$(curl -s -H "X-N8N-API-KEY: $API_KEY" $BASE_URL/executions)
if echo $EXEC_RESPONSE | jq -e '.data' > /dev/null 2>&1; then
    EXEC_COUNT=$(echo $EXEC_RESPONSE | jq '.data | length')
    echo "✅ Found $EXEC_COUNT execution(s)"
else
    echo "❌ Failed"
fi

echo ""
echo "4. API Documentation:"
echo "--------------------"
echo "Swagger UI available at: http://localhost:7001/api/v1/docs/"

echo ""
echo "======================================"
echo "API Test Complete!"
echo "======================================"