# Instance Groups and Load Balancing
https://www.udemy.com/course/google-cloud-professional-cloud-architect-certification/learn/lecture/26121360#overview

### 26. Getting Started with Instance Groups

#### Instance Groups
* Instance group - group of VMs managed as a single entity
* 2 Types:
  * Managed - identical VMs using a template. Autoscale, auto heal (based on passed/failed health checks) as a single group, managed releases.
  * Unmanaged - different configuration for VMs in the same group - different images, different hardware. No autoscale, auto heal etc. 
* Location: Zonal or Regional

####  Managed Instance Groups
* Identical VMs using instance template
* Can maintain N instances (failed ones auto-replaced)
* Autoscaling
* Can add load balancer
* Can be multi-zonal for regional Migs
* Release new app versions without downtime
  * Rolling updates - new version release step by step
  * Canary deployment - test new verions with a group before rollout


### 27. Creating Migs
* Instance template is mandatory
* Configure 
  * autoscaling with min/max amount of instances 
  ![autoscale.png](img/autoscale.png)
    * based on CPU utilization target, lb utilization target or any other metric
  * can schedule
  * various scale-in controls - e.g. no more than 10% VMs every 10 minutes
  ![scale.png](img/scale.png)
  * autohealing: healthcheck with initial delay (how long before accepting traffic)
  ![autoheal.png](img/autoheal.png)

* There is no real tf setting to make it managed - instead it becomes managed as configuration is added. 
  * use stateful_disk to make a mig stateful
* When creating from console, managed/unmanaged can be specified

