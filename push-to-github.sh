#!/bin/bash

# ClientFlow n8n Automation Integration - Git Push Script
# This script will commit and push all the new automation features to GitHub

set -e  # Exit on any error

echo "🚀 Starting ClientFlow n8n Automation Integration Push"
echo "=================================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Initializing..."
    git init
    git remote add origin https://github.com/Priyansh-Agarwal/clientflow-fullstack-production.git
fi

# Check if remote exists
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "📡 Adding remote origin..."
    git remote add origin https://github.com/Priyansh-Agarwal/clientflow-fullstack-production.git
fi

# Fetch latest changes
echo "📥 Fetching latest changes from GitHub..."
git fetch origin

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

# Create new branch for automation features
FEATURE_BRANCH="feature/n8n-automation-integration"
echo "🌿 Creating feature branch: $FEATURE_BRANCH"
git checkout -b $FEATURE_BRANCH 2>/dev/null || git checkout $FEATURE_BRANCH

# Add all new files
echo "📁 Adding all new files..."
git add .

# Check what files are being added
echo "📋 Files to be committed:"
git status --porcelain

# Create comprehensive commit message
COMMIT_MESSAGE="feat: Complete n8n automation integration

🤖 Added comprehensive n8n workflow integration with 6 automation workflows:

📋 New API Endpoints:
- POST /api/messages/outbound - Send SMS/email messages
- GET /api/appointments?window=next_24h - Get upcoming appointments
- GET /api/appointments?status=completed&within=1d - Get completed appointments
- GET /api/sla/unanswered?minutes=5 - SLA monitoring
- POST /api/automations/sms_inbound - SMS inbound proxy
- POST /api/automations/email_inbound - Email inbound proxy
- POST /api/automations/run - Enqueue automation jobs
- GET /api/automations/presets - Get automation presets

🔧 Worker Implementation:
- BullMQ queues: reminders, nurture, dunning, snapshots
- Job processors for all automation types
- Scheduled cron jobs for automated tasks
- Retry logic with exponential backoff

📱 n8n Workflows (6 complete workflows):
- 01_Booking_Reschedule.json - AI-powered SMS booking
- 02_Reminders_NoShow.json - Automated reminders
- 03_Reviews_Reputation.json - Review requests
- 04_Dunning_Stripe.json - Payment failure handling
- 05_Nurture_Drip.json - Lead nurturing campaigns
- 06_SLA_Escalation.json - Response time monitoring

🛠️ Services & Integrations:
- Twilio SMS service with webhook verification
- SendGrid email service with inbound parse
- Stripe webhook handling for payments
- Google Calendar integration
- OpenAI integration for AI processing

🧪 Testing & Validation:
- Comprehensive E2E tests for all endpoints
- Smoke test script for end-to-end validation
- Webhook signature verification
- Sandbox mode for development

📚 Documentation:
- Complete n8n setup guide
- Webhook configuration instructions
- Environment variable documentation
- Troubleshooting guide

🔒 Security Features:
- Webhook signature verification
- PII redaction in logs
- Rate limiting and CORS protection
- Input validation and sanitization

This update makes ClientFlow CRM a complete automation platform ready for production deployment with full n8n integration."

# Commit changes
echo "💾 Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin $FEATURE_BRANCH

echo ""
echo "✅ Successfully pushed to GitHub!"
echo "🔗 View your changes at: https://github.com/Priyansh-Agarwal/clientflow-fullstack-production"
echo ""
echo "📋 Next steps:"
echo "1. Go to GitHub and create a Pull Request from $FEATURE_BRANCH to main"
echo "2. Review the changes and merge the PR"
echo "3. Update your README.md to showcase the new automation features"
echo "4. Create a release with the new features"
echo ""
echo "🎉 Your ClientFlow CRM now has complete n8n automation integration!"
