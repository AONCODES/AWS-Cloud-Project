# Baseline 15: Complex System Architecture

## Introduction

CTFd was selected as the complex system in Baseline 03. The application is deployed in the AWS Academy Learner Lab environment using Terraform Infrastructure as Code (IaC).

The solution follows a three-tier architecture consisting of presentation, application and data layers. AWS services are used for networking, compute, database, caching, storage, security and monitoring.

The goal is to create a cloud environment where application servers can be replaced automatically while important application data is stored separately.

## Solution Overview

The solution is designed to deploy CTFd on AWS using a three-tier architecture. The main goals are to separate the application from its data, improve availability and make the infrastructure reusable/producible using Terraform.

The deployment uses one AWS Academy Learner Lab account in the `us-east-1` Region. Two Availability Zones (`us-east-1a` and `us-east-1b`) are used for the application infrastructure.

### Architecture Design

The architecture consists of three layers:

**Presentation Tier:**    
An internet-facing Application Load Balancer (ALB) receives HTTP requests on port 80 and distributes traffic to the application servers.   

**Application Tier:**   
 CTFd runs in Docker containers on EC2 instances located in private subnets. An Auto Scaling Group maintains two instances across two Availability Zones and replaces unhealthy instances when needed.

**Data Tier:**    
Amazon RDS MySQL stores persistent application data (for example: users and challenges), ElastiCache Redis provides shared caching and Amazon S3 stores uploaded files (for example challenge files).

Both EC2 instances use the same database, cache and S3 storage. This allows users to access the application through both servers without storing important application data on EC2 instances.

### Technology and Service Selection

The selected technologies are based on CTFd's supported deployment options, AWS services and the requirements of the cloud deployment project.

**Amazon EC2 and Docker:**  
 CTFd provides an official Docker image, making container deployment easyish. EC2 was selected because it allows control over the operating system, Docker environment and application configuration.

**Application Load Balancer (ALB):**  
 The ALB distributes incoming HTTP requests between the two EC2 instances. It also performs health checks, so traffic can be directed to healthy application instances.

**EC2 Auto Scaling:**  
 An Auto Scaling Group maintains the required number of EC2 instances and automatically replaces unhealthy instances. This improves application availability compared to running CTFd on a single server.

**Amazon RDS MySQL:**   
 CTFd supports MySQL as a database. RDS was selected instead of installing MySQL on an EC2 instance because AWS manages database infrastructure, backups and maintenance. The database stores users, challenges, submissions and scores.

**Amazon ElastiCache Redis:**   
 CTFd supports Redis for caching and session-related functions. ElastiCache provides a managed Redis service that can be shared between both application instances.

**Amazon S3:**    
 CTFd supports S3 compatible storage for uploaded files. S3 was selected because both EC2 instances need access to the same challenge files and uploads. Storing files locally on one EC2 instance would cause problems when traffic is between multiple servers.

**Amazon VPC and Private Subnets:**   
 A custom VPC separates public and private resources. The ALB is internet-facing, while the EC2 instances, database and Redis cache are in private subnets. A NAT Gateway allows application instances to download packages and access external services without public IP addresses.

**Terraform:**   
 Terraform was selected to deploy and manage the AWS infrastructure.

### Architecture Diagram

The architecture diagram illustrates the AWS environment, including the VPC, Availability Zones, public and private subnets, application servers, data services, security and monitoring.

Pic here when fully ready.

### Architecture Limitations

The deployment is designed for a school project and is not fully production ready.

The application layer uses two Availability Zones, but RDS MySQL and Redis are deployed without multi-AZ to reduce costs. The NAT Gateway is also deployed in only one Availability Zone.

The application uses HTTP through the ALB's AWS provided DNS name. A custom domain and HTTPS certificate are not included, but is recommended in production environments.

