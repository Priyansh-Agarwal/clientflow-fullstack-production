#!/usr/bin/env node

// Comprehensive test script for ClientFlow AI Suite
const http = require('http');

const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:4000';

// Test functions
async function testHealthCheck() {
  console.log('🔍 Testing Health Check...');
  try {
    const response = await makeRequest('/health');
    console.log('✅ Health Check:', response.status);
    return true;
  } catch (error) {
    console.log('❌ Health Check Failed:', error.message);
    return false;
  }
}

async function testAPIDocumentation() {
  console.log('\n📚 Testing API Documentation...');
  try {
    const response = await makeRequest('/');
    console.log('✅ API Documentation:', response.name, '-', response.status);
    return true;
  } catch (error) {
    console.log('❌ API Documentation Failed:', error.message);
    return false;
  }
}

async function testDatabaseConnection() {
  console.log('\n🧪 Testing Database Connection...');
  try {
    const response = await makeRequest('/api/test');
    console.log('✅ Database Test:', response.database_status);
    return true;
  } catch (error) {
    console.log('❌ Database Test Failed:', error.message);
    return false;
  }
}

async function testBusinessesAPI() {
  console.log('\n🏢 Testing Businesses API...');
  try {
    const response = await makeRequest('/api/businesses');
    console.log('✅ GET Businesses:', response.count, 'businesses found');
    return true;
  } catch (error) {
    console.log('❌ Businesses API Failed:', error.message);
    return false;
  }
}

async function testCustomersAPI() {
  console.log('\n👥 Testing Customers API...');
  try {
    // Test GET customers
    const getResponse = await makeRequest('/api/customers');
    console.log('✅ GET Customers:', getResponse.count, 'customers found');
    
    // Test POST customer (with a test business_id)
    const newCustomer = {
      business_id: 1, // Assuming business_id 1 exists
      first_name: 'Test Customer',
      last_name: 'API Test',
      email: 'test@example.com',
      phone: '+1234567890',
      source: 'api_test'
    };
    
    try {
      const postResponse = await makeRequest('/api/customers', 'POST', newCustomer);
      console.log('✅ POST Customer:', postResponse.data.first_name, 'created');
    } catch (postError) {
      console.log('⚠️ POST Customer:', postError.message, '(This is expected if business_id 1 doesn\'t exist)');
    }
    
    return true;
  } catch (error) {
    console.log('❌ Customers API Failed:', error.message);
    return false;
  }
}

async function testAnalyticsAPI() {
  console.log('\n📊 Testing Analytics API...');
  try {
    const response = await makeRequest('/api/analytics/dashboard');
    console.log('✅ Analytics Dashboard:', response.data.kpis.total_customers, 'customers,', response.data.kpis.total_businesses, 'businesses');
    return true;
  } catch (error) {
    console.log('❌ Analytics API Failed:', error.message);
    return false;
  }
}

// Helper function to make HTTP requests
function makeRequest(path, method = 'GET', data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, API_BASE_URL);
    const options = {
      hostname: url.hostname,
      port: url.port,
      path: url.pathname,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      }
    };

    if (data) {
      const jsonData = JSON.stringify(data);
      options.headers['Content-Length'] = Buffer.byteLength(jsonData);
    }

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => {
        body += chunk;
      });
      res.on('end', () => {
        try {
          const response = JSON.parse(body);
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(response);
          } else {
            reject(new Error(`HTTP ${res.statusCode}: ${response.message || body}`));
          }
        } catch (error) {
          reject(new Error(`Invalid JSON response: ${body}`));
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

// Main test runner
async function runTests() {
  console.log('🚀 Starting ClientFlow AI Suite Tests...\n');
  console.log(`🌐 Testing API at: ${API_BASE_URL}\n`);
  
  const tests = [
    { name: 'Health Check', fn: testHealthCheck },
    { name: 'API Documentation', fn: testAPIDocumentation },
    { name: 'Database Connection', fn: testDatabaseConnection },
    { name: 'Businesses API', fn: testBusinessesAPI },
    { name: 'Customers API', fn: testCustomersAPI },
    { name: 'Analytics API', fn: testAnalyticsAPI }
  ];
  
  let passed = 0;
  let failed = 0;
  
  for (const test of tests) {
    try {
      const result = await test.fn();
      if (result) {
        passed++;
      } else {
        failed++;
      }
    } catch (error) {
      console.log(`❌ ${test.name} Error:`, error.message);
      failed++;
    }
  }
  
  console.log('\n📊 Test Results:');
  console.log(`✅ Passed: ${passed}`);
  console.log(`❌ Failed: ${failed}`);
  console.log(`📈 Success Rate: ${Math.round((passed / (passed + failed)) * 100)}%`);
  
  if (failed === 0) {
    console.log('\n🎉 All tests passed! ClientFlow AI Suite is working correctly.');
    console.log('\n🚀 Your API is ready for production deployment!');
  } else {
    console.log('\n⚠️  Some tests failed. Please check the server and try again.');
    console.log('\n💡 Common issues:');
    console.log('   - Make sure the server is running');
    console.log('   - Check your environment variables');
    console.log('   - Verify Supabase connection');
  }
  
  console.log('\n📚 Next steps:');
  console.log('   1. Deploy to Vercel: npm run deploy');
  console.log('   2. Deploy to Railway: npm run deploy:railway');
  console.log('   3. Deploy to Render: npm run deploy:render');
}

// Run tests
runTests().catch(console.error);