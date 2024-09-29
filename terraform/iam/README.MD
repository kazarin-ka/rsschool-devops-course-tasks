# IAM

This directory contains configurations related to IAM settings. 

A separate Terraform project was created to isolate the configuration of policies, 
roles, and users from other configurations, in order to minimize damage in case of 
failure and potentially enhance security in the future by applying stricter 
permissions to read its state file