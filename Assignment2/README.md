# Azure Resource Management Script

This Python script automates the creation and management of Azure resources, including creating a resource group, deploying a virtual machine, setting up an Azure SQL Database, and configuring a Storage Account.

## Prerequisites

- **Python 3.x**: Ensure you have Python 3 installed on your machine. You can check the installation with:

```bash
python3 --version
```

- **Azure Subscription**: You need an active Azure subscription to create resources.

- **Azure CLI**: The script uses Azure CLI for authentication. Install Azure CLI if you haven't already:

# macOS/Linux
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

- **Azure SDK for Python**: The script uses Azure SDK libraries, which need to be installed in your Python environment.

Setup Instructions
1. Clone the Repository

```bash
git clone git@github.com:davitelesfranca/velozient_dtf.git
cd velozient_dtf/Assignment2
```


2. Set Up a Virtual Environment (Recommended)
Creating a virtual environment helps you manage dependencies without affecting your global Python installation.

```bash
python3 -m venv venv
source venv/bin/activate  # On macOS/Linux
```

3. Install Required Python Packages
With the virtual environment activated, install the necessary packages:

```bash
pip install azure-mgmt-resource azure-mgmt-compute azure-mgmt-sql azure-mgmt-storage azure-mgmt-network azure-identity
```

4. Set Your Azure Subscription ID
Export your Azure Subscription ID as an environment variable:

```bash
export AZURE_SUBSCRIPTION_ID=<your_subscription_id>  # On macOS/Linux
```

5. Run the Script
You can now run the script to create the Azure resources:

```bash
python az_resource.py
```
