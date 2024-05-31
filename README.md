# Functional test to boot 3 connected PowerVS VMs with an image
## Pre-requisites
1. IBM Cloud account
2. IBM PowerVS Workspace
3. A public access COS bucket containing an OS image.

## Usage
1. Navigate to the root directory of this repository.
2. At least specify the values for the required variables in variables.tf by [creating a terraform.tfvars file or supplying them as environment variables.](https://developer.hashicorp.com/terraform/language/values/variables#using-input-variable-values) (Optional)
3. Run `terraform init`
4. Run `terraform apply`, optionally with [-var flags](https://developer.hashicorp.com/terraform/language/values/variables#variables-on-the-command-line) to specify the values for the input variables if not previously specified.
5. Provide the values for the variables prompted at the command line which have not been correctly specified in any of the above steps 2 or 4.
6. Type `yes` to confirm resource provisioning (Note: Resources will be charged as per IBM pricing).
7. Once the resources created above are no longer needed, run `terraform destroy` and confirm destruction of resources by entering `yes` at the prompt.

## Steps taken
1. Authenticate to IBM Cloud using the API key corresponding to the account in pre-requisite #1.
2. Import the OS image from the COS bucket created as a part of pre-requisite #3 into the PowerVS Workspace specified in pre-requisite #2.
3. Create a DHCP service in the PowerVS Workspace.
4. Create 3 VMs connected to the DHCP service created as a part of the above step that boot using the imported OS image.
