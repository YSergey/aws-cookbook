locals {
    iam1 = {
        sysname = "IAM-1"
    }
}

locals {
    iam2 = {
        sysname = "IAM-2"
    }
}

locals {
    iam3 = {
        sysname = "IAM-3"
    }
}

locals {
    vpc1 = {
        sysname = "vpc-1"
        vpc_cidr = "10.0.0.0/16"
        public_subnet_1_1_cidr = "10.0.1.0/24"
        isolated_subnet_1_1_cidr = "10.0.2.0/24"
        public_subnet_1_2_cidr = "10.0.3.0/24"
        isolated_subnet_1_2_cidr = "10.0.4.0/24"
        create_igw = true
        route_transit_gateway = false
        availability_zone_1 = "us-west-2a"
        availability_zone_2 = "us-west-2b"
    }
}

locals {
    vpc2 = {
        sysname = "vpc-2"
        vpc_cidr = "10.1.0.0/16"
        public_subnet_2_1_cidr = "10.1.1.0/24"
        isolated_subnet_2_1_cidr = "10.1.2.0/24"
        public_subnet_2_2_cidr = "10.1.3.0/24"
        isolated_subnet_2_2_cidr = "10.1.4.0/24"
        create_igw = false
        route_transit_gateway = true 
        availability_zone_1 = "us-west-2a"
        availability_zone_2 = "us-west-2b"
    }
}

locals {
    vpc3 = {
        sysname = "vpc-3"
        vpc_cidr = "10.2.0.0/16"
        public_subnet_3_1_cidr = "10.2.1.0/24"
        isolated_subnet_3_1_cidr = "10.2.2.0/24"
        public_subnet_3_2_cidr = "10.2.3.0/24"
        isolated_subnet_3_2_cidr = "10.2.4.0/24"
        create_igw = false
        route_transit_gateway = true 
        availability_zone_1 = "us-west-2a"
        availability_zone_2 = "us-west-2b"
    }
}

locals {
    ec2_1 = {
        sysname = "EC2-1"
        security_group_name = "EC2-1-security-group"
        instance_type = "t2.micro"
        availability_zone_1 = "us-west-2a"
    } 
}

locals {
    ec2_2 = {
        sysname = "EC2-2"
        security_group_name = "EC2-2-security-group"
        instance_type = "t2.micro"
        availability_zone_1 = "us-west-2a"
    } 
}

locals {
    ec2_3 = {
        sysname = "EC2-3"
        security_group_name = "EC2-3-security-group"
        instance_type = "t2.micro"
        availability_zone_1 = "us-west-2a"
    } 
}

locals {
    tgw = {
        sysname = "TGW"
    }
}