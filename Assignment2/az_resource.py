import os
import logging
from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.sql import SqlManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.network import NetworkManagementClient

# Setup logging to both file and console
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger()
file_handler = logging.FileHandler('azure_resource_management.log')
file_handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

# Azure authentication
credential = DefaultAzureCredential()
subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]

# Resource management client
resource_client = ResourceManagementClient(credential, subscription_id)

# Compute management client
compute_client = ComputeManagementClient(credential, subscription_id)

# SQL management client
sql_client = SqlManagementClient(credential, subscription_id)

# Storage management client
storage_client = StorageManagementClient(credential, subscription_id)

# Network management client
network_client = NetworkManagementClient(credential, subscription_id)

# Variables
resource_group_name = "MyResourceGroup"
location = "eastus"
vm_name = "MyVM"
sql_server_name = "python-my-sql-server"
sql_db_name = "python-my-sql-db"
storage_account_name = "pysadtftest"
vnet_name = "MyVNet"
subnet_name = "MySubnet"
nic_name = "MyNIC"

# Create a resource group
def create_resource_group():
    logger.info("Creating resource group...")
    resource_group_params = {"location": location}
    resource_group = resource_client.resource_groups.create_or_update(resource_group_name, resource_group_params)
    logger.info(f"Resource group '{resource_group_name}' created.")

# Create a Virtual Network (VNet)
def create_virtual_network():
    logger.info("Creating virtual network...")
    vnet_params = {
        "location": location,
        "address_space": {
            "address_prefixes": ["10.0.0.0/16"]
        }
    }
    vnet_result = network_client.virtual_networks.begin_create_or_update(
        resource_group_name, vnet_name, vnet_params).result()
    logger.info(f"Virtual network '{vnet_name}' created.")
    return vnet_result

# Create a Subnet
def create_subnet(vnet):
    logger.info("Creating subnet...")
    subnet_params = {
        "address_prefix": "10.0.0.0/24"
    }
    subnet_result = network_client.subnets.begin_create_or_update(
        resource_group_name, vnet_name, subnet_name, subnet_params).result()
    logger.info(f"Subnet '{subnet_name}' created.")
    return subnet_result

# Create a Network Interface (NIC)
def create_network_interface(subnet):
    logger.info("Creating network interface...")
    nic_params = {
        "location": location,
        "ip_configurations": [{
            "name": "MyIPConfig",
            "subnet": {
                "id": subnet.id
            }
        }]
    }
    nic_result = network_client.network_interfaces.begin_create_or_update(
        resource_group_name, nic_name, nic_params).result()
    logger.info(f"Network interface '{nic_name}' created with ID: {nic_result.id}")
    return nic_result

# Create a VM with the network interface
def create_virtual_machine(nic_id):
    if not nic_id:
        logger.error("NIC ID is empty. Cannot create VM without a valid NIC ID.")
        return

    logger.info(f"Creating virtual machine '{vm_name}' with NIC ID '{nic_id}'...")
    vm_parameters = {
        "location": location,
        "hardware_profile": {"vm_size": "Standard_DS1_v2"},
        "storage_profile": {
            "image_reference": {
                "publisher": "Canonical",
                "offer": "UbuntuServer",
                "sku": "18.04-LTS",
                "version": "latest"
            }
        },
        "os_profile": {
            "computer_name": vm_name,
            "admin_username": "azureuser",
            "admin_password": "YourPassword123!"
        },
        "network_profile": {
            "network_interfaces": [{
                "id": nic_id,
                "primary": True
            }]
        }
    }
    async_vm_creation = compute_client.virtual_machines.begin_create_or_update(
        resource_group_name, vm_name, vm_parameters)
    vm_result = async_vm_creation.result()
    logger.info(f"Virtual machine '{vm_name}' created.")
    return vm_result

# Setup an Azure SQL Database
def create_sql_database():
    logger.info("Creating SQL Server and Database...")
    server_params = {
        "location": location,
        "administrator_login": "sqladmin",
        "administrator_login_password": "YourSQLPassword123!"
    }
    sql_server = sql_client.servers.begin_create_or_update(resource_group_name, sql_server_name, server_params).result()

    db_params = {"location": location}
    sql_db = sql_client.databases.begin_create_or_update(resource_group_name, sql_server_name, sql_db_name, db_params).result()
    logger.info(f"SQL Database '{sql_db_name}' created on server '{sql_server_name}'.")

# Configure a Storage Account
def create_storage_account():
    logger.info("Creating storage account...")
    storage_params = {
        "sku": {"name": "Standard_LRS"},
        "kind": "StorageV2",
        "location": location
    }
    storage_account = storage_client.storage_accounts.begin_create(
        resource_group_name, storage_account_name, storage_params).result()
    logger.info(f"Storage account '{storage_account_name}' created.")

# Error handling
try:
    create_resource_group()
    vnet = create_virtual_network()
    subnet = create_subnet(vnet)
    nic = create_network_interface(subnet)
    
    if nic and nic.id:
        create_virtual_machine(nic.id)
    else:
        logger.error("Failed to create VM because NIC creation failed or NIC ID is invalid.")
    
    create_sql_database()
    create_storage_account()
except Exception as e:
    logger.error(f"An error occurred: {e}")
