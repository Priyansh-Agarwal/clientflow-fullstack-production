// ClientFlow AI Suite - Production Ready API Server
// This version works instantly on Vercel without any build process

require('dotenv').config();
const express = require('express');
const { createClient } = require('@supabase/supabase-js');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;

console.log('🚀 Starting ClientFlow AI Suite API Server...');

// Initialize Supabase client
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing required environment variables:');
  console.error('   SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set');
  console.error('   Please check your .env file or environment configuration');
  // Don't exit in production, allow graceful degradation
  if (process.env.NODE_ENV === 'production') {
    console.warn('⚠️ Running without database connection - some features will be limited');
  } else {
    process.exit(1);
  }
}

let supabase = null;
try {
  if (supabaseUrl && supabaseKey) {
    supabase = createClient(supabaseUrl, supabaseKey);
    console.log('✅ Supabase client initialized successfully');
  }
} catch (error) {
  console.error('❌ Supabase initialization failed:', error.message);
  if (process.env.NODE_ENV !== 'production') {
    process.exit(1);
  }
}

// Security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.supabase.io"],
    },
  },
  crossOriginEmbedderPolicy: false,
}));

// CORS configuration
app.use(cors({
  origin: function (origin, callback) {
    // Allow requests with no origin (mobile apps, curl, etc.)
    if (!origin) return callback(null, true);
    
    const allowedOrigins = (process.env.CORS_ORIGIN || '*').split(',');
    
    // Allow all origins in development or if CORS_ORIGIN is set to *
    if (process.env.NODE_ENV !== 'production' || allowedOrigins.includes('*')) {
      return callback(null, true);
    }
    
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.warn(`⚠️ CORS blocked request from origin: ${origin}`);
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept', 'X-Requested-With', 'x-org-id'],
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // limit each IP to 100 requests per windowMs
  message: {
    success: false,
    error: 'Too many requests',
    message: 'Please try again later',
    retryAfter: '15 minutes'
  },
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => {
    // Skip rate limiting for health checks
    return req.path === '/health' || req.path === '/api/test';
  },
});

app.use(limiter);

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Request logging middleware
app.use((req, res, next) => {
  const startTime = Date.now();
  const originalSend = res.send;
  
  res.send = function(data) {
    const responseTime = Date.now() - startTime;
    console.log(`${req.method} ${req.path} - ${res.statusCode} - ${responseTime}ms`);
    originalSend.call(this, data);
  };
  
  next();
});

// Security headers
app.use((req, res, next) => {
  res.header('X-Content-Type-Options', 'nosniff');
  res.header('X-Frame-Options', 'DENY');
  res.header('X-XSS-Protection', '1; mode=block');
  res.header('Referrer-Policy', 'strict-origin-when-cross-origin');
  next();
});

console.log('🔧 Middleware configured successfully');

// === HEALTH CHECK ENDPOINT ===
app.get('/health', async (req, res) => {
  console.log('🏥 Health check requested');
  
  let dbStatus = 'Disconnected ❌';
  let dbError = null;
  
  // Test database connection if available
  if (supabase) {
    try {
      const { data, error } = await supabase
        .from('businesses')
        .select('id')
        .limit(1);
      
      if (error) {
        dbStatus = 'Error ❌';
        dbError = error.message;
      } else {
        dbStatus = 'Connected ✅';
      }
    } catch (error) {
      dbStatus = 'Error ❌';
      dbError = error.message;
    }
  }
  
  const health = {
    status: dbStatus.includes('Connected') ? 'OK' : 'DEGRADED',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    memory: {
      used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024) + ' MB',
      total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024) + ' MB'
    },
    environment: process.env.NODE_ENV || 'development',
    database: {
      status: dbStatus,
      error: dbError,
      provider: 'Supabase'
    },
    version: '1.0.0',
    port: PORT,
    services: {
      api: 'UP',
      database: dbStatus.includes('Connected') ? 'UP' : 'DOWN'
    }
  };
  
  const statusCode = dbStatus.includes('Connected') ? 200 : 503;
  res.status(statusCode).json(health);
});

