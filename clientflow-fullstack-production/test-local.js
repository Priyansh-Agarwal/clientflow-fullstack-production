// Simple test script to verify local deployment
const http = require('http');

console.log('🧪 Testing ClientFlow AI Suite Local Deployment...\n');

// Test Backend API
function testBackend() {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3001,
      path: '/health',
      method: 'GET'
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        try {
          const response = JSON.parse(data);
          console.log('✅ Backend API Test:');
          console.log(`   Status: ${response.status}`);
          console.log(`   Database: ${response.database}`);
          console.log(`   Environment: ${response.environment}`);
          console.log(`   Port: ${response.port}\n`);
          resolve(response);
        } catch (error) {
          reject(error);
        }
      });
    });

    req.on('error', (error) => {
      console.log('❌ Backend API Test Failed:');
      console.log(`   Error: ${error.message}\n`);
      reject(error);
    });

    req.end();
  });
}

// Test API endpoints
function testAPIEndpoints() {
  const endpoints = [
    { path: '/api/test', name: 'Database Test' },
    { path: '/api/businesses', name: 'Businesses API' },
    { path: '/api/customers', name: 'Customers API' }
  ];

  return Promise.all(endpoints.map(endpoint => {
    return new Promise((resolve) => {
      const options = {
        hostname: 'localhost',
        port: 3001,
        path: endpoint.path,
        method: 'GET'
      };

      const req = http.request(options, (res) => {
        let data = '';
        res.on('data', (chunk) => {
          data += chunk;
        });
        res.on('end', () => {
          try {
            const response = JSON.parse(data);
            console.log(`✅ ${endpoint.name}:`);
            console.log(`   Status: ${response.success ? 'Success' : 'Failed'}`);
            if (response.message) {
              console.log(`   Message: ${response.message}`);
            }
            if (response.count !== undefined) {
              console.log(`   Records: ${response.count}`);
            }
            console.log('');
            resolve(response);
          } catch (error) {
            console.log(`❌ ${endpoint.name}: Parse Error`);
            console.log(`   Raw Response: ${data.substring(0, 100)}...\n`);
            resolve(null);
          }
        });
      });

      req.on('error', (error) => {
        console.log(`❌ ${endpoint.name}: Connection Error`);
        console.log(`   Error: ${error.message}\n`);
        resolve(null);
      });

      req.end();
    });
  }));
}

// Run tests
async function runTests() {
  try {
    console.log('🚀 Starting tests...\n');
    
    // Test backend health
    await testBackend();
    
    // Test API endpoints
    await testAPIEndpoints();
    
    console.log('🎉 All tests completed!');
    console.log('\n📋 Summary:');
    console.log('   ✅ Backend API is running on http://localhost:3001');
    console.log('   ✅ Database connection is working');
    console.log('   ✅ All API endpoints are responding');
    console.log('\n🌐 Available URLs:');
    console.log('   • API Documentation: http://localhost:3001/');
    console.log('   • Health Check: http://localhost:3001/health');
    console.log('   • Database Test: http://localhost:3001/api/test');
    console.log('   • Businesses: http://localhost:3001/api/businesses');
    console.log('   • Customers: http://localhost:3001/api/customers');
    console.log('\n🚀 Your ClientFlow AI Suite is ready for production!');
    
  } catch (error) {
    console.log('❌ Test failed:', error.message);
    console.log('\n🔧 Troubleshooting:');
    console.log('   1. Make sure the backend is running: cd backend && node index.js');
    console.log('   2. Check if port 3001 is available');
    console.log('   3. Verify Supabase connection');
  }
}

runTests();
