
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
default = "eu-north-1"
}
variable "awsprops" {
    type = map
    default = {
    ami = "ami-022b0631072a1aefe"
    itype = "t3.micro"
    publicip = true
    keyname = "awskey"
  }
}