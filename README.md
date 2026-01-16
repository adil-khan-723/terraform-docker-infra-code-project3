# AWS ECS Fargate Infrastructure with Terraform

![Terraform](https://img.shields.io/badge/Terraform-1.0.0-7B42BC.svg)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900.svg)
![ECS](https://img.shields.io/badge/ECS-Fargate-FF9900.svg)
![CI/CD](https://img.shields.io/badge/CI/CD-Jenkins-FF9900.svg)

This repository provisions the foundational AWS infrastructure required to run… a frontend and backend containerized application on **ECS Fargate**, fronted by **Application Load Balancers**, with **Jenkins** on **EC2** handling CI.

## Architecture Overview

- **Networking**: Custom VPC with public and private subnets across AZs
- **Compute**: ECS Fargate (no EC2 worker management)
- **Ingress**:
  - Public ALB → Frontend
  - Internal ALB → Backend
- **CI**: Jenkins running on EC2
- **Registry**: Amazon ECR (immutable tags)
- **IAM**: Least-privilege roles for ECS and CI

## Repository Structure

```
.
├── modules/
│   ├── vpc/
│   ├── security_groups/
│   ├── alb_public/
│   ├── alb_internal/
│   ├── ecs_cluster/
│   ├── task_definition/
│   ├── ecs_service/
│   ├── ecr/
│   ├── iam/
│   └── jenkins_ec2/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── README.md
```

## Module Breakdown

### 1. VPC Module

**Purpose**: Creates the base network layer.

**Resources**:
- VPC (/16)
- 2 Public subnets
- 2 Private subnets
- Internet Gateway
- Route tables and associations

### 2. Security Groups Module

**Purpose**: Defines all traffic rules between components.

**Security Groups**:
- Public ALB SG
- Internal ALB SG
- Frontend ECS SG
- Backend ECS SG
- Jenkins EC2 SG

### 3. Public ALB Module

**Purpose**: Public-facing Application Load Balancer.

**Resources**:
- Public ALB
- HTTP listener (port 80)
- Frontend target group

### 4. Internal ALB Module

**Purpose**: Private Application Load Balancer.

**Resources**:
- Internal ALB
- HTTP listener
- Backend target group

### 5. ECS Cluster Module

**Purpose**: Creates the ECS control plane.

**Resources**:
- ECS Cluster
- Optional container insights

### 6. ECR Module

**Purpose**: Container image registry.

**Resources**:
- ECR repository
- Lifecycle policy (retain last N images)
- Image scanning on push
- Immutable tags

### 7. IAM Module

**Purpose**: All IAM roles and policies.

**Roles**:
- ECS Task Execution Role
- ECS Task Role (application permissions)
- Jenkins EC2 Role
- CI ECR Push Role (assumed by Jenkins)

### 8. Task Definition Module

**Purpose**: Reusable ECS task definition module.

**Resources**:
- ECS Task Definition (Fargate)

### 9. ECS Service Module

**Purpose**: Runs containers in ECS.

**Resources**:
- ECS Service (Fargate)

### 10. Jenkins EC2 Module

**Purpose**: CI server.

**Resources**:
- EC2 instance (Ubuntu)
- Instance profile
- User-data bootstrapping Jenkins and Docker

## Deployment Phases

This project is intentionally deployed in stages.

### Phase 1 – Base Infrastructure
- VPC
- ALBs
- Security groups
- IAM
- ECR
- ECS cluster
- Jenkins EC2
> *No container images required.*

### Phase 2 – CI
- Jenkins builds Docker images
- Images are tagged
- Images are pushed to ECR

### Phase 3 – Runtime
- ECS task definitions
- ECS services
> *At this stage, real images exist in ECR.*

## Why This Separation Exists
- Avoids circular dependencies
- Keeps CI and infra responsibilities clean
- Matches real-world production patterns

## How to Apply

### Initial Infrastructure
```bash
terraform init
terraform apply
```
*(ECS services or task definitions can be commented or targeted out.)*

### After CI Images Exist
```bash
terraform apply
```

## Key Design Decisions
- Fargate only (no EC2 workers)
- Immutable ECR tags
- Separate execution vs task roles
- Jenkins uses IAM role assumption (no static AWS keys)
- ALB-based service discovery

## What This Repo Does Not Contain
- Application source code
- Jenkins pipeline definitions
- Runtime secrets
> *These belong in separate repositories.*

## Current Status
- Networking: ✅ DONE
- Load balancers: ✅ DONE
- IAM: ✅ DONE
- ECR: ✅ DONE
- ECS cluster: ✅ DONE
- Jenkins EC2: ✅ DONE
- CI pipelines: ⏳ NEXT
- Runtime ECS rollout: ⏳ AFTER CI

---

This repository represents a production-style AWS ECS Fargate infrastructure with a clear CI/CD boundary. For more information, please refer to the individual module directories.
