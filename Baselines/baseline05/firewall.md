# Baseline05: Firewall

This task establishes Firewalls for Public and Private subnets using Terraform. 

## Task Artifacts

- `firewall.md`- this documentation
- `terraform/` - .tf configurations
- `screenshots/` - to verify tasks

## Task Description

### Mission

Mission of this task was to continue the Terraform infrastructure from Baseline04 and configure firewalls for the public and private subnets.

The firewall requirements were:
```bash
Public Subnet firewall allows:
- SSH (22)
- HTTP (80)
- HTTPS (443) 
from the Internet.

Private Subnet firewall allows:
- SSH (22)
- HTTP (80)
- HTTPS (443) 
from the Public Subnets.
```

### Namin convention

The same naming convention from the previous baseline was continued.

Terraform resource names use snake_case, for example:
```bash
public_ingress_ssh
private_ingress_http_public_az1
private_ingress_https_public_az2
```

AWS Name tags use kebab-case (template used kebab-case), for example:
```
public-nacl
private-nacl
```
## Handled by IaC

Terraform was used to create the firewall resources required for this task.

Two Network ACLs were created:
```bash
Public Network ACL
Private Network ACL
```

The Public Network ACL allows inbound SSH (22), HTTP (80) and HTTPS (443) traffic from the Internet.

The Private Network ACL allows inbound SSH (22), HTTP (80) and HTTPS (443) traffic from the two Public Subnets.

Terraform was also used to associate the Public Network ACL with the two Public Subnets and the Private Network ACL with the two Private Subnets.

## Handled outside IaC

GitHub and AWS Academy Learner Lab were handled outside Terraform.

The Terraform configuration was edited in VS Code and stored in the GitHub repository. AWS CloudShell was used to run Terraform commands in the AWS Academy Learner Lab environment.

AWS Console was used to verify the deployed Network ACL rules and subnet associations.





![alt text](screenshots/image.png)

![alt text](screenshots/image-1.png)

![alt text](screenshots/image-2.png)

![alt text](screenshots/image-3.png)

