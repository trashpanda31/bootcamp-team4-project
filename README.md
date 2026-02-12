# ☁️ Bootcamp Team 4 – DevOps Project

## Project Overview

This project was developed during the DevOps Bootcamp by Team 4.

The objective was to design and implement a production-style WordPress platform using modern DevOps practices and AWS cloud services.

Instead of deploying a simple website, the focus was placed on building a structured and automated cloud environment that reflects how production systems are provisioned, deployed, and operated.

The platform demonstrates an end-to-end DevOps lifecycle — from infrastructure provisioning and containerization to CI/CD automation and rolling deployments.

## 🎯 Project Goals

The system was designed with the following operational goals in mind:

- Run workloads inside containers for consistency
- Automate infrastructure provisioning using Terraform
- Eliminate manual deployments via CI/CD
- Ensure high availability across multiple Availability Zones
- Maintain controlled and predictable infrastructure capacity

To achieve this, the architecture combines Auto Scaling Groups, Docker containers, load balancing, and automated deployment workflows.

When a new instance is launched, it bootstraps itself automatically, pulls the production container image, retrieves secure credentials, and joins the load balancer without manual configuration.

## 🏗 System Architecture

The platform runs on a multi-AZ AWS architecture inside a custom VPC (10.40.0.0/16) in eu-west-1.

### Traffic Flow

All incoming internet traffic first reaches the Application Load Balancer (ALB) deployed in public subnets.

The load balancer performs health checks (/, HTTP 200–399) and distributes traffic only to healthy EC2 instances running inside private subnets.

Each EC2 instance runs WordPress inside a Docker container.

If an instance becomes unhealthy:

- It is removed from the load balancer target group
- The Auto Scaling Group replaces it automatically

This ensures service continuity without manual intervention.

## ⚙️ Core Components

### Application Load Balancer (ALB)

- Public entry point
- Distributes HTTP traffic
- Performs continuous health checks

### Auto Scaling Group (ASG)

Configured with:

- Minimum: 2 instance
- Desired: 2 instance
- Maximum: 3 instances

The ASG guarantees at least one running instance and allows horizontal scaling up to three instances.

CloudWatch alarms monitor:

- CPU utilization (>70%)
- Instance status check failures

(Current configuration defines monitoring alarms but does not include explicit scale-in or scale-out policies.)

### Dockerized WordPress

The Docker image is based on a fixed WordPress version and includes repository-managed wp-content:

```dockerfile
FROM wordpress:6.5.4-php8.2-apache
COPY ./wp-content /var/www/html/wp-content
RUN chown -R www-data:www-data /var/www/html/wp-content
```

The container is started via a launch template bootstrap script during instance initialization.

---

### Amazon ECR

Docker images are stored and versioned in Amazon Elastic Container Registry (ECR).

Images are tagged with:

- Commit SHA
- prod

This ensures traceable and reproducible deployments.

---

### AWS Secrets Manager

Database credentials are:

- Stored securely
- Retrieved dynamically at runtime
- Injected into the container as environment variables

No secrets are hard-coded or stored in the repository.

---

## ☁️ Infrastructure (Terraform)

All infrastructure is fully defined as code using Terraform.

### Networking

- Custom VPC (10.40.0.0/16)
- 2 Public subnets (ALB + NAT Gateway)
- 2 Private subnets (EC2 instances)
- Internet Gateway for ingress
- NAT Gateway for outbound access

EC2 instances:

- Have no public IP
- Accept traffic only from the ALB security group

This isolates compute resources from direct internet exposure.

---

### Terraform Backend

Remote state configuration includes:

- S3 state storage
- Encryption enabled
- State locking enabled

This prevents concurrent state corruption and enables safe team collaboration.

---

## 📦 Instance Boot Process

When the Auto Scaling Group launches a new EC2 instance, a user-data script automatically:

- Installs Docker and required dependencies (AWS CLI, jq, curl)
- Authenticates to Amazon ECR
- Pulls the prod image
- Retrieves database credentials from AWS Secrets Manager
- Starts the WordPress container on port 80
- Mounts a Docker volume for media uploads (wp_uploads:/var/www/html/- - wp-content/uploads)

The uploads volume persists across container restarts on the same instance, but is not shared between multiple instances.

This ensures:
- No manual server configuration
- Consistent runtime environments
- Automated instance replacement
- Application-level persistence for media uploads on each instance

---

## 🔁 CI/CD Pipeline

GitHub Actions manages validation, release, and deployment workflows.

### CI Pipeline (Pull Requests → development)

Before code is merged:

- Dockerfile linting (Hadolint)
- Shell script linting
- Docker Buildx image build
- Local container runtime test
- HTTP response validation

If validation fails, the Pull Request cannot be merged.

---

### Release Pipeline

After a Pull Request is merged:

- Production image is built
- Image is pushed to ECR
- Image is tagged (commit SHA + prod)
- Deployment workflow is triggered

Authentication uses OIDC federation — GitHub assumes an AWS IAM role without storing static credentials.

---

### Deployment Strategy

Deployments use Auto Scaling Instance Refresh:

- Rolling replacement strategy
- 90% minimum healthy capacity
- 120-second warmup

Instances are replaced gradually while maintaining service availability.

No manual SSH or server-level deployment steps are required.

---

## 📊 Monitoring & Reliability

CloudWatch monitors:

- CPU utilization
- Instance health status

Failure handling:

- Container crash → ALB removes instance → ASG replaces it
- EC2 failure → ASG launches replacement
- Deployment → only a portion of instances replaced at a time

Multi-AZ placement improves availability.

---

## 🔐 Security

Security controls include:

- Private subnets for compute
- No public IP on EC2 instances
- ALB as the only ingress point
- IAM roles instead of static AWS keys
- Secrets Manager for sensitive data
- OIDC authentication for CI/CD

This minimizes attack surface and credential exposure.

---

## 🚀 Deployment Flow

Developer Push  
→ Pull Request  
→ CI Validation  
→ Merge to development  
→ Image Build & Push to ECR  
→ Instance Refresh  
→ Production Updated  

---

## 📘 Summary

This project demonstrates a structured DevOps environment featuring:

- Infrastructure as Code
- Containerized workloads
- Multi-AZ architecture
- Rolling deployments
- Secure secret injection
- Automated CI/CD workflows

The platform ensures consistent deployments, automated instance replacement, and secure configuration management without manual intervention.