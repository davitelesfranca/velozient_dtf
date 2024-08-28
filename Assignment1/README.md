# Azure Infrastructure Automation with Terraform

## Overview

This Terraform project automates the deployment of a scalable web application in Azure. The infrastructure includes:

- A Virtual Network (VNet) with subnets for web, application, and database tiers.
- Two Virtual Machines (VMs) in the web tier behind a Load Balancer.
- A Virtual Machine (VM) in the application tier.
- An Azure SQL Database in the database tier.
- Network Security Groups (NSGs) with appropriate rules for each tier.

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- An Azure account with appropriate permissions to create resources.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured.

## Setup Instructions

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone git@github.com:davitelesfranca/velozient_dtf.git
cd azure-infrastructure-automation
export ARM_SUBSCRIPTION_ID=<your-subscription-id>
az login --use-device-code (or your used az login way)

```

Run the following command to initialize Terraform. This command downloads the necessary provider plugins:

```bash
- terraform init
- terraform plan
- terraform apply
```

If you encounter issues, you can use the TF_LOG environment variable to get more detailed logs:

```bash
export TF_LOG=DEBUG
terraform apply
```

Defina the VM admin password and the SQL admin password. You need to follow these rules:
-  The password has to fulfill 3 out of these 4 conditions: Has lower characters, Has upper characters, Has a digit, Has a special character other than "_"
