Terraform code for creating Single Node Cluster in EC2

Main.tf

resource "aws_instance" "kubernetes_node" {
  ami           = "ami-0557a15b87f6559cf"  # Update with your desired AMI
  instance_type = "t2.micro"                # Update with your desired instance type
  key_name      = "Pratham"           # Update with your SSH key pair name
  security_groups = [aws_security_group.kubernetes_sg.name]  # Reference the security group by name
 
  tags = {
    Name = "kubernetes-node"
  }
 
  user_data = <<-EOF
    #!/bin/bash
    apt-get update && apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    kubeadm init --pod-network-cidr=10.244.0.0/16
    EOF
}
 
output "kubernetes_cluster_ip" {
  value = aws_instance.kubernetes_node.private_ip
}
