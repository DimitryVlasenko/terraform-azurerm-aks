# terraform-module-aks
Terraform module for AKS

Terraform module for Azure Kubernetes Services includding:
- Azure Active Directory RBAC with AD admin group selection
- Mapping of existing Azure Container Registry
- Validation of the cluster availability

Setup:
- Provide your existing SPs or use self provisioned 
- Just simply adopt exmale.tf for your needs with explicit varible values or parse it from env file / tfvars with example = var.example.
