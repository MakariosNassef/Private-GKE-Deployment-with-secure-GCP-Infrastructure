# variable "email" {
#   type = list
#   default = ["makarios059@gmail.com","my-first-serviceaccount-345@iti-makarios.iam.gserviceaccount.com"]
# }

variable "vpc_name" {
    description = "vpc name"
}

variable "management-subnet-name" {
    description = "name-of management subnet"
}

variable "restricted-subnet-name" {
    description = "name-of restricted subnet"
}
