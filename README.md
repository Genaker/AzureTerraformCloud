## AzureTerraformCloud

# Open Azure Account

https://portal.azure.com/

# Open Cloud Shell

![image](https://user-images.githubusercontent.com/9213670/154619136-2fb559da-2361-44e4-acbc-4a8d119adab5.png)

# Verify the default Terraform installation 
```
terraform version
```

# Verify the default Azure subscriptio
```
az account show
```

# Git Clone this Repo 

![image](https://user-images.githubusercontent.com/9213670/154619251-dff47f1c-6f37-4de6-b580-5a8a70746ff3.png)

# Authenticate Terraform to Azure

```
az login
az account show

az account list --query "[?user.name=='<microsoft_account_email>'].{Name:name, ID:id, Default:isDefault}" --output Table
```

Key points:

 - Replace the <microsoft_account_email> placeholder with the Microsoft account email address whose Azure subscriptions you want to list.
 - With a Live account - such as a Hotmail or Outlook - you might need to specify the fully qualified email address. For example, if your email address is -   magento@gmail.com, you might need to replace the placeholder with live.com#magento@gmail.com.

# Specify service principal credentials in environment variables

```
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

## Run Terraform

# Initialize Terraform
Run terraform init to initialize the Terraform deployment. This command downloads the Azure modules required to manage your Azure resources.

```
terraform init
```
# Create a Terraform execution plan
Run terraform plan to create an execution plan.

```
terraform plan -out main.tfplan
```

The terraform plan command creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.
The optional -out parameter allows you to specify an output file for the plan. Using the -out parameter ensures that the plan you reviewed is exactly what is applied.
To read more about persisting execution plans and security, see the security warning section.

# Apply a Terraform execution plan
Run terraform apply to apply the execution plan to your cloud infrastructure.

```
terraform apply main.tfplan
```

The terraform apply command above assumes you previously ran terraform plan -out main.tfplan.
If you specified a different filename for the -out parameter, use that same filename in the call to terraform apply.
If you didn't use the -out parameter, simply call terraform apply without any parameters.

or just:
```
terraform plan
terraform apply
```

Input **"yes"** here

![image](https://user-images.githubusercontent.com/9213670/154621088-50936034-409d-4b6d-b85f-e9599d4a2bad.png)


Azure Doc: https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#authenticate-to-azure-via-a-microsoft-account
