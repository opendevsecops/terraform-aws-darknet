[![Codacy Badge](https://api.codacy.com/project/badge/Grade/38c901d1e0b64b8e8fa7d44241763d3d)](https://www.codacy.com/app/OpenDevSecOps/terraform-aws-darknet?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=opendevsecops/terraform-aws-darknet&amp;utm_campaign=Badge_Grade)
[![Follow on Twitter](https://img.shields.io/twitter/follow/opendevsecops.svg?logo=twitter)](https://twitter.com/opendevsecops)

# AWS DarkNet Terraform Module

Terraform module which provides darknet facilities for AWS infrastructures.

## Introduction

A darknet is a type of a honeypot. The network exists within visible network ranges that are actively used but it does not contain any network resources of its own. The purpose of the darknet is to capture traffic like a spider web. Since the darknet is not meant to be used for any functional resources, any captured traffic is interesting and potentially malicious.

## Getting Started

Getting started is easy. You will need a VPC and some subnets. Allocate and clearly mark the subnets that you will use for your application. The subnets in between can be used as darknets. Any traffic in the darknets will be flagged as malicious. This will typically occur as soon as an attacker breaks in and tries to explore your network resources.

Here is a complete example of how to configure an AWS VPC with two subnets. The first subnet is allocated as a darknet. The secondary subnet is for application use only.

```terraform
resource "aws_vpc" "test" {
  cidr_block = "10.52.52.0/24"

  tags {
    Name = "test"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.test.id}"

  tags {
    Name = "test"
  }
}

resource "aws_subnet" "darknet" {
  vpc_id     = "${aws_vpc.test.id}"
  cidr_block = "10.52.52.0/25"

  tags {
    Name = "test_darknet"
  }
}

resource "aws_subnet" "adjacent" {
  vpc_id     = "${aws_vpc.test.id}"
  cidr_block = "10.52.52.128/25"

  tags {
    Name = "test_adjacent"
  }
}

resource "aws_route_table" "test" {
  vpc_id = "${aws_vpc.test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  
  tags {
    Name = "test"
  }
}

resource "aws_route_table_association" "darknet" {
  subnet_id      = "${aws_subnet.darknet.id}"
  route_table_id = "${aws_route_table.test.id}"
}

resource "aws_route_table_association" "adjacent" {
  subnet_id      = "${aws_subnet.adjacent.id}"
  route_table_id = "${aws_route_table.test.id}"
}

module "darknet" {
  source = "opendevsecops/darknet/aws"

  subnet_id = "${aws_subnet.darknet.id}"

  ...

  depends_on = ["${aws_subnet.darknet.id}"]
}
```

This module is automatically published to the Terraform Module Registry. More information about the available inputs, outputs, dependencies and instructions how to use the module can be found at the official page [here](https://registry.terraform.io/modules/opendevsecops/darkweb).

## Tips & Tricks

Darknets is a easy, low-cost and quite useful defence and early attack detection mechanisms but it requires some degree of know how to implement correclty. In this section you will find a few tips and tricks that will help you implement better darknets:

### Keep Your Subnets Small

The smaller your darknet subnet is the better. Consider that attackers would typically scan an entire class C network in a single go so your darknet could be entirely missed if it sits outside.

## Caveats

Due to some odd constrains in HCL, it is impossible to pass undefined values thus the module replicates the flow submodule functionalities in separate modules depending if vpc, subnet or eni must be configured. It seems that this issue will be mitigated in HCL2, Terraform v0.12.
