#!/usr/bin/env node

/**
 * Script to create a default API key for testing purposes
 * Usage: node scripts/create-default-api-key.js
 */

const { Container } = require('@n8n/di');
const { ApiKeyRepository } = require('@n8n/db');
const crypto = require('crypto');

async function createDefaultApiKey() {
	try {
		// Initialize n8n application context
		const { Db } = await import('@/db');
		await Db.init();

		const apiKeyRepo = Container.get(ApiKeyRepository);
		
		// Generate a simple API key for testing
		const apiKey = 'n8n_api_' + crypto.randomBytes(32).toString('hex');
		
		// Create API key record
		const apiKeyRecord = apiKeyRepo.create({
			userId: '1', // Default to first user
			apiKey: apiKey,
			label: 'Default Test API Key',
			scopes: ['workflow:execute', 'workflow:read', 'workflow:create', 'workflow:update', 'workflow:delete'],
		});

		await apiKeyRepo.save(apiKeyRecord);

		console.log('API Key created successfully!');
		console.log('API Key:', apiKey);
		console.log('\nYou can use this API key by adding it to your request headers:');
		console.log('X-N8N-API-KEY:', apiKey);
		
		process.exit(0);
	} catch (error) {
		console.error('Error creating API key:', error);
		process.exit(1);
	}
}

createDefaultApiKey();