from diagrams import Diagram, Cluster

from diagrams.aws.compute import EC2
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Apache, Nginx


with Diagram("Project DevOps#1", show=True):
    with Cluster('vagrant'):
        nginx = Nginx('Nginx')
        apache = Apache('Apache2')
        
        with Cluster('Monitoring'):
            prom = Prometheus('Prometheus &\nAnsible control node') 
            graf = Grafana('Grafana')
            prom >> graf
    
    prom >> nginx
    prom >> apache

