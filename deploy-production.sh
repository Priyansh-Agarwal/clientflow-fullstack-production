#!/bin/bash

# ClientFlow AI Suite - Production Deployment Script
# This script deploys the complete ClientFlow AI Suite with all automation features

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="clientflow-ai-suite"
DOMAIN="${DOMAIN:-your-domain.com}"
EMAIL="${EMAIL:-admin@your-domain.com}"

echo -e "${BLUE}🚀 ClientFlow AI Suite - Production Deployment${NC}"
echo "=================================================="

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
print_status "Creating project directories..."
mkdir -p logs/nginx
mkdir -p nginx/ssl
mkdir -p monitoring/prometheus
mkdir -p monitoring/grafana/dashboards
mkdir -p monitoring/grafana/datasources
mkdir -p n8n/workflows
mkdir -p n8n/credentials

# Generate SSL certificates (self-signed for development)
print_status "Generating SSL certificates..."
if [ ! -f "nginx/ssl/cert.pem" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout nginx/ssl/key.pem \
        -out nginx/ssl/cert.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=${DOMAIN}"
    print_status "SSL certificates generated"
else
    print_warning "SSL certificates already exist"
fi

# Create Nginx configuration
print_status "Creating Nginx configuration..."
cat > nginx/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    upstream api {
        server api-server:3000;
    }
    
    upstream n8n {
        server n8n:5678;
    }
    
    upstream frontend {
        server frontend:3000;
    }

    # Rate limiting
    limit_req_zone \$binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone \$binary_remote_addr zone=webhook:10m rate=5r/s;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

    # Security headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # API Server
    server {
        listen 80;
        server_name api.${DOMAIN};
        
        # Redirect HTTP to HTTPS
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name api.${DOMAIN};

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;

        # API routes
        location / {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://api;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }

        # Webhook routes (higher rate limit)
        location /api/webhooks/ {
            limit_req zone=webhook burst=10 nodelay;
            proxy_pass http://api;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }

    # n8n Workflow Engine
    server {
        listen 80;
        server_name n8n.${DOMAIN};
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name n8n.${DOMAIN};

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;

        location / {
            proxy_pass http://n8n;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }

    # Frontend
    server {
        listen 80;
        server_name ${DOMAIN};
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name ${DOMAIN};

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;

        location / {
            proxy_pass http://frontend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }

    # Monitoring
    server {
        listen 80;
        server_name monitor.${DOMAIN};
        return 301 https://\$server_name\$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name monitor.${DOMAIN};

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;

        location / {
            proxy_pass http://grafana:3000;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

# Create Prometheus configuration
print_status "Creating Prometheus configuration..."
cat > monitoring/prometheus.yml << EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: 'clientflow-api'
    static_configs:
      - targets: ['api-server:3000']
    metrics_path: '/metrics'
    scrape_interval: 5s

  - job_name: 'n8n'
    static_configs:
      - targets: ['n8n:5678']
    metrics_path: '/metrics'
    scrape_interval: 30s

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:5432']
    scrape_interval: 30s

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:6379']
    scrape_interval: 30s
EOF

# Create Grafana datasource configuration
print_status "Creating Grafana configuration..."
cat > monitoring/grafana/datasources/prometheus.yml << EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

# Create environment file if it doesn't exist
if [ ! -f ".env" ]; then
    print_status "Creating environment file..."
    cp env.production .env
    print_warning "Please edit .env file with your actual configuration values"
fi

# Build and start services
print_status "Building Docker images..."
docker-compose -f docker-compose.production.yml build

print_status "Starting services..."
docker-compose -f docker-compose.production.yml up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Check service health
print_status "Checking service health..."

# Check API server
if curl -f http://localhost:3000/health > /dev/null 2>&1; then
    print_status "API server is healthy"
else
    print_error "API server is not responding"
fi

# Check n8n
if curl -f http://localhost:5678 > /dev/null 2>&1; then
    print_status "n8n is healthy"
else
    print_error "n8n is not responding"
fi

# Check database
if docker-compose -f docker-compose.production.yml exec -T postgres pg_isready -U clientflow > /dev/null 2>&1; then
    print_status "PostgreSQL is healthy"
else
    print_error "PostgreSQL is not responding"
fi

# Check Redis
if docker-compose -f docker-compose.production.yml exec -T redis redis-cli ping > /dev/null 2>&1; then
    print_status "Redis is healthy"
else
    print_error "Redis is not responding"
fi

# Display deployment information
echo ""
echo -e "${GREEN}🎉 ClientFlow AI Suite deployed successfully!${NC}"
echo "=================================================="
echo ""
echo -e "${BLUE}Access URLs:${NC}"
echo "  • Frontend: https://${DOMAIN}"
echo "  • API: https://api.${DOMAIN}"
echo "  • n8n Workflows: https://n8n.${DOMAIN}"
echo "  • Monitoring: https://monitor.${DOMAIN}"
echo ""
echo -e "${BLUE}Default Credentials:${NC}"
echo "  • n8n: admin / (check .env file)"
echo "  • Grafana: admin / (check .env file)"
echo ""
echo -e "${BLUE}API Endpoints:${NC}"
echo "  • Health Check: https://api.${DOMAIN}/health"
echo "  • Voice Calls: https://api.${DOMAIN}/api/voice/incoming"
echo "  • WhatsApp: https://api.${DOMAIN}/api/whatsapp/webhook"
echo "  • Automation: https://api.${DOMAIN}/api/automation/workflows"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Update your DNS records to point to this server"
echo "2. Configure SSL certificates (Let's Encrypt recommended)"
echo "3. Set up external service integrations (Twilio, WhatsApp, OpenAI)"
echo "4. Import n8n workflows from ./n8n/workflows/"
echo "5. Configure monitoring dashboards in Grafana"
echo ""
echo -e "${GREEN}Deployment completed! 🚀${NC}"

