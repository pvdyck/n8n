#!/bin/bash

echo "Testing n8n Enterprise Features..."
echo "=================================="

BASE_URL="http://localhost:7001"

# Check all enterprise features
echo ""
echo "1. Checking Enterprise Features Status:"
echo "--------------------------------------"
SETTINGS=$(curl -s $BASE_URL/rest/settings)

echo "License Plan: $(echo $SETTINGS | jq -r '.data.license.planName // "Unknown"')"
echo "Variables: $(echo $SETTINGS | jq -r '.data.enterprise.variables // false')"
echo "Source Control: $(echo $SETTINGS | jq -r '.data.enterprise.sourceControl // false')"
echo "External Secrets: $(echo $SETTINGS | jq -r '.data.enterprise.externalSecrets // false')"
echo "LDAP: $(echo $SETTINGS | jq -r '.data.enterprise.ldap // false')"
echo "SAML: $(echo $SETTINGS | jq -r '.data.enterprise.saml // false')"
echo "AI Assistant: $(echo $SETTINGS | jq -r '.data.enterprise.aiAssistant // false')"
echo "Workflow History: $(echo $SETTINGS | jq -r '.data.enterprise.workflowHistory // false')"
echo "Debug In Editor: $(echo $SETTINGS | jq -r '.data.enterprise.debugInEditor // false')"
echo "Advanced Execution Filters: $(echo $SETTINGS | jq -r '.data.enterprise.advancedExecutionFilters // false')"
echo "Binary Data S3: $(echo $SETTINGS | jq -r '.data.enterprise.binaryDataS3 // false')"
echo "Multiple Main Instances: $(echo $SETTINGS | jq -r '.data.enterprise.multipleMainInstances // false')"
echo "Worker View: $(echo $SETTINGS | jq -r '.data.enterprise.workerView // false')"
echo "Advanced Permissions: $(echo $SETTINGS | jq -r '.data.enterprise.advancedPermissions // false')"

echo ""
echo "2. Public API Status:"
echo "--------------------"
echo "API Enabled: $(echo $SETTINGS | jq -r '.data.publicApi.enabled // false')"
echo "API Path: $(echo $SETTINGS | jq -r '.data.publicApi.path // "Unknown"')"
echo "API Swagger UI: $(echo $SETTINGS | jq -r '.data.publicApi.swaggerUi.enabled // false')"

echo ""
echo "3. Community Features:"
echo "---------------------"
echo "Community Packages Enabled: $(echo $SETTINGS | jq -r '.data.communityNodesEnabled // false')"

echo ""
echo "4. Feature Limits:"
echo "-----------------"
echo "Users Quota: $(echo $SETTINGS | jq -r '.data.license.planName' | grep -q 'Enterprise' && echo 'Unlimited' || echo 'Limited')"

echo ""
echo "=================================="
echo "All enterprise features should show as 'true'"
echo "API should be enabled and accessible"
echo "=================================="