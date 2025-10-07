# 🚀 ENHANCED GITHUB UPLOAD SYSTEM
# Advanced upload with real-time monitoring and automated deployment

param(
    [switch]$AutoCommit,
    [switch]$Deploy,
    [switch]$FullStack,
    [string]$CommitMessage = "",
    [string]$Environment = "production"
)

Write-Host "🚀 CLIENTFLOW ENHANCED UPLOAD SYSTEM" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

# Configuration
$config = @{
    RepoOwner = "Priyansh-Agarwal"
    RepoName = "clientflow-ai-suite"
    ApiServerPath = "api-server"
    FrontendPath = "clientflow-ai-suite-main"
    ProductionPath = "clientflow-fullstack-production"
    Branch = "main"
    VercelProject = "clientflow-ai-suite"
}

$colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
    Header = "Magenta"
    Process = "Blue"
}

function Write-ColorOutput {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Test-GitSetup {
    Write-ColorOutput "`n🔧 CHECKING GIT SETUP..." $colors.Header
    
    try {
        # Check git installation
        $gitVersion = git --version 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "❌ Git not found. Installing..." $colors.Error
            winget install --id Git.Git -e --silent --accept-package-agreements --accept-source-agreements
            Start-Sleep -Seconds 5
        } else {
            Write-ColorOutput "✅ Git available: $gitVersion" $colors.Success
        }
        
        # Check if we're in a git repo
        $isGitRepo = git rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-ColorOutput "❌ Not in a git repository. Initializing..." $colors.Warning
            git init
            git remote add origin "https://github.com/$($config.RepoOwner)/$($config.RepoName).git"
        } else {
            Write-ColorOutput "✅ In git repository" $colors.Success
        }
        
        return $true
    } catch {
        Write-ColorOutput "❌ Git setup failed: $($_.Exception.Message)" $colors.Error
        return $false
    }
}

function Get-ProjectStatus {
    Write-ColorOutput "`n📊 PROJECT STATUS ANALYSIS" $colors.Header
    
    $status = @{
        ApiServer = @{ Exists = $false; Files = 0; Modified = 0 }
        Frontend = @{ Exists = $false; Files = 0; Modified = 0 }
        Production = @{ Exists = $false; Files = 0; Modified = 0 }
    }
    
    # Check API Server
    if (Test-Path $config.ApiServerPath) {
        $status.ApiServer.Exists = $true
        $apiFiles = Get-ChildItem -Path $config.ApiServerPath -Recurse -File | Where-Object { $_.Name -notlike "node_modules*" }
        $status.ApiServer.Files = $apiFiles.Count
        
        $apiChanges = git status --porcelain $config.ApiServerPath 2>$null
        if ($apiChanges) {
            $status.ApiServer.Modified = ($apiChanges -split "`n").Count
        }
        
        Write-ColorOutput "📁 API Server: $($status.ApiServer.Files) files, $($status.ApiServer.Modified) modified" $colors.Info
    }
    
    # Check Frontend
    if (Test-Path $config.FrontendPath) {
        $status.Frontend.Exists = $true
        $frontendFiles = Get-ChildItem -Path $config.FrontendPath -Recurse -File | Where-Object { $_.Name -notlike "node_modules*" }
        $status.Frontend.Files = $frontendFiles.Count
        
        $frontendChanges = git status --porcelain $config.FrontendPath 2>$null
        if ($frontendChanges) {
            $status.Frontend.Modified = ($frontendChanges -split "`n").Count
        }
        
        Write-ColorOutput "🎨 Frontend: $($status.Frontend.Files) files, $($status.Frontend.Modified) modified" $colors.Info
    }
    
    # Check Production
    if (Test-Path $config.ProductionPath) {
        $status.Production.Exists = $true
        $prodFiles = Get-ChildItem -Path $config.ProductionPath -Recurse -File | Where-Object { $_.Name -notlike "node_modules*" }
        $status.Production.Files = $prodFiles.Count
        
        $prodChanges = git status --porcelain $config.ProductionPath 2>$null
        if ($prodChanges) {
            $status.Production.Modified = ($prodChanges -split "`n").Count
        }
        
        Write-ColorOutput "🚀 Production: $($status.Production.Files) files, $($status.Production.Modified) modified" $colors.Info
    }
    
    return $status
}

