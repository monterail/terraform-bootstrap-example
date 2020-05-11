# The recommendation now is to declare a "local" backend block instead of having no backend declared for the initial bootstrap.
terraform {
  backend "local" {}
}
