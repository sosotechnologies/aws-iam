# resource "kubernetes_storage_class_v1" "efs_sc" {  
#   metadata {
#     name = "efs-sc"
#   }
#   storage_provisioner = "efs.csi.aws.com"  
#   parameters = {
#     provisioningMode = "efs-ap"
#     fileSystemId =  "fs-02a1e2d4bb9fee314"
#     directoryPerms = "700"
#     gidRangeStart = "1000" # optional
#     gidRangeEnd = "2000" # optional
#     basePath = "/dynamic_provisioning" # optional
#   }
  
#   # depends_on = [
#   #    aws_efs_file_system.mimeo
#   #  ]
# }

# # Resource: Persistent Volume Claim
# resource "kubernetes_persistent_volume_claim_v1" "efs_pvc" {
#   metadata {
#     name = "efs-claim"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     storage_class_name = kubernetes_storage_class_v1.efs_sc.metadata[0].name 
#     resources {
#       requests = {
#         storage = "5Gi"
#       }
#     }
#   }
# }

# # resource "kubernetes_deployment_v1" "efs_test_deployment" {
# #   metadata {
# #     name = "efs-test-deployment"
# #     labels = {
# #       app = "efs-test"
# #     }
# #   }

# #   spec {
# #     replicas = 1

# #     selector {
# #       match_labels = {
# #         app = "efs-test"
# #       }
# #     }

# #     template {
# #       metadata {
# #         labels = {
# #           app = "efs-test"
# #         }
# #       }

# #       spec {
# #         container {
# #           name  = "nginx"
# #           image = "nginx:latest"

# #           volume_mount {
# #             name       = "efs-volume"
# #             mount_path = "/usr/share/nginx/html"  # Mount path in the container
# #           }

# #           port {
# #             container_port = 80
# #           }
# #         }

# #         volume {
# #           name = "efs-volume"

# #           persistent_volume_claim {
# #             claim_name = kubernetes_persistent_volume_claim_v1.efs_pvc.metadata[0].name
# #           }
# #         }
# #       }
# #     }
# #   }
# # }

# # # # Resource: Kubernetes Pod - Write to EFS Pod
# # # resource "kubernetes_pod_v1" "efs_write_app_pod" {
# # #   # depends_on = [ aws_efs_mount_target.mimeo]
# # #   metadata {
# # #     name = "efs-write-app"
# # #   }
# # #   spec {
# # #     container {
# # #       name  = "efs-write-app"
# # #       image = "busybox"
# # #       command = ["/bin/sh"]
# # #       args = ["-c", "while true; do echo EFS Kubernetes Dynamic Provisioning Test $(date -u) >> /data/efs-dynamic.txt; sleep 5; done"]
# # #       volume_mount {
# # #         name = "persistent-storage"
# # #         mount_path = "/data"
# # #       }
# # #   }
# # #   volume {
# # #     name = "persistent-storage"
# # #     persistent_volume_claim {
# # #       claim_name = kubernetes_persistent_volume_claim_v1.efs_pvc.metadata[0].name 
# # #     } 
# # #   }
# # # }
# # # } 


# # # # Resource: UserMgmt WebApp Kubernetes Deployment
# # # resource "kubernetes_deployment_v1" "myapp1" {
# # #   # depends_on = [ aws_efs_mount_target.mimeo]
# # #   metadata {
# # #     name = "myapp1"
# # #   }
# # #    spec {
# # #     replicas = 2
# # #     selector {
# # #       match_labels = {
# # #         app = "myapp1"
# # #       }
# # #     }
# # #     template {
# # #       metadata {
# # #         name = "myapp1-pod"
# # #         labels = {
# # #           app = "myapp1"
# # #         }
# # #       }
# # #       spec {
# # #         container {
# # #           name  = "myapp1-container"
# # #           image = "stacksimplify/kubenginx:1.0.0"
# # #           port {
# # #             container_port = 80
# # #           }
# # #           volume_mount {
# # #             name = "persistent-storage"
# # #             mount_path = "/usr/share/nginx/html/efs"
# # #           }
# # #         }
# # #         volume {          
# # #           name = "persistent-storage"
# # #           persistent_volume_claim {
# # #           claim_name = kubernetes_persistent_volume_claim_v1.efs_pvc.metadata[0].name 
# # #         }
# # #       }
# # #     }
# # #   }
# # # }
# # # }


# # # # Resource: Kubernetes Service Manifest (Type: Load Balancer - Classic)
# # # resource "kubernetes_service_v1" "lb_service" {
# # #   metadata {
# # #     name = "myapp1-clb-service"
# # #   }
# # #   spec {
# # #     selector = {
# # #       app = kubernetes_deployment_v1.myapp1.spec[0].selector[0].match_labels.app
# # #     }
# # #     port {
# # #       port        = 80
# # #       target_port = 80
# # #     }
# # #     type = "LoadBalancer"
# # #   }
# # # }

# # # # Resource: Kubernetes Service Manifest (Type: Load Balancer - Network)
# # # resource "kubernetes_service_v1" "network_lb_service" {
# # #   metadata {
# # #     name = "myapp1-network-lb-service"
# # #     annotations = {
# # #       "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"    # To create Network Load Balancer
# # #     }
# # #   }
# # #   spec {
# # #     selector = {
# # #       app = kubernetes_deployment_v1.myapp1.spec[0].selector[0].match_labels.app
# # #     }
# # #     port {
# # #       port        = 80
# # #       target_port = 80
# # #     }
# # #     type = "LoadBalancer"
# # #   }
# # # }

