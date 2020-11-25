variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "prefix" {
  default = "aks-prod"
  description = "A prefix used for all resources in this example"
}

variable "location" {
  default = "centralus"
  description = "The Azure Region in which all resources in this example should be provisioned"
}