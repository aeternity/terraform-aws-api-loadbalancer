# Default
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "ap-southeast-2"
}
