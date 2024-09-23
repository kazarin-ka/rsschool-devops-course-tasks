# Init

This repository stores the configuration of basic entities such as S3 buckets and DynamoDB tables, 
which are necessary for the operation of other Terraform states. 

The code has been separated into a standalone repository to reduce the failure domain in case 
of an error and to avoid destroying other parts of the project.