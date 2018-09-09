resource "aws_ssm_document" "db-cb-get" {
  name = "${local.fullname}-couchbase-get-cluster-ip"

  document_type = "Command"

  content = <<DOC
  {
      "schemaVersion": "2.2",
      "description": "Run couchbase host-list",
      "parameters": {
            "UserName": {
              "type": "String",
              "description": "Couchbase user name"
          },
          "Password": {
              "type": "String",
              "description": "Password of the Couchbase cluster"
          },     
            "IpAddress": {
              "type": "String",
              "description": "Cluster IP address"
          }
      },
      "mainSteps": [
        {
          "action": "aws:runShellScript",
          "name": "hostlist",
          "inputs": {
            "runCommand": ["/opt/couchbase/bin/couchbase-cli host-list --cluster {{IpAddress}} -u {{UserName}} -p {{Password}} | grep -v {{IpAddress}} | head -n 1"]
          }
        }
      ]
    }
    DOC
}

resource "aws_ssm_document" "db-cb-remove-node" {
  name = "${local.fullname}-couchbase-server-remove"

  document_type = "Command"

  content = <<DOC
  {
      "schemaVersion": "2.2",
      "description": "Run couchbase remove node",
      "parameters": {
            "UserName": {
              "type": "String",
              "description": "Couchbase user name"
          },
          "Password": {
              "type": "String",
              "description": "Password of the Couchbase cluster"
          },     
            "ClusterIpAddress": {
              "type": "String",
              "description": "Cluster IP address"
          },
            "RemoveIpAddress": {
              "type": "String",
              "description": "IP Address of the node to be removed."
          }
      },
      "mainSteps": [
        {
          "action": "aws:runShellScript",
          "name": "hostlist",
          "inputs": {
            "runCommand": ["/opt/couchbase/bin/couchbase-cli rebalance -c {{ClusterIpAddress}} -u {{UserName}} -p {{Password}} --server-remove={{RemoveIpAddress}}"]
          }
        }
      ]
    }
    DOC
}

resource "aws_ssm_document" "db-cb-create-user" {
  name = "${local.fullname}-couchbase-create-user"

  document_type = "Command"

  content = <<DOC
  {
     "schemaVersion": "2.2",
     "description": "Create CB RBAC",
     "parameters": {
        "AdminPassword": {
            "type": "String",
            "description": "Password of the Couchbase cluster."
        },     
          "ClusterIpAddress": {
            "type": "String",
            "description": "Cluster IP address."
        },
        "RbacUsername": {
            "type": "String",
            "description": "RBAC user name."
        },
        "RbacPassword": {
            "type": "String",
            "description": "RBAC password."
        },     
        "Roles": {
            "type": "String",
            "description": "Couchbase roles."
        }     
    },
    "mainSteps": [
      {
        "action": "aws:runShellScript",
        "name": "usermanage",
        "inputs": {
          "runCommand": ["/opt/couchbase/bin/couchbase-cli user-manage -c {{ClusterIpAddress}} -u Administrator -p {{AdminPassword}} --set --rbac-username {{RbacUsername}} --rbac-password {{RbacPassword}} --auth-domain local --roles {{Roles}}"]
        }
      }
    ]
  }
  DOC
}

resource "aws_ssm_document" "db-cb-restore" {
  name          = "${local.fullname}-couchbase-cbrestore"

  document_type = "Command"

  content = <<DOC
  {
      "schemaVersion": "2.2",
      "description": "Run cbrestore",
      "parameters": {
            "Host": {
              "type": "String",
              "description": "CB node ip which needs to restore the backup"
          },
          "SourceBucketName": {
              "type": "String",
              "description": "Source bucket name"
          },     
          "DestinationBucketName": {
              "type": "String",
              "description": "Destination bucket name"
          },
            "BackupFilePath": {
              "type": "String",
              "description": "full path (s3) of the backup file"
          },
            "BucketRamsize": {
              "type": "String",
              "description": "Bucket RAM size"
          }        
      },
      "mainSteps": [
        {
          "action": "aws:runShellScript",
          "name": "hostlist",
          "inputs": {
            "runCommand": ["/usr/local/bin/bitesize_cbrestore.sh {{Host}} {{SourceBucketName}} {{DestinationBucketName}} {{BackupFilePath}} {{BucketRamsize}}"]
          }
        }
      ]
    }
    DOC
}