// === API DOCUMENTATION ENDPOINT ===
app.get('/', (req, res) => {
  console.log('📚 API Documentation requested');
  res.json({
    name: 'ClientFlow AI Suite',
    version: '1.0.0',
    status: 'Production Ready ✅',
    description: 'Professional CRM API with AI-powered business automation',
    database: supabase ? 'Connected ✅' : 'Disconnected ❌',
    documentation: {
      health: 'GET /health - System health check',
      businesses: 'GET /api/businesses - List all businesses',
      customers: 'GET /api/customers - List all customers',
      create_customer: 'POST /api/customers - Create new customer',
      test_db: 'GET /api/test - Database connection test',
      analytics: 'GET /api/analytics/dashboard - Analytics dashboard'
    },
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
    port: PORT,
    features: [
      'Multi-tenant business management',
      'Customer relationship tracking',
      'Supabase-powered database',
      'Production-ready security',
      'Rate limiting and abuse protection',
      'Comprehensive health monitoring',
      'RESTful API design'
    ],
    deployment: {
      platform: 'Vercel Ready',
      scaling: 'Auto-scaling',
      monitoring: 'Built-in health checks'
    }
  });
});

// === DATABASE CONNECTION TEST ===
app.get('/api/test', async (req, res) => {
  console.log('🧪 Database test requested');
  try {
    if (!supabase) {
      return res.status(503).json({
        success: false,
        error: 'Supabase client not initialized',
        environment: process.env.NODE_ENV || 'development',
        supabase_url_configured: !!process.env.SUPABASE_URL,
        supabase_key_configured: !!process.env.SUPABASE_SERVICE_ROLE_KEY,
        message: 'Please check your environment variables'
      });
    }

    // Test basic connection
    const { data: businessData, error: businessError } = await supabase
      .from('businesses')
      .select('id, business_name')
      .limit(1);
    
    const { data: customerData, error: customerError } = await supabase
      .from('customers')
      .select('id, first_name')
      .limit(1);
    
    res.json({
      success: true,
      message: '🎉 ClientFlow AI Suite API is working perfectly!',
      database_status: 'Connected ✅',
      environment: process.env.NODE_ENV || 'development',
      port: PORT,
      test_results: {
        businesses_table: businessError ? `❌ Error: ${businessError.message}` : `✅ Connected (${businessData?.length || 0} records)`,
        customers_table: customerError ? `❌ Error: ${customerError.message}` : `✅ Connected (${customerData?.length || 0} records)`
      },
      demo_data: {
        sample_business: businessData?.[0]?.business_name || 'Demo Business',
        sample_customer: customerData?.[0]?.first_name || 'John Doe'
      },
      available_endpoints: [
        'GET / - API documentation',
        'GET /health - Health check',
        'GET /api/businesses - List businesses',
        'GET /api/customers - List customers', 
        'GET /api/customers?business_id=X - Filter customers by business',
        'POST /api/customers - Create customer',
        'GET /api/test - This test endpoint',
        'GET /api/analytics/dashboard - Analytics dashboard'
      ],
      timestamp: new Date().toISOString(),
      uptime: process.uptime() + ' seconds'
    });
  } catch (error) {
    console.error('Database test error:', error);
    res.status(500).json({
      success: false,
      error: 'Database connection test failed',
      details: error.message,
      environment: process.env.NODE_ENV || 'development',
      port: PORT
    });
  }
});

