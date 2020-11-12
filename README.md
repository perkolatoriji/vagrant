# vagrant
DevOps#1 project - Carlos Ijalba 2020.

-Description:  Ansible/Web/Prometheus/Grafana LAB

IaC & DaC Vagrant setup with virtualbox to create 4 machines in a local PC:

       1.- web1, with nginx
       2.- web2, with apache2
       3.- prom1, with prometheus
       4.- graf1, with grafana

-Intructions: 

  This Vagrant infra MUST be executed from where the Vagrantfile and it's associated folders exist,
  otherwise you will get various errors: (Net::SCP::Error), (Gem::Requirement::BadRequirementError). Update: added a Vagrant config files check, that will throw 
  an "---ERROR:" message when it cannot find varios config files, and report them.

  The passwords are kept in .sec files, which are ignored by git (customized on .gitignore file) and therefore not kept in the repository.
  In order for this project to work, you will have to create this files with your secret details (user/pass, API keys, etc). Instructions on how to make this .sec
  files will be given in the files/secrets/README.md file.

  This files are:

  	files/secrets/ansible_user.sec		# contains ansible user, used by config_ansible.sh
	files/secrets/ansible_pass.sec		# contains ansible user's password, used by config_ansible.sh
	files/secrets/datadog_api.sec		# contains datadot API KEY, used by config_datadog.sh

-Author:  Carlos Ijalba. Project Started in 2020.


This project will have the following premises:

  1.- All boxes will use Debian Linux. - We will try to use different providers to see which one works best, and if it is easy enough to change providers and the project will still run without major issues.

  2.- The VMs will be built from a provided box (we will not make our own), only customize the existing ones to suit our needs (easier).

  3.- The software in each VM will be provisioned via Ansible playbooks. Ansible itself will be provisioned via bash scripts under a Vagrant shell provisioner.

  4.- prom1 will be the Ansible control node.

  5.- if some software is too complex to install/configure via ansible scripts, then bash scripts will be fired from Vagrant under shell provisioners.

  6.- a static web site mut be deployed in nginx and in apache2 using the same code, whenever possible.

  7.- all the infra must be registered and monitored via prometheus/grafana.

  8.- the infrastructure must be inmutable, and recorded in git, IaC - Infrastructure as Code.
  
  9.- the infrastructure will be documented using diagrams, DaC - Documentation as Code. The infra's auto-generated diagram, will be included in the web site.
  
  10.- The repo is public, but security scanned by GitGuard, to intercept leaked secrets: users, passwords and keys.
  
  11.- the infra contains prometheus & grafana for auto-monitoring, however we will compare it against SaaS offerings, like Datadog, by using it's 14-day free trial period.
       To accomplish this setup, we will use ansible playbooks that can be run after vagrant deployment from the ansible master node (prom1). To deploy this additional setups 
       to the standard prometheus/grafana, sepparate readme's will specify the instructions for each SaaS product, and how to set it up.
       
  12.- there are some bash administration scripts, defined in files/scripts. It's usage will be described in sepparate README files.

#
