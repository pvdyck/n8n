#!/bin/bash

# Test script to verify API is enabled and working

echo "Testing n8n API..."

# Test if API endpoint is accessible
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/api/v1)

if [ "$API_RESPONSE" = "401" ] || [ "$API_RESPONSE" = "403" ]; then
    echo "✅ API is enabled (got $API_RESPONSE - authentication required)"
elif [ "$API_RESPONSE" = "404" ]; then
    echo "❌ API seems to be disabled (got 404)"
else
    echo "⚠️  Unexpected response: $API_RESPONSE"
fi

# Test API docs endpoint
DOCS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/api/v1/docs)

if [ "$DOCS_RESPONSE" = "200" ] || [ "$DOCS_RESPONSE" = "301" ] || [ "$DOCS_RESPONSE" = "302" ]; then
    echo "✅ API docs are accessible"
else
    echo "❌ API docs not accessible (got $DOCS_RESPONSE)"
fi

echo ""
echo "To test with an API key, use:"
echo "curl -H 'X-N8N-API-KEY: YOUR_API_KEY' http://localhost:5678/api/v1/workflows"