variable "azs" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "region" {
  default = "us-west-2"
}

variable "instance_profile_name" {
  type = string
}

variable "bucket_name" {
  type = string
}