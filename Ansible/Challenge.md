# Ansible Challenge
---

## Build the Path for the Custom Role

```
├── Challenge
│   ├── Terraform
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles
│       └── apache_install
│           ├── handlers
│           │   └── main.yml
│           ├── tasks
│           │   └── main.yml
│           ├── templates
│           │   ├── apache_config.j2
│           │   └── index.html.j2
│           └── vars
│               └── main.yml
```

## Terraform

The included terraform files will establish the connection to your AWS account, and will create 2 EC2 instances with the following AMI: data.aws_ami.ubuntu.id

### Output

Once the instances has been created the output will show you the actual private IPv4 IPs assigned for your resources

#### Example on how it looks like:

![AWS](https://github.com/KennethSV/DevOps_Path/blob/main/Ansible/Pages_Working/AWS.png)

## Ansible

Created a custom_role, named apache_install, in which it will make sure to push and install apache server to the hosts defined under inventory.ini

### Command for execution:

On the Challenge folder, execute the following:

`ansible-playbook -i inventory.ini playbook.yml`

### Test

Once the instances has been created, please make sure to access the the instances through the public_ip or public_host and port 8080. How it would like once you attempt the connection on browser:

![Test1](https://github.com/KennethSV/DevOps_Path/blob/main/Ansible/Pages_Working/ec2-18-189-32-195.us-east-2.compute.amazonaws.com1.png)

![Test2](https://github.com/KennethSV/DevOps_Path/blob/main/Ansible/Pages_Working/ec2-3-143-222-64.us-east-2.compute.amazonaws.com1.png)