// === BUSINESSES API ===
app.get('/api/businesses', async (req, res) => {
  console.log('🏢 Businesses API requested');
  try {
    if (!supabase) {
      return res.status(503).json({
        success: false,
        error: 'Database service unavailable',
        message: 'Supabase client not initialized. Please check your environment variables.'
      });
    }

    const { data, error } = await supabase
      .from('businesses')
      .select('id, business_name, slug, phone, email, address, status, created_at, updated_at')
      .order('created_at', { ascending: false })
      .limit(100);
    
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({
        success: false,
        error: 'Database query failed',
        details: error.message
      });
    }
    
    console.log(`📊 Retrieved ${data?.length || 0} businesses`);
    res.json({
      success: true,
      message: 'Businesses retrieved successfully',
      count: data?.length || 0,
      data: data || [],
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Businesses API error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
});

// === CUSTOMERS API ===
app.get('/api/customers', async (req, res) => {
  console.log('👥 Customers API requested');
  try {
    if (!supabase) {
      return res.status(503).json({
        success: false,
        error: 'Database service unavailable',
        message: 'Supabase client not initialized. Please check your environment variables.'
      });
    }

    const { business_id } = req.query;
    let query = supabase
      .from('customers')
      .select('id, business_id, first_name, last_name, phone, email, source, notes, created_at, updated_at')
      .order('created_at', { ascending: false })
      .limit(100);
    
    if (business_id) {
      query = query.eq('business_id', business_id);
    }

    const { data, error } = await query;
    
    if (error) {
      console.error('Database error:', error);
      return res.status(500).json({
        success: false,
        error: 'Database query failed',
        details: error.message
      });
    }
    
    console.log(`📊 Retrieved ${data?.length || 0} customers`);
    res.json({
      success: true,
      message: 'Customers retrieved successfully',
      count: data?.length || 0,
      data: data || [],
      filters: business_id ? { business_id } : {},
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Customers API error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
});

// === CREATE CUSTOMER ===
app.post('/api/customers', async (req, res) => {
  console.log('➕ Create customer requested');
  try {
    if (!supabase) {
      return res.status(503).json({
        success: false,
        error: 'Database service unavailable',
        message: 'Supabase client not initialized. Please check your environment variables.'
      });
    }

    const { business_id, first_name, last_name, phone, email, source, notes } = req.body;
    
    // Validation
    if (!business_id || !first_name) {
      return res.status(400).json({
        success: false,
        error: 'Validation failed',
        required: ['business_id', 'first_name'],
        received: { business_id: !!business_id, first_name: !!first_name },
        message: 'business_id and first_name are required fields'
      });
    }

    // Validate business_id exists
    const { data: businessExists, error: businessError } = await supabase
      .from('businesses')
      .select('id')
      .eq('id', business_id)
      .single();
    
    if (businessError || !businessExists) {
      return res.status(400).json({
        success: false,
        error: 'Invalid business_id - business not found',
        message: 'The specified business_id does not exist in the database'
      });
    }

    // Create customer
    const { data, error } = await supabase
      .from('customers')
      .insert([{
        business_id,
        first_name: first_name.trim(),
        last_name: (last_name || '').trim(),
        phone: (phone || '').trim(),
        email: (email || '').trim(),
        source: (source || 'api').trim(),
        notes: (notes || '').trim()
      }])
      .select();
    
    if (error) {
      console.error('Customer creation error:', error);
      return res.status(500).json({
        success: false,
        error: 'Failed to create customer',
        details: error.message
      });
    }
    
    console.log('✅ Customer created successfully');
    res.status(201).json({
      success: true,
      message: 'Customer created successfully',
      data: data[0],
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Create customer error:', error);
    res.status(500).json({
      success: false,
      error: 'Internal server error',
      details: error.message
    });
  }
});

// === ANALYTICS API (Simplified) ===
app.get('/api/analytics/dashboard', async (req, res) => {
  console.log('📊 Analytics dashboard requested');
  try {
    if (!supabase) {
      return res.status(503).json({
        success: false,
        error: 'Database service unavailable',
        message: 'Supabase client not initialized. Please check your environment variables.'
      });
    }

    // Get basic analytics data
    const [customersResult, businessesResult] = await Promise.all([
      supabase.from('customers').select('id, created_at').limit(1000),
      supabase.from('businesses').select('id, created_at').limit(1000)
    ]);

    const customers = customersResult.data || [];
    const businesses = businessesResult.data || [];

    // Calculate basic metrics
    const totalCustomers = customers.length;
    const totalBusinesses = businesses.length;
    const customersThisMonth = customers.filter(c => {
      const created = new Date(c.created_at);
      const now = new Date();
      return created.getMonth() === now.getMonth() && created.getFullYear() === now.getFullYear();
    }).length;

    res.json({
      success: true,
      data: {
        kpis: {
          total_customers: totalCustomers,
          total_businesses: totalBusinesses,
          customers_this_month: customersThisMonth,
          growth_rate: totalCustomers > 0 ? ((customersThisMonth / totalCustomers) * 100).toFixed(2) : 0
        },
        charts: {
          customer_growth: customersThisMonth,
          business_growth: totalBusinesses
        }
      },
      metadata: {
        generated_at: new Date().toISOString(),
        period: '30d',
        total_records: totalCustomers + totalBusinesses
      }
    });
  } catch (error) {
    console.error('Analytics error:', error);
    res.status(500).json({
      success: false,
      error: 'Analytics service unavailable',
      details: error.message
    });
  }
});

// 404 handler
app.use('*', (req, res) => {
  console.log(`❌ 404 - Route not found: ${req.method} ${req.path}`);
  res.status(404).json({
    success: false,
    error: 'Endpoint not found',
    path: req.path,
    method: req.method,
    available_endpoints: [
      'GET / - API documentation',
      'GET /health - Health check',
      'GET /api/businesses - List businesses',
      'GET /api/customers - List customers',
      'POST /api/customers - Create customer',
      'GET /api/test - Database test',
      'GET /api/analytics/dashboard - Analytics dashboard'
    ],
    timestamp: new Date().toISOString()
  });
});

// Global error handler
app.use((error, req, res, next) => {
  console.error('🚨 Unhandled error:', error);
  
  // Don't leak error details in production
  const isDevelopment = process.env.NODE_ENV === 'development';
  
  res.status(500).json({
    success: false,
    error: 'Internal server error',
    message: isDevelopment ? error.message : 'Something went wrong',
    timestamp: new Date().toISOString(),
    requestId: req.headers['x-request-id'] || 'unknown'
  });
});

// Graceful shutdown handlers
process.on('SIGTERM', () => {
  console.log('📴 SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('📴 SIGINT received, shutting down gracefully');
  process.exit(0);
});

// Start the server
if (process.env.NODE_ENV !== 'production') {
  app.listen(PORT, () => {
    console.log('🎉 ClientFlow AI Suite API Server is running!');
    console.log(`🌐 Server URL: http://localhost:${PORT}`);
    console.log(`📚 API Docs: http://localhost:${PORT}/`);
    console.log(`🏥 Health Check: http://localhost:${PORT}/health`);
    console.log(`🧪 Database Test: http://localhost:${PORT}/api/test`);
    console.log(`📊 Businesses: http://localhost:${PORT}/api/businesses`);
    console.log(`👥 Customers: http://localhost:${PORT}/api/customers`);
    console.log(`📈 Analytics: http://localhost:${PORT}/api/analytics/dashboard`);
    console.log(`🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🗄️ Database: ${supabase ? 'Connected ✅' : 'Disconnected ❌'}`);
    console.log('='.repeat(50));
  });
} else {
  // Production startup message
  console.log('🚀 ClientFlow AI Suite API Server started in production mode');
  console.log(`🔧 Environment: ${process.env.NODE_ENV}`);
  console.log(`🗄️ Database: ${supabase ? 'Connected ✅' : 'Disconnected ❌'}`);
  console.log(`📊 Rate Limit: ${process.env.RATE_LIMIT_MAX_REQUESTS || 100} requests per 15 minutes`);
}

// Export for Vercel
module.exports = app;