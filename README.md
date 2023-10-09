# Three_Tire_Terraform
A Three-Tier Architecture Using Terraform is a design and infrastructure provisioning approach for building and managing scalable and resilient web applications or services. Terraform is an Infrastructure as Code (IaC) tool that allows you to define and automate the provisioning of infrastructure resources on cloud platforms like AWS and others.
Here is the graph ive generated  using AI tools, I have written step by step notes and created an AI graph .



++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

graph LR
    subgraph VPC
        Create a folder as Network
        Inside Network create main.tf - variable.tf - output.tf

        main.tf
            provider aws
            create a VPC
            check the az
            create IGW
            create one Public subnets
            create Pub route table and attach the pub subnet to the pub route table
            create NAT and attach Pub Subnet to the NAT

        App tire private routes:
            create private subnet and dont give internet access (app_private_subnets)
            Create a private route table and dont give internet access and attach a NAT gateway and in route table association dont forget to attch Private subnet to Private RT.(app_private_Route)

        DB tire private routes
            create private subnet and dont give internet access (db_private_subnets)
            Create a private route table and dont give internet access and attach a NAT gateway and in route table association dont forget to attch Private subnet to Private RT.(db_private_Route)

        Security groups
            Create Web-tier lb sg
            Create Web-tier sg

            Create App-tire lb sg
            Create App-tire sg

            Create db SG
            Create the db subnet group2

        Output.tf
        Variable.tf
    end

    subgraph Loadbalancer
        LOADBALANCER:
            Here we will create two load balancers, one is internet-facing and another one is internal facing
            - Internet facing LB
            - Internal facing LB
    end

    subgraph Compute
        COMPUTE:
        In the main.tf file we will start with getting the latest AMI using the AWS SSM parameter, create the launch template and ASG, then attach it to the loadbalacer target group.
        - aws launch template for web-tier
        - create asg

        - aws launch template for app-tier
        - create asg
    end

    subgraph Database
        The database tier, In the main.tf we will be creating a MySQL db.
        - Mian.tf
        - variable.tf
        - output.tf
    end

    Root Module
        Combine all other modules we have created (Compute, Loadbalancer, Network, Database)
    end

    Network --> Loadbalancer
    Loadbalancer --> Compute
    Network --> Compute
    Network --> Database
    Compute --> Database

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
