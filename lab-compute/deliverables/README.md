## [SCREENSHOTS](https://github.com/SJSU-Mahmood/lab-2-compute-juniemariam/tree/main/deliverables/ScreenShots)
## Questions


1. Imagine that your application will need to run two always-on `f1.2xlarge` instances (which come with instance storage and won't require any EBS volumes). To meet seasonal demand, you can expect to require as many as four more instances for a total of 100 hours through the course of a single year. What combination of instance types should you use? Calculate your total estimated monthly and annual costs.

Basic requirement for the application:
  - Number of Instances: 2
  - Duration: 27*7
  - On-Demand hourly rate = $0.362
  - Monthly Cost = 2 Instances x  $0.362/hour x 24 hours/day x 30 days = $520.32
  - Annual Cost = 2 Instances x  $0.362/hour x 24 hours/day x 365 days = $6,336.96
  - Additional Seasonal Cost = 4 Instances x $0.362/hour x 100 hours =  $144.80

  - Montly Cost = $520.32
  - Annual Cost = $6,336.96(mandatory) + $144.80 (seasonal) = $6,481.76
---
2. What are some benefits to using an Elastic Load Balancer and an Auto Scaling Group? What are some cons?
    #### Benefits:
    - High Availability: ELB spreads incoming traffic across multiple instances, so no single instance gets overwhelmed.
    - Scalability: ASGs automatically adjust the number of instances based on traffic, so you’re always prepared for high or low demand.
    - Fault Tolerance: If an instance fails, ASG will replace it, and ELB will reroute traffic to the healthy instances, keeping everything running smoothly.
    - Cost Efficiency: You only pay for the resources you actually use by scaling up or down based on demand.
    #### Cons:
    - Additional Costs: Using ELB comes with extra charges, so keep an eye on your budget.
    - Configuration Complexity: Setting up and fine-tuning ELB and ASG can be a bit tricky and might need some extra know-how.
    - Latency: ELB adds an extra step in the network, which could slightly increase latency.
   
---
3. What's the difference between a launch template and a launch configuration?
   1. Launch Configuration:
      - Older, simpler method for setting up EC2 instances.
      - You can choose things like AMI, instance type, and key pair.
      - Can't be changed after it's created—if you want to update it, you have to make a brand new one.
   2. Launch Template:
       - Newer and much more flexible.
       - Lets you create multiple versions with different settings (e.g., instance types, AMIs).
       - Supports extra features like spot instances, tagging, and T2/T3 unlimited.
       - You can have different templates for testing, production, and other environments.
---
4. What's the purpose of a security group?
   - A Security Group in AWS acts like a personal firewall for your EC2 instances.
   - It controls what traffic is allowed in and out, based on rules you set.
   - You can allow or block traffic by specifying ports, protocols, and IP addresses.
   - Apply multiple layers of security by using different security groups for different tasks.
   - Update rules anytime without needing to restart your instances.
---
6. What's the method to convert an existing unencrypted EBS volume to an encrypted EBS volume?
   1. Create a snapshot of the unencrypted EBS volume.
   2. Copy the snapshot while enabling encryption on the copy.
   3. Create a new EBS volume from the encrypted snapshot.
   4. Detach the unencrypted EBS volume from the instance and attach the new encrypted volume.
