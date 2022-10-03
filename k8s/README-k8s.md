# Google k8s - GKE

#### 77. k8s
* most popilar open source container orchestration solution
* cluster management 
  * different types of VMS
* All the importatint orchestration features
  * auto-scale
  * service discovery
  * load balancer
  * self healing
  * 0 downtime deployments
* GKE - managed k8s engine
  * auto-repair, auto-upgrade
  * pod/cluster auto-scaling
  * enable cloud logging, cloud monitoring
  * container-optimized OS, by google
  * persistent disks/local ssd
* Autopilot mode - pey-per pod, auto-management, hands-off
* Standard mode - pay-per node, configure yourself

#### 80. Commands
* `gcloud container clusters get-credentials` to create/connect to cluster
* `kubectl` 
  * `create deployment ${name} ${image}` to create deployment
  * `get deployment` to see deployment
  * `expose deployment --port` to expose port 