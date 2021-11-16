## ENVIRONMENT VARIABLES

# Configure Azure Cloud

- Setup authentication [https://packer.io/docs/builders/azure#authentication-for-azure](https://packer.io/docs/builders/azure#authentication-for-azure)
- Create a resource group in the ARM_LOCATION near you

```sh
az group create -l "${ARM_LOCATION}" -n "${ARM_RESOURCE_GROUP}"
```

- Create an ARM_STORAGE_ACCOUNT in  the same ARM_LOCATION

```sh
az storage account create -n "$ARM_STORAGE_ACCOUNT" \
  -g $ARM_RESOURCE_GROUP -l $ARM_LOCATION --sku Premium_LRS --https-only true
```

- Export environment variables

```
export ARM_CLIENT_ID=
export ARM_CLIENT_SECRET=
export ARM_RESOURCE_GROUP=
export ARM_STORAGE_ACCOUNT=
export ARM_LOCATION=
export ARM_SUBSCRIPTION_ID=
export ARM_TENANT_ID=
```

# Configure Google Cloud:
- Create project on [https://console.cloud.google.com/](https://console.cloud.google.com/)
- Copy the Project ID
- Setup API authentication
[https://cloud.google.com/sdk/gcloud/reference/auth/application-default](https://cloud.google.com/sdk/gcloud/reference/auth/application-default)
```
gcloud auth application-default login
```

```
export GCP_PROJECT_ID=
export CLOUDSDK_COMPUTE_REGION=europe-west4
export CLOUDSDK_COMPUTE_ZONE=europe-west4-a
```

# Configure Tailscale
- Reusable key for Tailscale
  [https://login.tailscale.com/admin/settings/authkeys](https://login.tailscale.com/admin/settings/authkeys)
```
export TAILSCALE_AUTHKEY=""
```
