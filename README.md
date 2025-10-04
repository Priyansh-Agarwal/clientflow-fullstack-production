# 🚀 ClientFlow AI Suite - Production Ready

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Priyansh-Agarwal/clientflow-fullstack-production)
[![GitHub stars](https://img.shields.io/github/stars/Priyansh-Agarwal/clientflow-fullstack-production?style=social)](https://github.com/Priyansh-Agarwal/clientflow-fullstack-production)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Complete Full-Stack CRM Solution** with AI-powered business automation, built with React, TypeScript, Express.js, and Supabase.

## ✨ **Live Demo & Quick Deploy**

- 🌐 **Live Demo**: [Deploy Now with Vercel](https://vercel.com/new/clone?repository-url=https://github.com/Priyansh-Agarwal/clientflow-fullstack-production)
- 📚 **Documentation**: [Complete Deployment Guide](./DEPLOYMENT_GUIDE.md)
- 🎯 **One-Click Deploy**: Ready for Vercel, Netlify, Railway, and more!

## 🎯 **What's Included**

### 🖥️ **Frontend** (`clientflow-ai-suite-main/`)
- ✅ **Modern React 18** with TypeScript
- ✅ **Vite** for lightning-fast development
- ✅ **Tailwind CSS** for beautiful, responsive design
- ✅ **50+ Reusable Components** for rapid development
- ✅ **Supabase Auth** integration
- ✅ **Real-time Updates** with WebSocket support
- ✅ **Mobile-First Design** - works on all devices

### 🔧 **Backend API** (`api-server/`)
- ✅ **TypeScript Express.js** server
- ✅ **Supabase PostgreSQL** database
- ✅ **JWT Authentication** with role-based access
- ✅ **RESTful API** with comprehensive endpoints
- ✅ **File Upload** with secure storage
- ✅ **Webhook Integrations** (Twilio, Google Calendar)
- ✅ **Rate Limiting** and security headers
- ✅ **Health Monitoring** and error handling

### 🚀 **Production Ready** (`clientflow-fullstack-production/`)
- ✅ **Deployment Scripts** for all major platforms
- ✅ **Environment Configuration** for dev/prod
- ✅ **Docker Support** for containerized deployment
- ✅ **CI/CD Ready** with GitHub Actions
- ✅ **Monitoring & Logging** built-in

## 🚀 **Quick Start (2 Minutes)**

### **Option 1: Vercel (Recommended)**
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/Priyansh-Agarwal/clientflow-fullstack-production)

1. Click the "Deploy with Vercel" button above
2. Import your GitHub repository
3. Select `clientflow-fullstack-production` folder
4. Add environment variables (see below)
5. Deploy! 🎉

### **Option 2: Manual Setup**
```bash
# Clone the repository
git clone https://github.com/Priyansh-Agarwal/clientflow-fullstack-production.git
cd clientflow-fullstack-production

# Backend setup
cd api-server
npm install
cp env.example .env
# Edit .env with your Supabase credentials
npm run dev

# Frontend setup (new terminal)
cd ../clientflow-ai-suite-main
npm install
npm run dev
```

## 🔧 **Environment Variables**

### **Required for Production:**
```env
SUPABASE_URL=https://gmpsdeenhdtvbxjungxl.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1MzA2NjgsImV4cCI6MjA3NTEwNjY2OH0.C5sWEGKxDuSaD3xsui4YUKgGPhWrsDQ_C26yJMtkJc
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcHNkZWVuaGR0dmJ4anVuZ3hsIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTUzMDY2OCwiZXhwIjoyMDc1MTA2NjY4fQ.kIXgTLe10v3gRLtEYfeEJz8dHXZMuWARnUty6wNItHI
NODE_ENV=production
```

## 📊 **Core Features**

### 🏢 **Customer Management**
- Complete customer database with search and filtering
- Customer profiles with contact information
- Interaction history and notes
- Custom fields and tags

### 📅 **Appointment Scheduling**
- Calendar integration with Google Calendar
- Automated reminders and notifications
- Recurring appointments
- Time zone support

### 📞 **Call Tracking & Analytics**
- Twilio integration for call recording
- Call analytics and reporting
- Call quality metrics
- Automated call logging

### 👥 **Team Management**
- Role-based access control
- Team member invitations
- Permission management
- Activity tracking

### 📈 **Analytics Dashboard**
- Real-time business metrics
- Revenue tracking and forecasting
- Customer insights
- Performance KPIs

### 📁 **File Management**
- Secure file upload and storage
- Document organization
- Version control
- Access permissions

### 🔔 **Notifications**
- Real-time notifications
- Email alerts
- SMS notifications
- Custom notification rules

## 🛠️ **Tech Stack**

### **Frontend**
- **React 18** - Modern UI library
- **TypeScript** - Type-safe development
- **Vite** - Fast build tool
- **Tailwind CSS** - Utility-first CSS
- **Supabase** - Authentication & real-time

### **Backend**
- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **TypeScript** - Type safety
- **Supabase** - Database & auth
- **JWT** - Authentication tokens

### **Database**
- **PostgreSQL** - Relational database
- **Supabase** - Backend-as-a-Service
- **Row Level Security** - Data protection

### **Deployment**
- **Vercel** - Frontend hosting
- **Railway** - Backend hosting
- **Docker** - Containerization
- **GitHub Actions** - CI/CD

## 📚 **API Documentation**

### **Base URL**
- Development: `http://localhost:3001`
- Production: `https://your-domain.vercel.app`

### **Authentication**
All API endpoints require Bearer token authentication:
```bash
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     https://your-domain.vercel.app/api/customers
```

### **Core Endpoints**

#### **Health & Status**
- `GET /health` - API health check
- `GET /api/test` - Database connection test

#### **Customers**
- `GET /api/customers` - List customers
- `POST /api/customers` - Create customer
- `GET /api/customers/:id` - Get customer details
- `PUT /api/customers/:id` - Update customer
- `DELETE /api/customers/:id` - Delete customer

#### **Appointments**
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Create appointment
- `PUT /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Cancel appointment

#### **Analytics**
- `GET /api/analytics/dashboard` - Dashboard KPIs
- `GET /api/analytics/revenue` - Revenue analytics
- `GET /api/analytics/customers` - Customer analytics

## 🚀 **Deployment Options**

### **Vercel (Recommended)**
- ✅ One-click deployment
- ✅ Automatic HTTPS
- ✅ Global CDN
- ✅ Serverless functions

### **Netlify**
- ✅ Frontend hosting
- ✅ Form handling
- ✅ Edge functions

### **Railway**
- ✅ Backend hosting
- ✅ Database hosting
- ✅ Automatic deployments

### **Docker**
- ✅ Containerized deployment
- ✅ Scalable architecture
- ✅ Easy migration

## 🔒 **Security Features**

- ✅ **JWT Authentication** - Secure token-based auth
- ✅ **Role-Based Access Control** - Granular permissions
- ✅ **CORS Protection** - Cross-origin security
- ✅ **Rate Limiting** - API abuse prevention
- ✅ **Input Validation** - SQL injection protection
- ✅ **XSS Protection** - Cross-site scripting prevention
- ✅ **HTTPS Only** - Encrypted communication
- ✅ **Row Level Security** - Database-level protection

## 📈 **Performance**

- ✅ **Server-Side Rendering** - Fast initial load
- ✅ **Code Splitting** - Optimized bundle size
- ✅ **Caching** - Reduced server load
- ✅ **CDN** - Global content delivery
- ✅ **Database Indexing** - Fast queries
- ✅ **Image Optimization** - Compressed assets

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 **Support**

- 📧 **Email**: [theagarwalpriyansh@gmail.com](mailto:theagarwalpriyansh@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/Priyansh-Agarwal/clientflow-fullstack-production/issues)
- 📚 **Documentation**: [Deployment Guide](./DEPLOYMENT_GUIDE.md)

## 🌟 **Star History**

[![Star History Chart](https://api.star-history.com/svg?repos=Priyansh-Agarwal/clientflow-fullstack-production&type=Date)](https://star-history.com/#Priyansh-Agarwal/clientflow-fullstack-production&Date)

---

**Built with ❤️ by [Priyansh Agarwal](https://github.com/Priyansh-Agarwal)**

*Ready to transform your business with AI-powered CRM? [Deploy now!](https://vercel.com/new/clone?repository-url=https://github.com/Priyansh-Agarwal/clientflow-fullstack-production)* 🚀