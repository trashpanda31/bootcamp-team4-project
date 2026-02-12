# ☁️ Bootcamp Team 4 – DevOps Project

## Project Overview

This project was developed during the DevOps Bootcamp by **Team 4**.

The goal was to design and implement a **production-style, scalable, and fully automated WordPress platform** using modern DevOps practices and cloud technologies.

---

## 🎯 Project Goals

The system is designed to be:

- Automatically scalable during traffic spikes  
- Fully containerized for consistency  
- Deployed automatically 
- Always available (24/7)  
- Cost-efficient and production-oriented  

---

## 🏗 System Architecture

The platform runs on **AWS multi-AZ high availability architecture**.

### Traffic Flow


### Core Components

- Application Load Balancer distributes traffic  
- Auto Scaling Group launches instances automatically  
- Docker container runs WordPress on every instance  
- AWS ECR stores container images  
- AWS Secrets Manager stores DB credentials  
- Terraform provisions infrastructure  
- GitHub Actions handles CI/CD & deployment  

---

## ⚙️ Tech Stack

### Infrastructure
- AWS (VPC, ALB, ASG, EC2, ECR, CloudWatch, Secrets Manager)  
- Terraform (Infrastructure as Code)  
- Docker (Containerized WordPress)  
- Private Subnets + NAT Gateway  

### CI/CD
- GitHub Actions  
- Docker Buildx  
- AWS OIDC authentication  
- Rolling deployment via ASG Instance Refresh  

### Application
- WordPress (Docker)  
- MySQL / RDS (Secrets Manager credentials)  

---

## ☁️ Infrastructure (Terraform)

Infrastructure is fully defined as code.

### Networking
- Custom VPC: `10.40.0.0/16`  
- Public subnets → Load Balancer  
- Private subnets → Application instances  
- NAT Gateway for outbound traffic  
- Internet Gateway for public access  

### Load Balancing
- Application Load Balancer (HTTP :80)  
- Sticky sessions enabled  
- Health checks enabled  

### Auto Scaling
- Min: **1**  
- Desired: **1**  
- Max: **3**  
- Rolling instance refresh during deployment  

### Monitoring

CloudWatch alarms:

- High CPU usage  
- Instance health failures  

---

## 📦 Containerization

WordPress runs inside Docker on every instance.

### Dockerfile

Based on:


### Instance Boot Process

1. Install Docker  
2. Authenticate to AWS ECR  
3. Pull latest production image  
4. Retrieve DB credentials from Secrets Manager  
5. Run container automatically  

### Benefits

- Identical runtime environment  
- Immutable infrastructure  
- Fast recovery & scaling  

---

## 🔁 CI/CD Pipeline

Fully automated pipeline using **GitHub Actions**.

### Branch Strategy

- `development` → main integration branch  
- `feature/*` → feature branches  

---

### 🧪 CI Pipeline (Pull Request → development)

Ensures Docker image quality before merge.

Steps:

- Dockerfile lint (Hadolint)  
- Shell script lint  
- Build Docker image  
- Run container locally  
- HTTP health check  

If any step fails → PR blocked  

---

### 📦 Release Pipeline (Merge → development)

After merge:

- Build Docker image  
- Push image to AWS ECR  
- Tag image:  
  - `<commit-sha>`  
  - `prod`  
- Verify image exists  
- Trigger deployment workflow  

---

### 🚀 Deployment Pipeline

Deployment uses **Auto Scaling Instance Refresh**

Steps:

1. Verify image exists  
2. Start rolling ASG refresh  
3. Gradually replace instances  
4. Wait until deployment successful  

**Result:** Zero-downtime deployment  

---

## 🔐 Security

- Instances in private subnets (no public IP)  
- Only ALB exposed to Internet  
- Security groups restrict traffic  
- Secrets stored in AWS Secrets Manager  
- IAM roles instead of static credentials  
- OIDC authentication (GitHub → AWS)  

---

## 📊 High Availability & Reliability

- Multi-AZ architecture  
- Load balancer health checks  
- Auto replacement of unhealthy instances  
- Rolling deployments (no downtime)  
- CloudWatch monitoring  
- Designed for **24/7 uptime**  

---

## 💸 Cost Optimization

- Auto scaling (pay only when needed)  
- Instance type: `t3.medium`  
- Private networking reduces exposure  
- Single NAT Gateway (balanced cost vs reliability)  

---

## 👥 Team Workflow

- Daily sync with mentor  
- Feature-based development  
- Pull request reviews  
- CI enforced quality checks  
- Terraform-managed infrastructure  
- Fully automated deployments  

---

## 🚀 Deployment Flow


---

## 📌 DevOps Practices Used

- Infrastructure as Code  
- Immutable deployments  
- Containerized workloads  
- Automated CI/CD  
- Rolling zero-downtime deployment  
- Secrets management  
- Cloud monitoring  
- Least-privilege IAM  
- High availability architecture  

---

## 📘 Summary

This project demonstrates a **production-grade DevOps workflow**:

- Fully automated infrastructure  
- Containerized & scalable application  
- Zero-downtime deployments  
- Secure & monitored environment  
- Cost-efficient cloud architecture  

The system is designed to **run continuously, scale automatically, and deploy safely without manual intervention**.
