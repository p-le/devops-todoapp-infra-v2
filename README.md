# Requirements

### Step 1: Generate SSH Keys, GitHub Personal Access Token

### Step 1: Install Terraform
- Install `tfenv`: https://github.com/tfutils/tfenv
- Install latest Terraform version

### Step 2: GCP Service Account Key
- Create a service account with enough IAM Role Permission in target GCP Project
- Generate JSON Service Account Key
- Download, rename to `service_account.json` and place JSON Service Account Key in root folder of this project
- Update `GOOGLE_PROJECT` in `terraform.sh`

*Note: Do not push GCP Service Account Key into GitHub Respository*

### Step 3: `.env` file
1. Generate `.env` file
2. Update `GOOGLE_PROJECT`, and `GOOGLE_APPLICATION_CREDENTIALS` values

### Step 4: Remote Backend State
1. Create a Google Cloud Storage (GCS) Bucket for Terraform remote state
2. Copy `config.gcs.tfbackend.sample` to `config.gcs.tfbackend`
3. Update value of `bucket`

### Step 5: terraform.tfvars
1. Copy `terraform.tfvars.sample` to `terraform.tfvars`
2. Update value of `project_id`
3. Update value of `region`
4. Update value of `zone`
5. Update value of `db_user`
6. Update value of `db_password`

# Execute Terraform Plan
Using `terraform.sh` script to execute terraform commands

```
./terraform.sh init
./terraform.sh plan
./terraform.sh apply
```

