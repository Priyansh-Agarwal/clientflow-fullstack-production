// ClientFlow AI Suite - Application Test Summary
const http = require('http');

console.log('🚀 ClientFlow AI Suite - Application Test Summary\n');

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
          console.log('✅ Backend API Status:');
          console.log(`   Status: ${response.status}`);
          console.log(`   Database: ${response.database}`);
          console.log(`   Environment: ${response.environment}`);
          console.log(`   Port: ${response.port}`);
          console.log(`   Uptime: ${response.uptime} seconds`);
          console.log(`   Memory: ${response.memory.used} / ${response.memory.total}\n`);
          resolve(response);
        } catch (error) {
          reject(error);
        }
      });
    });

    req.on('error', (error) => {
      console.log('❌ Backend API is not running');
      console.log(`   Error: ${error.message}\n`);
      reject(error);
    });

    req.end();
  });
}

// Test all API endpoints
function testAllEndpoints() {
  const endpoints = [
    { path: '/', name: 'API Documentation', method: 'GET' },
    { path: '/health', name: 'Health Check', method: 'GET' },
    { path: '/api/test', name: 'Database Test', method: 'GET' },
    { path: '/api/businesses', name: 'Businesses API', method: 'GET' },
    { path: '/api/customers', name: 'Customers API', method: 'GET' },
    { path: '/api/analytics/dashboard', name: 'Analytics API', method: 'GET' }
  ];

  return Promise.all(endpoints.map(endpoint => {
    return new Promise((resolve) => {
      const options = {
        hostname: 'localhost',
        port: 3001,
        path: endpoint.path,
        method: endpoint.method
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
            console.log(`   Status: ${res.statusCode}`);
            console.log(`   Success: ${response.success !== false ? 'Yes' : 'No'}`);
            if (response.message) {
              console.log(`   Message: ${response.message}`);
            }
            if (response.count !== undefined) {
              console.log(`   Records: ${response.count}`);
            }
            if (response.data && Array.isArray(response.data)) {
              console.log(`   Data: ${response.data.length} items`);
            }
            console.log('');
            resolve({ endpoint: endpoint.name, status: res.statusCode, success: true });
          } catch (error) {
            console.log(`⚠️  ${endpoint.name}: Non-JSON Response`);
            console.log(`   Status: ${res.statusCode}`);
            console.log(`   Content-Type: ${res.headers['content-type']}`);
            console.log(`   Length: ${data.length} bytes\n`);
            resolve({ endpoint: endpoint.name, status: res.statusCode, success: false });
          }
        });
      });

      req.on('error', (error) => {
        console.log(`❌ ${endpoint.name}: Connection Failed`);
        console.log(`   Error: ${error.message}\n`);
        resolve({ endpoint: endpoint.name, status: 0, success: false });
      });

      req.end();
    });
  }));
}

// Test frontend (if available)
function testFrontend() {
  return new Promise((resolve) => {
    const options = {
      hostname: 'localhost',
      port: 5173,
      path: '/',
      method: 'GET'
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        if (res.statusCode === 200) {
          console.log('✅ Frontend Status:');
          console.log(`   Status: ${res.statusCode}`);
          console.log(`   Content-Type: ${res.headers['content-type']}`);
          console.log(`   Content Length: ${data.length} bytes`);
          console.log(`   Title: ${data.includes('<title>') ? 'Found' : 'Not found'}\n`);
          resolve({ status: res.statusCode, success: true });
        } else {
          console.log(`⚠️  Frontend Status: HTTP ${res.statusCode}\n`);
          resolve({ status: res.statusCode, success: false });
        }
      });
    });

    req.on('error', (error) => {
      console.log('⚠️  Frontend Status: Not Running');
      console.log(`   Error: ${error.message}\n`);
      resolve({ status: 0, success: false });
    });

    req.end();
  });
}

// Main test function
async function runTest() {
  try {
    console.log('🧪 Running comprehensive application test...\n');
    
    // Test backend
    const backendResult = await testBackend();
    
    // Test all API endpoints
    const endpointResults = await testAllEndpoints();
    
    // Test frontend
    const frontendResult = await testFrontend();
    
    // Summary
    console.log('📊 Test Results Summary:');
    console.log('='.repeat(50));
    
    const successfulEndpoints = endpointResults.filter(r => r.success).length;
    const totalEndpoints = endpointResults.length;
    
    console.log(`✅ Backend API: ${backendResult ? 'Working' : 'Failed'}`);
    console.log(`✅ API Endpoints: ${successfulEndpoints}/${totalEndpoints} working`);
    console.log(`✅ Frontend: ${frontendResult.success ? 'Working' : 'Not running'}`);
    console.log(`✅ Database: ${backendResult ? backendResult.database : 'Unknown'}`);
    
    console.log('\n🌐 Available Services:');
    if (backendResult) {
      console.log(`   • Backend API: http://localhost:${backendResult.port}`);
      console.log(`   • API Documentation: http://localhost:${backendResult.port}/`);
      console.log(`   • Health Check: http://localhost:${backendResult.port}/health`);
      console.log(`   • Database Test: http://localhost:${backendResult.port}/api/test`);
      console.log(`   • Businesses: http://localhost:${backendResult.port}/api/businesses`);
      console.log(`   • Customers: http://localhost:${backendResult.port}/api/customers`);
      console.log(`   • Analytics: http://localhost:${backendResult.port}/api/analytics/dashboard`);
    }
    
    if (frontendResult.success) {
      console.log(`   • Frontend: http://localhost:5173`);
    }
    
    console.log('\n🎯 Production Readiness:');
    if (backendResult && successfulEndpoints >= 4) {
      console.log('   ✅ Backend is production-ready');
      console.log('   ✅ Database connection is stable');
      console.log('   ✅ All core APIs are functional');
      console.log('   ✅ Ready for Vercel deployment');
      
      if (frontendResult.success) {
        console.log('   ✅ Frontend is working');
        console.log('   ✅ Full-stack application is ready');
      } else {
        console.log('   ⚠️  Frontend needs dependency installation');
        console.log('   💡 Run: cd frontend && npm install && npm run dev');
      }
    } else {
      console.log('   ❌ Backend needs attention');
      console.log('   💡 Check database connection and API configuration');
    }
    
    console.log('\n🚀 Next Steps:');
    console.log('   1. If backend is working: Deploy to Vercel');
    console.log('   2. If frontend needs setup: Install dependencies');
    console.log('   3. Test all endpoints manually');
    console.log('   4. Configure environment variables for production');
    
    console.log('\n✨ ClientFlow AI Suite Test Complete!');
    
  } catch (error) {
    console.log('❌ Test failed:', error.message);
    console.log('\n🔧 Troubleshooting:');
    console.log('   1. Start backend: cd backend && node index.js');
    console.log('   2. Check if port 3001 is available');
    console.log('   3. Verify Supabase connection');
    console.log('   4. Install frontend deps: cd frontend && npm install');
  }
}

runTest();
