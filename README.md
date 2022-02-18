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

Run Terraform

```
terraform plan
terraform apply
```



Azure Doc: https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#authenticate-to-azure-via-a-microsoft-account
