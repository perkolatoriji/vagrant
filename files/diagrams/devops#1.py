from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Apache, Nginx
from diagrams.onprem.iac import Ansible 


with Diagram("Project DevOps#1", show=True):
    with Cluster('Project DevOps#1 Infrastructure in vagrant - VirtualBox VMs'):
        with Cluster('web1'):
          nginx = Nginx('Nginx')
        with Cluster('Web2'):
          apache = Apache('Apache2')
        with Cluster('Monitoring'):
            with Cluster('prom1'):
              prom = Prometheus('Prometheus')
              ans = Ansible('Ansible control node')
            with Cluster('graf1'):
              graf = Grafana('Grafana')
    prom - graf
    prom >> nginx
    prom >> apache
