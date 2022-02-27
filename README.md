# Requirements

### Step 1: Create GCP Project
- Enable Kubernetes Engine API
- Enable Secret Manager API

### Step 2: Generate Secrets & Register to Secret Manager
- GitHub Personal Access Token (Required Scopes: Repository + Workflow)
- DB Password (Using as Cloud SQL password)
- SSH Public/Private Key (Required for ArgoCD)

### Step 3: GCP Service Account Key
- Create a service account with enough IAM Role Permission in target GCP Project.
- Generate JSON Service Account Key
- Download, rename to `service_account.json` and place JSON Service Account Key in root folder of this project

*Note: Do not push GCP Service Account Key into GitHub Respository*

### Step 4: Create `.env`
1. Generate `.env` file from `.env.sample`
2. Update `GOOGLE_PROJECT`, and `GOOGLE_APPLICATION_CREDENTIALS` values

### Step 5: Create `config.gcs.tfbackend`
1. Create a Google Cloud Storage (GCS) Bucket for Terraform remote state
2. Copy `config.gcs.tfbackend.sample` to `config.gcs.tfbackend`
3. Update value of `bucket`

### Step 6: Create `terraform.tfvars`
1. Copy `terraform.tfvars.sample` to `terraform.tfvars`
2. Update value of `project_id`
3. Update value of `region`
4. Update value of `repo_user_name` (after fork repositories)

### Step 7: Install Terraform
- Install `tfenv`: https://github.com/tfutils/tfenv
- Install latest Terraform version

# Execute Terraform Commands
Using `terraform.sh` script to execute terraform commands

```
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```