function Invoke-SmartCommit {
    param([string]$Message)
    
    Write-ColorOutput "`n💾 SMART COMMIT PROCESS" $colors.Header
    
    if (-not $Message) {
        $Message = "feat: Automated commit - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
    
    try {
        # Stage all changes
        Write-ColorOutput "📦 Staging all changes..." $colors.Process
        git add .
        
        # Check what's being committed
        $stagedFiles = git diff --cached --name-only
        if ($stagedFiles) {
            Write-ColorOutput "📋 Files to commit:" $colors.Info
            $stagedFiles | ForEach-Object { Write-ColorOutput "  + $_" $colors.Success }
        } else {
            Write-ColorOutput "ℹ️ No changes to commit" $colors.Warning
            return
        }
        
        # Commit with message
        Write-ColorOutput "💾 Committing changes..." $colors.Process
        git commit -m $Message
        
        Write-ColorOutput "✅ Commit successful: $Message" $colors.Success
        
    } catch {
        Write-ColorOutput "❌ Commit failed: $($_.Exception.Message)" $colors.Error
    }
}

function Invoke-SmartPush {
    Write-ColorOutput "`n🚀 SMART PUSH PROCESS" $colors.Header
    
    try {
        # Get current branch
        $currentBranch = git branch --show-current
        Write-ColorOutput "📍 Pushing to branch: $currentBranch" $colors.Info
        
        # Push to remote
        Write-ColorOutput "🚀 Pushing to GitHub..." $colors.Process
        git push origin $currentBranch
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "`n🎉 UPLOAD SUCCESSFUL!" $colors.Success
            Write-ColorOutput "✅ All changes pushed to GitHub" $colors.Success
            Write-ColorOutput "🔗 Repository: https://github.com/$($config.RepoOwner)/$($config.RepoName)" $colors.Info
            Write-ColorOutput "🌐 Branch: $currentBranch" $colors.Info
            
            # Show deployment options
            Write-ColorOutput "`n🚀 DEPLOYMENT OPTIONS:" $colors.Header
            Write-ColorOutput "• Vercel: https://vercel.com/new" $colors.Info
            Write-ColorOutput "• Netlify: https://app.netlify.com" $colors.Info
            Write-ColorOutput "• Railway: https://railway.app" $colors.Info
            
        } else {
            Write-ColorOutput "❌ Push failed - check authentication" $colors.Error
            Write-ColorOutput "💡 Try: git config --global user.name 'Your Name'" $colors.Warning
            Write-ColorOutput "💡 Try: git config --global user.email 'your.email@example.com'" $colors.Warning
        }
        
    } catch {
        Write-ColorOutput "❌ Push failed: $($_.Exception.Message)" $colors.Error
    }
}

function Start-AutoCommit {
    Write-ColorOutput "`n🔄 STARTING AUTO-COMMIT MODE" $colors.Header
    Write-ColorOutput "Watching for changes and auto-committing..." $colors.Info
    Write-ColorOutput "Press Ctrl+C to stop" $colors.Warning
    
    $lastCommit = Get-Date
    $commitInterval = 300 # 5 minutes
    
    while ($true) {
        Start-Sleep -Seconds 30
        
        # Check for changes
        $changes = git status --porcelain
        if ($changes -and ((Get-Date) - $lastCommit).TotalSeconds -gt $commitInterval) {
            Write-ColorOutput "`n📝 Changes detected - auto-committing..." $colors.Warning
            Invoke-SmartCommit -Message "auto: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Invoke-SmartPush
            $lastCommit = Get-Date
        }
    }
}

# Main execution
Write-ColorOutput "🚀 Starting Enhanced Upload System..." $colors.Header

# Setup checks
if (-not (Test-GitSetup)) {
    Write-ColorOutput "❌ Git setup failed. Exiting." $colors.Error
    exit 1
}

# Show project status
$projectStatus = Get-ProjectStatus

# Execute based on parameters
if ($AutoCommit) {
    Start-AutoCommit
} elseif ($Deploy) {
    Invoke-SmartCommit -Message $CommitMessage
    Invoke-SmartPush
} else {
    # Default: commit and push
    Invoke-SmartCommit -Message $CommitMessage
    Invoke-SmartPush
}

Write-ColorOutput "`n✨ Enhanced Upload System Complete!" $colors.Success
