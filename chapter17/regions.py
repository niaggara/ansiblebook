#!/usr/bin/env python3
""" List of regions """
import boto3

ec2 = boto3.client("ec2")
regions = [region["RegionName"] for region in ec2.describe_regions()["Regions"]]
for r in regions:
    print(f"  - {r}")
