# 🚀 Enterprise Azure Infrastructure Landing Zone with Modular Terraform & Azure DevOps

[![Terraform](https://img.shields.io/badge/Terraform-v1.x-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Microsoft Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Azure DevOps](https://img.shields.io/badge/Azure_DevOps-0078D4?style=for-the-badge&logo=azure-devops&logoColor=white)](https://azure.microsoft.com/en-us/products/devops/)
[![HCL](https://img.shields.io/badge/Language-HCL-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://github.com/hashicorp/hcl)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![IaC Standard](https://img.shields.io/badge/IaC_Pattern-Map--Driven_Modules-blue?style=for-the-badge)](#-architecture--design-patterns)

An enterprise-grade, highly scalable, and fully modular **Infrastructure-as-Code (IaC)** solution designed to provision multi-tier cloud landing zones on **Microsoft Azure**. 

Built following industry best practices, this repository leverages reusable HCL modules driven by dynamic data structures (`for_each` maps), strict network isolation, layered security controls, and seamless environment lifecycle management (`Dev` / `Prod`).

---

## 📋 Table of Contents

- [✨ Key Architecture Highlights](#-key-architecture-highlights)
- [🏛️ System Architecture](#️-system-architecture)
- [📁 Repository Structure](#-repository-structure)
- [🧩 Modular Infrastructure Components](#-modular-infrastructure-components)
- [⚡ Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Local Deployment Walkthrough](#local-deployment-walkthrough)
- [♾️ Azure DevOps CI/CD Automation](#️-azure-devops-cicd-automation)
- [🛡️ Security & Enterprise Best Practices](#️-security--enterprise-best-practices)
- [📜 License](#-license)
- [👤 Author & Portfolio](#-author--portfolio)

---

## ✨ Key Architecture Highlights

* **100% DRY & Map-Driven Architecture**: All infrastructure resources are instantiated using highly dynamic parameter maps (`rgs`, `vnets`, `subnets`, `vms`, `app_gateways`, etc.), ensuring zero code duplication across environments.
* **Multi-Tier Network Segregation**: Implements public and private subnet topologies (`10.0.1.0/24` Public, `10.0.2.0/24` Private) within a dedicated Virtual Network (`dev-vnet`).
* **Granular Network Security (NSGs)**: Micro-segmented firewalls restricting ingress traffic to authorized ports (e.g., HTTPS:443 for Frontend, MySQL:3306 for Database layer).
* **Layer-7 Application Delivery**: Azure Application Gateway (`Standard_v2`) configured with HTTP/HTTPS listeners, custom backend pools, routing rules, and dynamic health probes.
* **Layer-4 High Availability**: Network Load Balancer (NLB) for high-throughput TCP/UDP traffic distribution.
* **Scalable Compute Engine**: Automated Ubuntu Linux VM provisioning (`Standard_D4_v5`) with static/dynamic public IP allocations and managed OS disks.
* **Remote State & Storage Layer**: Dedicated Azure Storage Account and Blob Container management for state locking and persistent artifact storage.
* **Environment Isolation**: Dedicated environment directory structures (`Env/Dev`, `Env/Prod`) allowing clean staging, variable management, and blast-radius mitigation.

---

## 🏛️ System Architecture

```mermaid
graph TD
    subgraph Azure_Subscription ["☁️ Azure Subscription / Resource Group (dev-rg)"]
        subgraph VNet ["🌐 Virtual Network (10.0.0.0/16 - dev-vnet)"]
            
            subgraph Public_Subnet ["🔓 Public Subnet (10.0.1.0/24)"]
                AGW["🚦 Application Gateway<br/>(Standard_v2 / Port 80/443)"]
                FVM["🖥️ Frontend VM<br/>(Ubuntu Linux 24.04 LTS)"]
                FNIC["🔌 Frontend NIC"]
                FNSG["🛡️ Public NSG<br/>(Allow HTTPS:443)"]
            end
            
            subgraph Private_Subnet ["🔒 Private Subnet (10.0.2.0/24)"]
                BVM["🖥️ Backend VM<br/>(Ubuntu Linux 24.04 LTS)"]
                BNIC["🔌 Backend NIC"]
                BNSG["🛡️ Backend NSG<br/>(Allow MySQL:3306)"]
            end

        end

        subgraph Storage_Layer ["📦 Storage Layer"]
            SA["💾 Storage Account<br/>(harekrishnadevstorage)"]
            SC["📂 Storage Container<br/>(devsecops / Terraform State)"]
        end

        subgraph Traffic_Management ["🌐 Ingress & Load Balancing"]
            PIP1["📍 Public IP: Frontend"]
            PIP2["📍 Public IP: Backend"]
            LB["⚖️ Public Load Balancer (Public_NLB)"]
        end
    end

    PIP1 --> AGW
    AGW --> FNIC
    FNIC --> FVM
    PIP2 --> BNIC
    BNIC --> BVM
    FVM -. Internal Traffic .-> BVM
    FNSG --- Public_Subnet
    BNSG --- Private_Subnet
```

---

## 📁 Repository Structure

```text
terraform-azure-devops/
├── Env/                                    # Environment Orchestration Layer
│   ├── Dev/                                # Development Environment
│   │   ├── main.tf                         # Module invocations & dependency order
│   │   ├── provider.tf                     # AzureRM Provider specification (v4.81.0)
│   │   ├── variable.tf                     # Input variable declarations
│   │   └── terraform.tfvars                # Infrastructure parameters & map definitions
│   └── Prod/                               # Production Environment
│       ├── main.tf                         # Production orchestration entrypoint
│       ├── provider.tf                     # Provider settings for Prod
│       ├── variable.tf                     # Variable definitions for Prod
│       └── terraform.tfvars                # Production environment configuration
├── Modules/                                # Reusable Core Terraform Modules (DRY Design)
│   ├── azurerm_application_gateway/        # Layer-7 App Gateway v2 ALB/WAF module
│   ├── azurerm_bastion/                    # Secure Bastion Host access module
│   ├── azurerm_key_vault/                  # Secrets & Certificate management module
│   ├── azurerm_linux_virtual_machine/      # Compute instance module (Ubuntu/RHEL)
│   ├── azurerm_load_balancer/              # Layer-4 Network Load Balancer module
│   ├── azurerm_network_interface/          # Network Interface Card (NIC) module
│   ├── azurerm_network_security_group/     # Firewalls & Security Rules module
│   ├── azurerm_public_ip/                  # Public IP (Static/Dynamic) module
│   ├── azurerm_resource_group/             # Azure Resource Group provisioning module
│   ├── azurerm_storage_account/            # Storage Account management module
│   ├── azurerm_storage_container/          # Storage Container / Blob module
│   ├── azurerm_subnet/                     # Subnet configuration module
│   └── azurerm_virtual_network/            # Virtual Network (VNet) core module
├── .gitignore                              # Git exclusion rules for secrets & tfstate
├── LICENSE                                 # Open-source MIT License
└── README.md                               # Project documentation
```

---

## 🧩 Modular Infrastructure Components

| Module Name | Path | Description | Key Features / Inputs |
| :--- | :--- | :--- | :--- |
| **Resource Group** | [`Modules/azurerm_resource_group`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_resource_group) | Lifecycle container for Azure resources | Location, Tags, Dynamic `for_each` creation |
| **Virtual Network** | [`Modules/azurerm_virtual_network`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_virtual_network) | Core network spine | Address space, DNS servers, Resource scoping |
| **Subnets** | [`Modules/azurerm_subnet`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_subnet) | Subnet partitioning (Public/Private) | Address prefixes, Service endpoints |
| **Public IP** | [`Modules/azurerm_public_ip`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_public_ip) | External connectivity endpoints | Static/Dynamic allocation, SKU tiers |
| **Network Interfaces** | [`Modules/azurerm_network_interface`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_network_interface) | VM Network attachment interfaces | Subnet lookup data source, Public IP binding |
| **Network Security Groups** | [`Modules/azurerm_network_security_group`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_network_security_group) | Stateful packet filtering firewalls | Custom Inbound/Outbound rules (HTTPS, MySQL) |
| **Application Gateway** | [`Modules/azurerm_application_gateway`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_application_gateway) | Layer-7 Web Traffic Load Balancer | Standard_v2 SKU, Listener config, HTTP settings |
| **Load Balancer** | [`Modules/azurerm_load_balancer`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_load_balancer) | Layer-4 Traffic distribution | Public IP frontend, Backend pools, Probes |
| **Linux Virtual Machines** | [`Modules/azurerm_linux_virtual_machine`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_linux_virtual_machine) | Compute instances (Frontend/Backend) | Canonical Ubuntu 24.04, Disk caching options |
| **Storage Account & Container** | [`Modules/azurerm_storage_account`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_storage_account) | Cloud object storage & remote backend | Standard LRS/GRS replication, Private containers |
| **Key Vault** | [`Modules/azurerm_key_vault`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_key_vault) | Hardware security secrets store | RBAC access policies, Secret encryption |
| **Bastion Host** | [`Modules/azurerm_bastion`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/Modules/azurerm_bastion) | Secure RDP/SSH jump box management | Zero public IP exposure for VMs |

---

## ⚡ Getting Started

### Prerequisites

Ensure you have the following installed on your workstation:
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (v1.5.0+)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (v2.50.0+)
* An active **Microsoft Azure Subscription** with Owner/Contributor privileges.

### Local Deployment Walkthrough

1. **Clone the Repository**
   ```bash
   git clone https://github.com/vikashkumardevops/terraform-azure-devops.git
   cd terraform-azure-devops
   ```

2. **Authenticate with Azure**
   ```bash
   az login
   az account set --subscription "<YOUR_AZURE_SUBSCRIPTION_ID>"
   ```

3. **Initialize & Deploy Development Infrastructure**
   ```bash
   # Navigate to the Dev environment
   cd Env/Dev

   # Initialize Terraform modules & backend
   terraform init

   # Format & Validate configuration
   terraform fmt
   terraform validate

   # Preview infrastructure execution plan
   terraform plan -out=dev.tfplan

   # Apply plan to provision resources
   terraform apply dev.tfplan
   ```

4. **Tear Down / Destroy Infrastructure**
   ```bash
   terraform destroy -auto-approve
   ```

---

## ♾️ Azure DevOps CI/CD Automation

This workspace is structured for automated execution within **Azure DevOps Pipelines**. Below is an enterprise YAML pipeline blueprint for automated Plan & Apply stages:

```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - Env/Dev/**
      - Modules/**

pool:
  vmImage: 'ubuntu-latest'

variables:
  azureServiceConnection: 'Azure-DevOps-Service-Principal'
  workingDir: '$(System.DefaultWorkingDirectory)/Env/Dev'

stages:
- stage: ValidateAndPlan
  displayName: 'Terraform Lint, Validate & Plan'
  jobs:
  - job: Plan
    steps:
    - task: TerraformInstaller@1
      inputs:
        terraformVersion: 'latest'

    - task: AzureCLI@2
      displayName: 'Terraform Init & Plan'
      inputs:
        azureSubscription: '$(azureServiceConnection)'
        scriptType: 'bash'
        scriptLocation: 'inlineScript'
        inlineScript: |
          cd $(workingDir)
          terraform init
          terraform validate
          terraform plan -out=$(Build.ArtifactStagingDirectory)/tfplan

    - task: PublishBuildArtifacts@1
      inputs:
        PathtoPublish: '$(Build.ArtifactStagingDirectory)/tfplan'
        ArtifactName: 'tfplan'

- stage: DeployProd
  displayName: 'Terraform Apply (Approval Required)'
  dependsOn: ValidateAndPlan
  condition: succeeded()
  jobs:
  - deployment: Apply
    environment: 'Production-Approval-Gate'
    strategy:
      runOnce:
        deploy:
          steps:
          - task: AzureCLI@2
            displayName: 'Terraform Apply'
            inputs:
              azureSubscription: '$(azureServiceConnection)'
              scriptType: 'bash'
              scriptLocation: 'inlineScript'
              inlineScript: |
                cd $(workingDir)
                terraform init
                terraform apply -auto-approve $(Pipeline.Workspace)/tfplan/tfplan
```

---

## 🛡️ Security & Enterprise Best Practices

* **Least Privilege Access Control**: Resource provisioning utilizes isolated Azure Service Principals with RBAC restrictions.
* **Network Isolation**: Backend database and compute instances reside in isolated private subnets without direct internet exposure.
* **Secrets Governance**: Sensitive credentials (e.g., VM admin passwords) are injected dynamically via environment variables or Azure Key Vault rather than hardcoded in source control.
* **Comprehensive Tagging Policy**: All provisioned resources are tagged with metadata (`Environment`, `Created By`, `OS`, `Purpose`, `Owner`) for cost allocation and governance tracking.
* **State Encryption**: Remote state files are protected at rest with 256-bit AES encryption inside Azure Blob Storage.

---

## 📜 License

Distributed under the MIT License. See [`LICENSE`](file:///d:/Study/Git/azure-repo/terraform-azure-devops/LICENSE) for more information.

---

## 👤 Author & Portfolio

**Vikash Kumar**  
*DevOps & Cloud Infrastructure Engineer*

- 🌐 **GitHub**: [@vikashkumardevops](https://github.com/vikashkumardevops)
- 💼 **LinkedIn**: [Vikash Kumar](https://www.linkedin.com/in/vikashkumar0505/)
- 📧 **Email**: [iamvikashkumar05@gmail.com](mailto:iamvikashkumar05@gmail.com)
- 📂 **Repository**: [terraform-azure-devops](https://github.com/vikashkumardevops/terraform-azure-devops)

---

<p align="center">
  <i>⭐ If you found this repository helpful, please consider giving it a star! ⭐</i>
</p>
