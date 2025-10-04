import app from './config/server';
import customersRouter from './routes/customers';
import appointmentsRouter from './routes/appointments';
import conversationsRouter from './routes/conversations';
import callsRouter from './routes/calls';
import reviewsRouter from './routes/reviews';
import servicesRouter from './routes/services';
import analyticsRouter from './routes/analytics';
import teamMembersRouter from './routes/teamMembers';
import uploadRouter from './routes/upload';
import notificationsRouter from './routes/notifications';
import webhooksRouter from './routes/webhooks';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';

const PORT = process.env.PORT || 3001;

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
  });
});

// API routes
app.use('/api/customers', customersRouter);
app.use('/api/appointments', appointmentsRouter);
app.use('/api/conversations', conversationsRouter);
app.use('/api/calls', callsRouter);
app.use('/api/reviews', reviewsRouter);
app.use('/api/services', servicesRouter);
app.use('/api/analytics', analyticsRouter);
app.use('/api/team-members', teamMembersRouter);
app.use('/api/upload', uploadRouter);
app.use('/api/notifications', notificationsRouter);
app.use('/api/webhooks', webhooksRouter);

// API documentation endpoint
app.get('/api', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Customer, Appointment, Conversation, Call, Review & Service Management API',
    version: '1.0.0',
    endpoints: {
      customers: {
        'POST /api/customers': 'Create a new customer',
        'GET /api/customers': 'Get paginated list of customers with search',
        'GET /api/customers/:id': 'Get a single customer by ID',
        'PUT /api/customers/:id': 'Update a customer',
        'DELETE /api/customers/:id': 'Delete a customer',
      },
      appointments: {
        'POST /api/appointments': 'Create a new appointment',
        'GET /api/appointments': 'Get paginated list of appointments with filtering',
        'GET /api/appointments/:id': 'Get a single appointment by ID',
        'PUT /api/appointments/:id': 'Update an appointment (service_type, scheduled_at, duration)',
        'PUT /api/appointments/:id/status': 'Update appointment status with SMS notifications',
        'DELETE /api/appointments/:id': 'Cancel an appointment',
      },
      conversations: {
        'POST /api/conversations': 'Create a new conversation thread',
        'GET /api/conversations': 'Get paginated list of conversations with filtering',
        'GET /api/conversations/:id': 'Get a single conversation by ID',
        'PUT /api/conversations/:id': 'Update a conversation',
        'PUT /api/conversations/:id/read': 'Mark conversation messages as read',
        'PUT /api/conversations/:id/assign': 'Assign conversation to agent',
        'DELETE /api/conversations/:id': 'Close/delete a conversation',
        'GET /api/conversations/:id/messages': 'Get messages for a conversation ordered by created_at',
        'POST /api/conversations/:id/messages': 'Append a message to the conversation thread',
        'GET /api/conversations/stats': 'Get conversation statistics',
      },
      calls: {
        'POST /api/calls': 'Create a new call record',
        'GET /api/calls': 'Get paginated list of calls with filtering',
        'GET /api/calls/:id': 'Get a single call by ID',
        'PUT /api/calls/:id': 'Update a call record (outcome, duration, transcript)',
        'PUT /api/calls/:id/transcript': 'Update call transcript',
        'GET /api/calls/:id/recording': 'Get call recording URL',
        'POST /api/calls/:id/recording': 'Upload call recording file with verification',
        'DELETE /api/calls/:id': 'Delete a call record',
        'GET /api/calls/stats': 'Get call statistics',
        'POST /api/calls/webhook/twilio': 'Twilio webhook handler for call status updates',
        'POST /api/calls/webhook/twilio/recording': 'Twilio webhook handler for recording completion',
      },
      reviews: {
        'POST /api/reviews': 'Create a new review',
        'GET /api/reviews': 'Get paginated list of reviews with filtering',
        'GET /api/reviews/:id': 'Get a single review by ID',
        'PUT /api/reviews/:id': 'Update a review (admin only)',
        'PUT /api/reviews/:id/respond': 'Add response to review (admin/owner only)',
        'DELETE /api/reviews/:id': 'Delete a review (owner only)',
        'GET /api/reviews/stats': 'Get review statistics',
        'GET /api/reviews/recent': 'Get recent reviews for dashboard',
        'POST /api/reviews/bulk-update': 'Bulk update reviews (admin only)',
      },
      services: {
        'POST /api/services': 'Create a new service (admin/owner only)',
        'GET /api/services': 'Get paginated list of services with filtering',
        'GET /api/services/:id': 'Get a single service by ID',
        'PUT /api/services/:id': 'Update a service (admin/owner)',
        'PUT /api/services/:id/toggle-status': 'Toggle service active/inactive status',
        'DELETE /api/services/:id': 'Delete a service (owner only)',
        'GET /api/services/stats': 'Get service statistics',
        'GET /api/services/category/:category': 'Get services filtered by category',
        'GET /api/services/popular': 'Get popular services',
        'POST /api/services/bulk-update': 'Bulk update services (owner only)',
      },
      analytics: {
        'GET /api/analytics/dashboard': 'Comprehensive dashboard KPIs with SQL aggregation',
        'GET /api/analytics/calls': 'Call-specific analytics with outcome distribution',
        'GET /api/analytics/revenue': 'Revenue analytics with trends and growth calculations',
        'GET /api/analytics/appointments': 'Appointment analytics with conversion metrics', 
        'GET /api/analytics/realtime': 'Real-time dashboard metrics for today',
        'GET /api/analytics/export': 'Export analytics data in JSON/CSV format',
        'GET /api/analytics/health': 'Analytics system health check',
      },
      teamMembers: {
        'GET /api/team-members': 'Get all team members with roles and profile data',
        'GET /api/team-members/stats': 'Get team member statistics',
        'GET /api/team-members/my-role': "Get current user's role and permissions",
        'GET /api/team-members/permissions': 'Get available permissions for each role',
        'POST /api/team-members': 'Invite new member via email (admin/owner only)',
        'PUT /api/team-members/:id': 'Update member role/permissions (admin/owner only)',
        'DELETE /api/team-members/:id': 'Remove team member (admin/owner only)',
        'POST /api/team-members/bulk-update': 'Bulk update multiple members',
        'POST /api/team-members/resend-invitation': 'Resend invitation (admin/owner only)',
        'POST /api/team-members/transfer-ownership': 'Transfer ownership (owner only)',
        'GET /api/team-members/invitation-status': 'Check invitation status by email',
        'GET /api/team-members/export': 'Export team data (JSON/CSV)',
        'GET /api/team-members/health': 'Team management health check',
      },
      upload: {
        'POST /api/upload/files': 'Upload files to Supabase Storage under business_id folder',
        'GET /api/upload/files': 'Get uploaded files with filtering and pagination',
        'GET /api/upload/files/:id': 'Get specific uploaded file details',
        'DELETE /api/upload/files/:id': 'Delete uploaded file from storage and database',
        'GET /api/upload/files/stats': 'Get file upload statistics and analytics',
        'GET /api/upload/files/:id/download': 'Get signed URL for secure file download',
        'POST /api/upload/folders': 'Create folder for file organization',
        'GET /api/upload/health': 'File upload system health check',
      },
      notifications: {
        'GET /api/notifications': 'Retrieve unread notifications for authenticated user',
        'PUT /api/notifications/:id/read': 'Mark notification as read by setting read_at timestamp',
        'POST /api/notifications/bulk-action': 'Perform bulk operations on notifications',
        'GET /api/notifications/stats': 'Get notification statistics and analytics',
        'POST /api/notifications/create': 'Create new notification (admin/system use)',
        'DELETE /api/notifications/:id': 'Delete notification permanently',
        'GET /api/notifications/unread-count': 'Get unread notifications count',
        'GET /api/notifications/types': 'Get available notification types and descriptions',
        'GET /api/notifications/health': 'Notifications system health check',
        'POST /api/notifications/cleanup': 'Clean up expired notifications (admin use)',
      },
      webhooks: {
        'POST /api/webhooks/twilio': 'Receive call status updates from Twilio',
        'POST /api/webhooks/google-calendar': 'Listen for calendar events from Google Calendar',
        'POST /api/webhooks/sms-provider': 'Receive delivery reports from SMS provider',
        'POST /api/webhooks/review-platforms': 'Ingest new reviews from Google/Yelp',
        'GET /api/webhooks/health': 'Webhook system health check',
        'GET /api/webhooks/logs': 'Get webhook processing audit logs (admin)',
        'GET /api/webhooks/config': 'Get webhook configuration information',
        'GET /api/webhooks/stats': 'Get webhook processing statistics',
        'POST /api/webhooks/test': 'Test webhook processing (development only)',
      },
    },
    authentication: 'Bearer token required for all endpoints (except webhooks)',
  });
});

