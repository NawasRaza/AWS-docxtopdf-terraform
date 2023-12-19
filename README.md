# AWS DOCX to PDF Conversion

This repository provides scripts and instructions for converting DOCX files to PDF using AWS services.

## Introduction

The goal of this project is to streamline the conversion of Microsoft Word documents in DOCX format to PDF using AWS. The conversion process is scalable, reliable, and ensures a consistent output.

## Prerequisites

Before you begin, ensure that you have the following prerequisites installed:

- Terraform ((Install here - https://developer.hashicorp.com/terraform/install ))
- AWS access key  & secret key, Replace them in  providers.tf  with your actual keys.
- Python (if using AWS SDK for Python - Boto3)
- Microsoft Word documents in DOCX format

## Setup

1. **Configure AWS Credentials:**
 Refer to this link for configuring your aws credentials using terraform. https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Important Points

- It is important that you replace credentials with your own AWS credentials, Otherwise, Terraform will not be able to recognize your AWS account and this project will not work.
- Python directory contains a zip file which include python file for performing conversions and all the required packages/modules needed to complete the conversion.  
- If you don't want to download  my zip folder, You can make your own zip folder, It should include python file plus all dependencies necessary to perform conversion.(( ZIP is important in order for this project to work. ))
- It is important to upload zip file to lambda function, so that lambda function will be able to perform conversion. ((Which is automated in python code, But if you make your own zip then make sure to include all necessary files. ))
- Once you run terraform commmands mentioned below, It should automatically provision an s3 bucket, lambda function, s3 event notification, their IAM policies/roles accordingly to interact with each other.


  ## Usage


#### Requirements:
- Python installed on your local machine
- CLI configured with the necessary credentials
- DOCX file that you want to convert

#### Steps:
1. Open a terminal or command prompt.

2. Navigate to the project directory:
   ```bash
   cd path/to/aws-docx-to-pdf-conversion

3. Once everything is settled and in one directory, Run the following terraform commands.
   ```bash
   1- terraform init. 
   2- terraform plan.
   3- terraform apply.

Now terraform will work automatically and provisions all the resources written in main.tf

4. Review it on your AWS console, that everything is provisioned correctly and performing conversion.

5. Once reviewed, Make sure to delete the resources, Luckily terraform will do that for you, Run the following command to delete all the resources.
   ```bash
   terraform destroy

## Dependencies

The following Python packages are required for this project:

```plaintext
boto3==1.18.67
python-docx==0.8.11
reportlab==3.6.1

Installing Dependencies
To install the required dependencies, run the following command within your virtual environment:
pip install -r requirements.txt


