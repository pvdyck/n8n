#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

API_KEY="n8n_api_test_key_123456789"
BASE_URL="http://localhost:7001"

echo "🔍 Testing n8n License Features"
echo "================================"

# Function to test API endpoint
test_api() {
    local endpoint=$1
    local description=$2
    
    response=$(wget -qO- --header="X-N8N-API-KEY: $API_KEY" "$BASE_URL/api/v1/$endpoint" 2>&1)
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ $description${NC}"
        return 0
    else
        echo -e "${RED}❌ $description - Error: $response${NC}"
        return 1
    fi
}

# Function to check settings
check_settings() {
    echo -e "\n${YELLOW}📋 Checking n8n Settings:${NC}"
    
    settings=$(wget -qO- "$BASE_URL/rest/settings" | jq '.')
    
    # Check enterprise features
    echo -e "\n${YELLOW}Enterprise Features:${NC}"
    
    # Variables feature
    variables=$(echo "$settings" | jq -r '.data.enterprise.variables // false')
    if [[ "$variables" == "true" ]]; then
        echo -e "${GREEN}✅ Variables: Enabled${NC}"
    else
        echo -e "${RED}❌ Variables: Disabled${NC}"
    fi
    
    # Source control
    sourceControl=$(echo "$settings" | jq -r '.data.enterprise.sourceControl // false')
    if [[ "$sourceControl" == "true" ]]; then
        echo -e "${GREEN}✅ Source Control: Enabled${NC}"
    else
        echo -e "${RED}❌ Source Control: Disabled${NC}"
    fi
    
    # External secrets
    externalSecrets=$(echo "$settings" | jq -r '.data.enterprise.externalSecrets // false')
    if [[ "$externalSecrets" == "true" ]]; then
        echo -e "${GREEN}✅ External Secrets: Enabled${NC}"
    else
        echo -e "${RED}❌ External Secrets: Disabled${NC}"
    fi
    
    # Audit logs
    auditLogs=$(echo "$settings" | jq -r '.data.enterprise.auditLogs // false')
    if [[ "$auditLogs" == "true" ]]; then
        echo -e "${GREEN}✅ Audit Logs: Enabled${NC}"
    else
        echo -e "${RED}❌ Audit Logs: Disabled${NC}"
    fi
    
    # Advanced permissions
    advancedPermissions=$(echo "$settings" | jq -r '.data.enterprise.advancedPermissions // false')
    if [[ "$advancedPermissions" == "true" ]]; then
        echo -e "${GREEN}✅ Advanced Permissions: Enabled${NC}"
    else
        echo -e "${RED}❌ Advanced Permissions: Disabled${NC}"
    fi
    
    # Check plan name
    echo -e "\n${YELLOW}License Information:${NC}"
    planName=$(echo "$settings" | jq -r '.data.license.planName // "Community"')
    echo "Plan Name: $planName"
    
    # Check usage limits
    echo -e "\n${YELLOW}Usage Limits:${NC}"
    echo "$settings" | jq '.data.license.limits // {}'
}

# Function to test enterprise endpoints
test_enterprise_endpoints() {
    echo -e "\n${YELLOW}🔐 Testing Enterprise API Endpoints:${NC}"
    
    # Test variables endpoint
    test_api "variables" "Variables API"
    
    # Test source control endpoint
    test_api "source-control/preferences" "Source Control API"
    
    # Test external secrets endpoint
    test_api "external-secrets/providers" "External Secrets API"
    
    # Test audit logs endpoint (might return empty but should not be forbidden)
    test_api "audit" "Audit Logs API"
}

# Function to check UI features
check_ui_features() {
    echo -e "\n${YELLOW}🖥️  UI Feature Flags:${NC}"
    
    # Get the index page and check for feature flags
    index_page=$(wget -qO- "$BASE_URL")
    
    # Check if variables are mentioned in the UI
    if echo "$index_page" | grep -q "variables"; then
        echo -e "${GREEN}✅ Variables UI present${NC}"
    else
        echo -e "${YELLOW}⚠️  Variables UI not detected in index (might be loaded dynamically)${NC}"
    fi
}

# Function to create and test a variable
test_variable_creation() {
    echo -e "\n${YELLOW}🧪 Testing Variable Creation:${NC}"
    
    # Create a test variable
    variable_data='{
        "key": "TEST_VAR",
        "value": "test_value",
        "type": "string"
    }'
    
    response=$(wget -qO- \
        --header="X-N8N-API-KEY: $API_KEY" \
        --header="Content-Type: application/json" \
        --post-data="$variable_data" \
        "$BASE_URL/api/v1/variables" 2>&1)
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Successfully created variable${NC}"
        
        # List variables
        vars=$(wget -qO- --header="X-N8N-API-KEY: $API_KEY" "$BASE_URL/api/v1/variables")
        echo "Variables list: $vars"
    else
        echo -e "${RED}❌ Failed to create variable: $response${NC}"
    fi
}

# Main execution
echo "Waiting for n8n to be ready..."
sleep 5

# Run all tests
check_settings
test_enterprise_endpoints
check_ui_features
test_variable_creation

echo -e "\n${YELLOW}📊 Summary:${NC}"
echo "If all features show ✅, your license bypass is working correctly!"
echo "If any features show ❌, there might be an issue with the license bypass."

# Additional manual checks
echo -e "\n${YELLOW}📝 Manual Checks:${NC}"
echo "1. Login to the UI at $BASE_URL"
echo "2. Check Settings > Usage & Plan - should show 'Enterprise' or unlimited usage"
echo "3. Check Settings > Variables - should be accessible"
echo "4. Check Settings > Source Control - should be accessible"
echo "5. Check Settings > External Secrets - should be accessible"
echo "6. Try creating a workflow with 100+ nodes (no limit)"
echo "7. Try inviting multiple users (no limit)"