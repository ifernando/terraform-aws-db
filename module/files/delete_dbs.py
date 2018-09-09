#!/usr/bin/env python

import boto3
import sys
import time
import json
import argparse

from botocore.exceptions import ClientError
from datetime import datetime


def json_serial(obj):
    """JSON serializer for objects not serializable by default json code"""

    if isinstance(obj, datetime):
        serial = obj.isoformat()
        return serial
    raise TypeError("Type not serializable")


class ec2:
  def __init__(self, env, envtype, region, dry_run):

    self.env = env
    self.envtype = envtype
    self.region = region
    self.dry_run = dry_run

    self.client = boto3.client('ec2', region_name=region)

  def get_vpc(self):

    searchname = "%s-%s" % (self.env, self.envtype)

    vpcs = self.client.describe_vpcs()['Vpcs']
    for vpc in vpcs:
      if "Tags" in vpc:
        for tag in vpc['Tags']:
          if tag['Key'] == "Name" and searchname in tag['Value']:
            return vpc['VpcId']


class rds:
  def __init__(self, env, envtype, region, dry_run):
    self.env = env
    self.dry_run = dry_run
    self.client = boto3.client('rds', region_name=region)

    ec2c = ec2(env, envtype, region, dry_run)
    self.vpcid = ec2c.get_vpc()

  def _get_dbs(self):

    dblist = self.client.describe_db_instances()['DBInstances']
    filteredlist = []

    for db in dblist:
      if db['DBSubnetGroup']['VpcId'] == self.vpcid:
        filteredlist.append(db['DBInstanceIdentifier'])

    return filteredlist

  def delete_dbs(self):

    dblist = self._get_dbs()

    for db in dblist:
      if dry_run != True:
        print "deleting %s" % db
        self.client.delete_db_instance(DBInstanceIdentifier=db, SkipFinalSnapshot=True)

class elasticache:
  def __init__(self, env, envtype, region, dry_run):
    self.env = env
    self.dry_run = dry_run
    self.client = boto3.client('rds', region_name=region)

    ec2c = ec2(env, envtype, region, dry_run)
    self.vpcid = ec2c.get_vpc()

  def _get_dbs(self):

    dblist = self.client.describe_replication_groups()['ReplicationGroups']
    filteredlist = []

    #for db in dblist:

if __name__ == "__main__":

  parser = argparse.ArgumentParser(description="Delete a bitesize environment")
  parser.add_argument('--env', required=True)
  parser.add_argument('--envtype', required=True)
  parser.add_argument('--region', required=True)
  parser.add_argument('--dry-run', action='count')
  args = parser.parse_args()

  env = args.env
  envtype = args.envtype
  region = args.region
  dry_run = args.dry_run

  rds = rds(env, envtype, region, dry_run)

  rds.delete_dbs()

