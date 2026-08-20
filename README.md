# 🛡️ Azure Cloud Security Lab: Zero Trust & Automated Infrastructure

![DevSecOps Pipeline](https://github.com/Dayvison07/azure-cloudsec-lab/actions/workflows/checkov.yml/badge.svg)
![Terraform](https://img.shields.io/badge/IaC-Terraform_1.8+-844FBA?logo=terraform&logoColor=white)
![Security Scanner](https://img.shields.io/badge/SAST-Checkov_3.3+-2C3E50?logo=prisma&logoColor=white)
![Compliance](https://img.shields.io/badge/Baseline-Zero_Trust_%7C_CIS_Benchmark-0078D4?logo=microsoftazure&logoColor=white)

This repository provides an enterprise-ready **Secure Landing Zone on Microsoft Azure** provisioned via **Infrastructure as Code (Terraform)**, integrated with an automated **DevSecOps CI/CD pipeline (GitHub Actions + Checkov)** enforcing strict *Shift-Left Security* and regulatory compliance.

---

## 🏗️ Architecture & Security Controls

The architecture is built upon the **Least Privilege** principle and **Zero Trust Architecture (ZTA)**, structured as follows:

```mermaid
graph TB
    subgraph GitHub_CI_CD["GitHub Actions CI/CD Pipeline"]
        Developer["Git Push / PR (main)"] --> Runner["Ephemeral Runner"]
        Runner -->|1. OIDC Federated Auth| EntraID["Azure Entra ID"]
        Runner -->|2. Read/Lock State| BackendStorage["Storage Account (rg-terraform-state)"]
        Runner -->|3. Deploy Infrastructure| AzureInfra["Target Azure Environment"]
    end

    subgraph Azure_Cloud["Azure Subscription 1 (rg-zt-found-dev)"]
        subgraph VNet["Virtual Network (10.0.0.0/16)"]
            subgraph FrontendSubnet["Frontend Subnet (10.0.1.0/24)"]
                NSG["Network Security Group"] --> WebApp["App Service / Web Endpoint"]
            end
            
            subgraph PrivateEndpointSubnet["Private Endpoints Subnet (10.0.2.0/24)"]
                PE["Key Vault Private Endpoint"]
            end
        end

        KeyVault["Azure Key Vault (kv-zt-found-dev)"]
        LAW["Log Analytics Workspace (law-zt-found-dev)"]

        PE -->|Private Link| KeyVault
        WebApp -->|Managed Identity| KeyVault
        KeyVault -->|Diagnostic Settings| LAW
        WebApp -->|Diagnostic Settings| LAW
    end
```
## 🗝️ Key Features & Security Architecture

1. **Passwordless Authentication (OIDC):**
   * Eliminates static credentials (`AZURE_CREDENTIALS` client secrets).
   * GitHub Actions authenticates against Azure Entra ID via Federated Identity Credentials.

2. **Remote State Management:**
   * Centralized `.tfstate` stored in an isolated Storage Account (`rg-terraform-state`).
   * Configured with state locking to prevent concurrent deployment drifts.

3. **Zero Trust Principles:**
   * **Explicit Verification:** Role-Based Access Control (RBAC) enforced via Managed Identities.
   * **Least Privilege Access:** Key Vault exposed via **Private Endpoint** only, bypassing public internet exposure.
   * **Assume Breach:** All operations streaming audit metrics to **Log Analytics Workspace** (`ds-kv-to-loganalytics`).

---

## 🛠️ Tech Stack & Components

| Category | Technology |
| :--- | :--- |
| **Cloud Provider** | Microsoft Azure |
| **Infrastructure as Code** | Terraform (azurerm provider) |
| **CI/CD Orchestration** | GitHub Actions |
| **Authentication** | OIDC (OpenID Connect) + Entra ID |
| **Security Controls** | Azure Key Vault, Network Security Groups (NSG), Private Endpoints |
| **Observability** | Azure Monitor, Log Analytics Workspace |

---

## 🚀 Deployment Pipeline

The workflow runs automatically on `push` or `pull_request` to the `main` branch:

```mermaid
graph TD
    A[Git Push to main] --> B[GitHub Actions Runner]
    B --> C[OIDC Auth to Entra ID]
    C --> D[Terraform Init & Remote Backend Read]
    D --> E[Terraform Plan]
    E --> F[Terraform Apply]
    F --> G[State Update in Remote Storage Account]
```
### Manual Trigger & Troubleshooting

If environment collisions or stale resources occur, clean the application group asynchronously:

```bash
az group delete --name rg-zt-found-dev --yes
```

### 👨‍💻 Author & Lessons Learned

* **Project Purpose:** Built to demonstrate real-world **Cloud Security Engineering** practices, IaC state management troubleshooting, and **CI/CD hardening**.
* **Key Engineering Takeaway:** Resolved state drifts and resource collisions caused by ephemeral GitHub runners by implementing an **OIDC-authenticated Azure remote backend**.