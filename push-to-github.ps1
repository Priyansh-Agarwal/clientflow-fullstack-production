# ClientFlow n8n Automation Integration - Git Push Script (PowerShell)
# This script will commit and push all the new automation features to GitHub

Write-Host "🚀 Starting ClientFlow n8n Automation Integration Push" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Not in a git repository. Initializing..." -ForegroundColor Red
    git init
    git remote add origin https://github.com/Priyansh-Agarwal/clientflow-fullstack-production.git
}

# Check if remote exists
try {
    git remote get-url origin | Out-Null
} catch {
    Write-Host "📡 Adding remote origin..." -ForegroundColor Yellow
    git remote add origin https://github.com/Priyansh-Agarwal/clientflow-fullstack-production.git
}

# Fetch latest changes
Write-Host "📥 Fetching latest changes from GitHub..." -ForegroundColor Blue
git fetch origin

# Check current branch
$CURRENT_BRANCH = git branch --show-current
Write-Host "📍 Current branch: $CURRENT_BRANCH" -ForegroundColor Cyan

# Create new branch for automation features
$FEATURE_BRANCH = "feature/n8n-automation-integration"
Write-Host "🌿 Creating feature branch: $FEATURE_BRANCH" -ForegroundColor Magenta
try {
    git checkout -b $FEATURE_BRANCH
} catch {
    git checkout $FEATURE_BRANCH
}

# Add all new files
Write-Host "📁 Adding all new files..." -ForegroundColor Blue
git add .

# Check what files are being added
Write-Host "📋 Files to be committed:" -ForegroundColor Yellow
git status --porcelain

# Create comprehensive commit message
$COMMIT_MESSAGE = @"
feat: Complete n8n automation integration

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

This update makes ClientFlow CRM a complete automation platform ready for production deployment with full n8n integration.
"@

# Commit changes
Write-Host "💾 Committing changes..." -ForegroundColor Green
git commit -m $COMMIT_MESSAGE

# Push to GitHub
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Green
git push origin $FEATURE_BRANCH

Write-Host ""
Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
Write-Host "🔗 View your changes at: https://github.com/Priyansh-Agarwal/clientflow-fullstack-production" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to GitHub and create a Pull Request from $FEATURE_BRANCH to main" -ForegroundColor White
Write-Host "2. Review the changes and merge the PR" -ForegroundColor White
Write-Host "3. Update your README.md to showcase the new automation features" -ForegroundColor White
Write-Host "4. Create a release with the new features" -ForegroundColor White
Write-Host ""
Write-Host "🎉 Your ClientFlow CRM now has complete n8n automation integration!" -ForegroundColor Green