// 404 handler for undefined routes
app.use('*', notFoundHandler);

// Global error handler (must be last)
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`✓ Health check: http://localhost:${PORT}/health`);
  console.log(`📚 API docs: http://localhost:${PORT}/api`);
  console.log(`💼 Customer endpoints: http://localhost:${PORT}/api/customers`);
  console.log(`📅 Appointment endpoints: http://localhost:${PORT}/api/appointments`);
  console.log(`💬 Conversation endpoints: http://localhost:${PORT}/api/conversations`);
  console.log(`📞 Call endpoints: http://localhost:${PORT}/api/calls`);
  console.log(`⭐ Review endpoints: http://localhost:${PORT}/api/reviews`);
  console.log(`🛠️ Service endpoints: http://localhost:${PORT}/api/services`);
  console.log(`📊 Analytics endpoints: http://localhost:${PORT}/api/analytics`);
  console.log(`👥 Team management endpoints: http://localhost:${PORT}/api/team-members`);
  console.log(`📁 File upload endpoints: http://localhost:${PORT}/api/upload`);
  console.log(`🔔 Notification endpoints: http://localhost:${PORT}/api/notifications`);
  console.log(`🪝 Webhook endpoints: http://localhost:${PORT}/api/webhooks`);
  
  if (process.env.NODE_ENV === 'development') {
    console.log(`\n🛠️  Development mode enabled`);
    console.log(`📝 Environment: ${process.env.NODE_ENV}`);
  }
});

// Graceful shutdown handling
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  process.exit(0);
});

export default app;
