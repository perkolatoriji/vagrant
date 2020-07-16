# -*- mode: ruby -*-
# vi: set ft=ruby :
# Use config.yaml for basic VM configuration.
#
################################################
###  --Vagrantfile--
#
# -Project:		DevOps#1
# -Description:		Ansible/Web/Prometheus/Grafana LAB
#
# -Infrastructure:	Deploys 1 VM for Prometheus, 1x for Grafana, 2x for Web Servers (nginx & apache2)
#			prom1 is used as the ansible control node
#
# -Intructions: This Vagrant infra MUST be executed from where the Vagrantfile and it's associated folders exist,
#               otherwise you will get various errors: (Net::SCP::Error), (Gem::Requirement::BadRequirementError)
#
# -Author:		Carlos Ijalba
#
# -Version:		1.23
#
#################################################################

# Vars:

require "yaml"

rsa_pub = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
cfg_file = "./config/config.yaml"
#cur_dir = File.dirname(File.expand_path(__FILE__))
#cfg_file = "#{cur_dir}/config/config.yaml"

if !File.exist?("#{cfg_file}")
  raise "---ERROR: Config file missing!, make sure the config file exists & try again (usually config/config.yaml)."
end
vconfig = YAML::load_file("#{cfg_file}")

NETWORK = vconfig["vagrant_ip"]
DOMAIN  = vconfig["vagrant_domain_name"]
RAM     = vconfig["vagrant_memory"]
VM      = vconfig["vagrant_box"]
VM_VER  = vconfig["vagrant_box_version"]
SSH     = "22"                                  # SSH port prefix, suffix will be added in :ssh_port

servers = [
  {
    :hostname => "prom1." + "#{DOMAIN}",
    :box => "#{VM}",
    :box_ver => "#{VM_VER}",
    :ram => "#{RAM}",
    :ip => "#{NETWORK}" + "11",
    :ssh_port => "#{SSH}" + "11",
    :ansible_install => "./files/scripts/ansible_install.sh",
    :ansible_config  => "./files/scripts/ansible_config.sh",
    :source          => "./files",
    :destination     => "/home/vagrant"
  },
  {
    :hostname => "graf1." + "#{DOMAIN}",
    :box => "#{VM}",
    :box_ver => "#{VM_VER}",
    :ram => "#{RAM}",
    :ip => "#{NETWORK}" + "12",
    :ssh_port => "#{SSH}" + "12"
  },
  {
    :hostname => "web1." + "#{DOMAIN}",
    :box => "bento/debian-10.3",
#   :box_ver => "#{VM_VER}",
    :ram => "#{RAM}",
    :ip => "#{NETWORK}" + "13",
    :ssh_port => "#{SSH}" + "13"
  },
  {
    :hostname => "web2." + "#{DOMAIN}",
    :box => "#{VM}",
    :ram => "#{RAM}",
    :ip => "#{NETWORK}" + "14",
    :ssh_port => "#{SSH}" + "14"
  }]


# Main:

Vagrant.configure(2) do |config|

  servers.each do |machine|

    config.vm.define machine[:hostname] do |node|

      node.vm.box         = machine[:box]
      node.vm.box_version = machine[:box_ver]
      node.vm.hostname    = machine[:hostname]
      node.vm.network :private_network, ip: machine[:ip]
      node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"

## VirtualBox Provider:
      node.vm.provider :virtualbox do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", machine[:ram]]
        vbox.customize ["modifyvm", :id, "--name", machine[:hostname]]
      end # provider virtualbox ##

## Ansible Install & Configure:
      if (!machine[:ansible_install].nil?)
        if File.exist?(machine[:ansible_install])
	  node.vm.provision :shell, path: machine[:ansible_install]
	end
        if File.exist?(machine[:ansible_config])
          node.vm.provision :file, source: machine[:source], destination: machine[:destination]
          node.vm.provision :shell, privileged: false, path: machine[:ansible_config]
        end
      end # ansible

    end   # define
  end     # each

  config.vm.provision :shell,
  :inline => "echo 'appending SSH public key to ~vagrant/.ssh/authorized_keys' && echo '#{rsa_pub}' >> /home/vagrant/.ssh/authorized_keys && chmod 600 /home/vagrant/.ssh/authorized_keys"
  config.ssh.insert_key = false
end	# configure

# End

