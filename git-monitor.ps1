# 🚀 REAL-TIME GIT MONITOR & UPLOAD SYSTEM
# Monitors git changes and provides automated upload functionality

param(
    [switch]$Watch,
    [switch]$Upload,
    [switch]$Status,
    [string]$Message = "Auto-commit: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

Write-Host "🔍 CLIENTFLOW GIT MONITOR & UPLOAD SYSTEM" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan

# Configuration
$repoOwner = "Priyansh-Agarwal"
$repoName = "clientflow-ai-suite"
$repoUrl = "https://github.com/$repoOwner/$repoName.git"
$branch = "main"

# Colors for output
$colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Header = "Magenta"
}

function Write-ColorOutput {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Get-GitStatus {
    Write-ColorOutput "`n📊 CURRENT GIT STATUS" $colors.Header
    
    # Check if we're in a git repository
    try {
        $gitStatus = git status --porcelain 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "❌ Not in a git repository" $colors.Error
            return $false
        }
        
        # Show current branch
        $currentBranch = git branch --show-current 2>$null
        Write-ColorOutput "📍 Current Branch: $currentBranch" $colors.Info
        
        # Show status
        if ($gitStatus) {
            Write-ColorOutput "📝 Modified/New Files:" $colors.Warning
            $gitStatus | ForEach-Object {
                $status = $_.Substring(0,2)
                $file = $_.Substring(3)
                $color = if ($status -match "A|M") { $colors.Success } else { $colors.Warning }
                Write-ColorOutput "  $status $file" $color
            }
        } else {
            Write-ColorOutput "✅ Working directory clean" $colors.Success
        }
        
        # Show last commit
        $lastCommit = git log -1 --oneline 2>$null
        if ($lastCommit) {
            Write-ColorOutput "📋 Last Commit: $lastCommit" $colors.Info
        }
        
        return $true
    } catch {
        Write-ColorOutput "❌ Error checking git status: $($_.Exception.Message)" $colors.Error
        return $false
    }
}

function Start-FileWatcher {
    Write-ColorOutput "`n👀 STARTING FILE WATCHER..." $colors.Header
    Write-ColorOutput "Watching for changes in: $(Get-Location)" $colors.Info
    Write-ColorOutput "Press Ctrl+C to stop watching" $colors.Warning
    
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = Get-Location
    $watcher.Filter = "*.*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
    # Register event handlers
    Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action {
        $path = $Event.SourceEventArgs.FullPath
        $changeType = $Event.SourceEventArgs.ChangeType
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$timestamp] 📝 $changeType: $path" -ForegroundColor Yellow
    }
    
    Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action {
        $path = $Event.SourceEventArgs.FullPath
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$timestamp] ➕ CREATED: $path" -ForegroundColor Green
    }
    
    Register-ObjectEvent -InputObject $watcher -EventName "Deleted" -Action {
        $path = $Event.SourceEventArgs.FullPath
        $timestamp = Get-Date -Format "HH:mm:ss"
        Write-Host "[$timestamp] ❌ DELETED: $path" -ForegroundColor Red
    }
    
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        $watcher.Dispose()
        Get-EventSubscriber | Unregister-Event
    }
}

function Invoke-GitUpload {
    Write-ColorOutput "`n🚀 STARTING GIT UPLOAD..." $colors.Header
    
    # Check git status first
    if (-not (Get-GitStatus)) {
        return
    }
    
    try {
        # Add all changes
        Write-ColorOutput "📦 Adding all changes..." $colors.Info
        git add .
        
        # Check if there are changes to commit
        $status = git status --porcelain
        if (-not $status) {
            Write-ColorOutput "ℹ️ No changes to commit" $colors.Warning
            return
        }
        
        # Commit changes
        Write-ColorOutput "💾 Committing changes..." $colors.Info
        git commit -m $Message
        
        # Push to remote
        Write-ColorOutput "🚀 Pushing to remote repository..." $colors.Info
        git push origin $branch
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "`n🎉 SUCCESS!" $colors.Success
            Write-ColorOutput "✅ All changes uploaded to GitHub!" $colors.Success
            Write-ColorOutput "🔗 Repository: https://github.com/$repoOwner/$repoName" $colors.Info
            Write-ColorOutput "🌐 Branch: $branch" $colors.Info
        } else {
            Write-ColorOutput "❌ Push failed - check authentication and network" $colors.Error
        }
        
    } catch {
        Write-ColorOutput "❌ Upload failed: $($_.Exception.Message)" $colors.Error
    }
}

function Show-Help {
    Write-ColorOutput "`n📖 USAGE:" $colors.Header
    Write-ColorOutput "  .\git-monitor.ps1 -Watch     # Start file watcher" $colors.Info
    Write-ColorOutput "  .\git-monitor.ps1 -Upload    # Upload current changes" $colors.Info
    Write-ColorOutput "  .\git-monitor.ps1 -Status    # Show git status" $colors.Info
    Write-ColorOutput "  .\git-monitor.ps1 -Upload -Message 'Custom message'" $colors.Info
    Write-ColorOutput "`n💡 TIPS:" $colors.Header
    Write-ColorOutput "  • Use -Watch to monitor file changes in real-time" $colors.Info
    Write-ColorOutput "  • Use -Upload to commit and push changes" $colors.Info
    Write-ColorOutput "  • Use -Status to check current git state" $colors.Info
}

# Main execution
if ($Status) {
    Get-GitStatus
} elseif ($Upload) {
    Invoke-GitUpload
} elseif ($Watch) {
    Start-FileWatcher
} else {
    Show-Help
}

Write-ColorOutput "`n✨ Git Monitor & Upload System Ready!" $colors.Success
