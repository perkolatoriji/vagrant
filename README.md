# vagrant
DevOps#1 project - Carlos Ijalba 2020.

Vagrant setup with virtualbox to create 4 machines in a local PC:

       1.- web1, with nginx
       2.- web2, with apache2
       3.- prom1, with prometheus
       4.- graf1, with grafana

This project will have the following premises:

  1.- All boxes will use Debian Linux. - We will try to use different providers to see which one works best, and if it is easy enough to change providers and the project will still run without major issues.

  2.- The VMs will be built from a provided box (we will not make our own), only customize the existing ones to suit our needs (easier).

  3.- The software in each VM will be provisioned via Ansible playbooks. Ansible itself will be provisioned via bash scripts under a Vagrant shell provisioner.

  4.- prom1 will be the Ansible control node.

  5.- if some software is too complex to install/configure via ansible scripts (prometheus/grafana), then bash scripts will be fired from Vagrant under shell provisioners.

  6.- a static web site mut be deployed in nginx and in apache2 using the same code, whenever possible.

  7.- all the infra must be registered and monitored via prometheus/grafana.

  8.- the infrastructure must be inmutable, and recorded in git.

#
