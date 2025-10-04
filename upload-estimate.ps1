# 📊 GITHUB UPLOAD TIME ESTIMATOR
# Analyzes project size and estimates upload time

Write-Host "📊 CLIENTFLOW PROJECT UPLOAD ANALYSIS" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

# Project Analysis
$totalFiles = 6628
$totalSizeBytes = 37621103
$totalSizeMB = [math]::Round($totalSizeBytes / 1MB, 2)
$apiServerFiles = 1903
$apiServerSizeBytes = 10684278
$apiServerSizeMB = [math]::Round($apiServerSizeBytes / 1MB, 2)

Write-Host "`n📈 PROJECT STATISTICS:" -ForegroundColor Yellow
Write-Host "• Total Files: $totalFiles" -ForegroundColor White
Write-Host "• Total Size: $totalSizeMB MB" -ForegroundColor White
Write-Host "• API Server Files: $apiServerFiles" -ForegroundColor White
Write-Host "• API Server Size: $apiServerSizeMB MB" -ForegroundColor White

# Upload Time Estimates (based on different connection speeds)
$connectionSpeeds = @{
    "Slow (1 Mbps)" = @{ Speed = 1; Time = [math]::Round(($totalSizeMB * 8) / 1, 0) }
    "Medium (10 Mbps)" = @{ Speed = 10; Time = [math]::Round(($totalSizeMB * 8) / 10, 0) }
    "Fast (50 Mbps)" = @{ Speed = 50; Time = [math]::Round(($totalSizeMB * 8) / 50, 0) }
    "Very Fast (100 Mbps)" = @{ Speed = 100; Time = [math]::Round(($totalSizeMB * 8) / 100, 0) }
    "Gigabit (1000 Mbps)" = @{ Speed = 1000; Time = [math]::Round(($totalSizeMB * 8) / 1000, 0) }
}

Write-Host "`n⏱️ UPLOAD TIME ESTIMATES:" -ForegroundColor Yellow
foreach ($connection in $connectionSpeeds.GetEnumerator()) {
    $minutes = [math]::Round($connection.Value.Time / 60, 1)
    $seconds = $connection.Value.Time % 60
    $timeStr = if ($minutes -gt 0) { "$minutes min $seconds sec" } else { "$seconds sec" }
    
    $color = if ($connection.Value.Time -lt 60) { "Green" } 
             elseif ($connection.Value.Time -lt 300) { "Yellow" } 
             else { "Red" }
    
    Write-Host "• $($connection.Key): $timeStr" -ForegroundColor $color
}

# GitHub-specific considerations
Write-Host "`n🔍 GITHUB-SPECIFIC FACTORS:" -ForegroundColor Yellow
Write-Host "• Git compression reduces size by ~70%" -ForegroundColor White
Write-Host "• GitHub processes files in parallel" -ForegroundColor White
Write-Host "• Large files may be processed slower" -ForegroundColor White
Write-Host "• Authentication overhead: ~5-10 seconds" -ForegroundColor White

# Optimized upload time (with git compression)
$compressedSizeMB = [math]::Round($totalSizeMB * 0.3, 2)
Write-Host "`n📦 OPTIMIZED UPLOAD (with Git compression):" -ForegroundColor Yellow
Write-Host "• Compressed Size: ~$compressedSizeMB MB" -ForegroundColor White

foreach ($connection in $connectionSpeeds.GetEnumerator()) {
    $optimizedTime = [math]::Round(($compressedSizeMB * 8) / $connection.Value.Speed, 0)
    $minutes = [math]::Round($optimizedTime / 60, 1)
    $seconds = $optimizedTime % 60
    $timeStr = if ($minutes -gt 0) { "$minutes min $seconds sec" } else { "$seconds sec" }
    
    $color = if ($optimizedTime -lt 60) { "Green" } 
             elseif ($optimizedTime -lt 300) { "Yellow" } 
             else { "Red" }
    
    Write-Host "• $($connection.Key): $timeStr" -ForegroundColor $color
}

# Recommendations
Write-Host "`n💡 RECOMMENDATIONS:" -ForegroundColor Yellow
Write-Host "• Use the enhanced-upload.ps1 script for best performance" -ForegroundColor White
Write-Host "• Upload during off-peak hours for faster speeds" -ForegroundColor White
Write-Host "• Consider uploading in smaller chunks if connection is slow" -ForegroundColor White
Write-Host "• Use git push --progress to monitor upload progress" -ForegroundColor White

# Current git status
Write-Host "`n📋 CURRENT GIT STATUS:" -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "• Untracked files: $($gitStatus.Count)" -ForegroundColor White
    $gitStatus | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
} else {
    Write-Host "• Working directory clean" -ForegroundColor Green
}

Write-Host "`n🚀 READY TO UPLOAD!" -ForegroundColor Green
Write-Host "Run: .\enhanced-upload.ps1 -Deploy" -ForegroundColor Cyan
