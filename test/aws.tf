# Default
provider "aws" {
  version = "2.16.0"
  region  = "us-east-1"
}

provider "aws" {
  version = "2.16.0"
  region  = "ap-southeast-2"
  alias   = "ap-southeast-2"
}
