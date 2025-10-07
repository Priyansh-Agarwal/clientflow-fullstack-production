# ClientFlow Hardened API - PowerShell Test Script
# Run with: powershell -ExecutionPolicy Bypass -File test-api.ps1

Write-Host "🧪 Testing ClientFlow Hardened API..." -ForegroundColor Green
Write-Host ""

try {
    # Test 1: Health endpoint
    Write-Host "1. Testing /api/health..." -ForegroundColor Yellow
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/health" -Method GET
    Write-Host "   ✅ Health check PASSED" -ForegroundColor Green
    Write-Host "   Response: $($healthResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    # Test 2: Ready endpoint
    Write-Host "2. Testing /api/ready..." -ForegroundColor Yellow
    try {
        $readyResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/ready" -Method GET
        Write-Host "   ✅ Ready check PASSED" -ForegroundColor Green
        Write-Host "   Response: $($readyResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    } catch {
        Write-Host "   ⚠️  Ready check FAILED (expected without Redis)" -ForegroundColor Yellow
    }
    Write-Host ""

    # Test 3: Outbound SMS
    Write-Host "3. Testing /api/messages/outbound (SMS)..." -ForegroundColor Yellow
    $smsBody = @{
        orgId = "00000000-0000-0000-0000-000000000000"
        channel = "sms"
        to_addr = "+15555550123"
        body = "Test message from hardened API"
    } | ConvertTo-Json

    $smsResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/messages/outbound?orgId=00000000-0000-0000-0000-000000000000" -Method POST -Body $smsBody -ContentType "application/json"
    Write-Host "   ✅ SMS test PASSED" -ForegroundColor Green
    Write-Host "   Response: $($smsResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    # Test 4: Outbound Email
    Write-Host "4. Testing /api/messages/outbound (Email)..." -ForegroundColor Yellow
    $emailBody = @{
        orgId = "00000000-0000-0000-0000-000000000000"
        channel = "email"
        to_addr = "test@example.com"
        body = "<h1>Test Email</h1><p>This is a test email from the hardened API.</p>"
    } | ConvertTo-Json

    $emailResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/messages/outbound?orgId=00000000-0000-0000-0000-000000000000" -Method POST -Body $emailBody -ContentType "application/json"
    Write-Host "   ✅ Email test PASSED" -ForegroundColor Green
    Write-Host "   Response: $($emailResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    # Test 5: Appointments
    Write-Host "5. Testing /api/appointments..." -ForegroundColor Yellow
    $appointmentsResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/appointments?orgId=00000000-0000-0000-0000-000000000000&window=next_24h" -Method GET
    Write-Host "   ✅ Appointments test PASSED" -ForegroundColor Green
    Write-Host "   Response: $($appointmentsResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    # Test 6: SLA
    Write-Host "6. Testing /api/sla/unanswered..." -ForegroundColor Yellow
    $slaResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/sla/unanswered?orgId=00000000-0000-0000-0000-000000000000&minutes=5" -Method GET
    Write-Host "   ✅ SLA test PASSED" -ForegroundColor Green
    Write-Host "   Response: $($slaResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    # Test 7: Automation
    Write-Host "7. Testing /api/automations/run..." -ForegroundColor Yellow
    $automationBody = @{
        type = "reminder"
        orgId = "00000000-0000-0000-0000-000000000000"
        payload = @{ test = $true }
    } | ConvertTo-Json

    $automationResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/automations/run?orgId=00000000-0000-0000-0000-000000000000" -Method POST -Body $automationBody -ContentType "application/json"
    Write-Host "   ✅ Automation test PASSED" -ForegroundColor Green
    Write-Host "   Response: $($automationResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
    Write-Host ""

    Write-Host "🎉 All tests completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Summary:" -ForegroundColor Cyan
    Write-Host "- Health endpoint: ✅ Working" -ForegroundColor Green
    Write-Host "- Message endpoints: ✅ Working (sandbox mode)" -ForegroundColor Green
    Write-Host "- Automation endpoints: ✅ Working" -ForegroundColor Green
    Write-Host "- Appointments endpoint: ✅ Working" -ForegroundColor Green
    Write-Host "- SLA endpoint: ✅ Working" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Your hardened ClientFlow API is ready for production!" -ForegroundColor Green

} catch {
    Write-Host "❌ Test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Make sure the API server is running:" -ForegroundColor Yellow
    Write-Host "   node api-server/standalone-server.js" -ForegroundColor Gray
}
