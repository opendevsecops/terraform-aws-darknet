[![Codacy Badge](https://api.codacy.com/project/badge/Grade/38c901d1e0b64b8e8fa7d44241763d3d)](https://www.codacy.com/app/OpenDevSecOps/terraform-aws-darknet?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=opendevsecops/terraform-aws-darknet&amp;utm_campaign=Badge_Grade)
[![Follow on Twitter](https://img.shields.io/twitter/follow/opendevsecops.svg?logo=twitter)](https://twitter.com/opendevsecops)

# AWS DarkNet Terraform Module

Terraform module which provides darknet facilities for AWS infrastructures.

## Introduction

A darknet is a type of a honeypot. The network exists within visible network ranges that are actively used but it does not contain any network resources of its own. The purpose of the darknet is to capture traffic like a spider web. Since the darknet is not meant to be used for any functional resources, any captured traffic is interesting and potentially malicious.

## Caveats

Due to some odd constrains in HCL, it is impossible to pass undefined values thus the module replicates the flow submodule functionalities in separate modules depending if vpc, subnet or eni must be configured. It seems that this issue will be mitigated in HCL2, Terraform v0.12.
