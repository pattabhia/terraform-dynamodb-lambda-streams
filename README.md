# DynamoDB Streaming To Lambda

Provision an **AWS DynamoDB table** with **Streams enabled**, and deploy a **Lambda consumer** that reacts to every INSERT, UPDATE, or DELETE.  
This project demonstrates an **event-driven architecture pattern** using **Terraform** as infrastructure-as-code.

---

## 🚀 Features

- DynamoDB table with:

  - PAY_PER_REQUEST billing
  - Primary key (`employeeid`)
  - Streams enabled (`NEW_AND_OLD_IMAGES`)
  - Point-in-time recovery (PITR)
  - Server-side encryption

- Lambda consumer:

  - Python 3.12 function
  - Automatically zipped and deployed via Terraform
  - Subscribed to DynamoDB Stream
  - Logs old & new item images to CloudWatch

- Modular Terraform structure:
  - `dynamodb_table` module
  - `lambda_consumer` module
  - Easily extendable for GSIs, TTL, S3 outputs, etc.

---

## 📂 Project Structure

```css
infra/
├─ main.tf # root composition
├─ providers.tf
├─ variables.tf
├─ outputs.tf
└─ modules/
├─ dynamodb_table/
│ ├─ main.tf
│ ├─ variables.tf
│ └─ outputs.tf
└─ lambda_consumer/
├─ main.tf
├─ variables.tf
├─ outputs.tf
└─ lambda/
└─ lambda_function.py
```

---

## ⚡ Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- AWS CLI configured with credentials (`aws configure`)
- Python 3.12 (for Lambda runtime)

---

## 🛠 Usage

1. Clone this repo:

   ```bash
   git clone https://github.com/<your-username>/terraform-dynamodb-lambda-streams.git
   cd terraform-dynamodb-lambda-streams/infra
   ```

2. Initialize Terraform
   ```css
    terraform init
   ```
3. Apply changes

   ```css
   terraform apply
   ```

   Review the plan and confirm with yes.

Testing

Insert a record:

```css
aws dynamodb put-item \
  --table-name employees \
  --item '{"employeeid":{"S":"E101"},"name":{"S":"Alice"},"department":{"S":"Finance"}}'
```

Check the CloudWatch Logs for the Lambda function employees_stream_consumer to see the change event.

Sample Log

```json
{
  "eventName": "INSERT",
  "keys": { "employeeid": "E101" },
  "old": null,
  "new": { "employeeid": "E101", "name": "Alice", "department": "Finance" },
  "approximateCreationTime": "2025-08-23 14:05:22"
}
```
