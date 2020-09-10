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
# -Version:		1.37, 10/09/2020
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
    :hostname => "graf1." + "#{DOMAIN}",
    :box => "#{VM}",
    :box_ver => "#{VM_VER}",
    :ram => "#{RAM}",
    :updater         => "./files/scripts/updater_deb.sh",
    :ip => "#{NETWORK}" + "11",
    :ssh_port => "#{SSH}" + "11"
  },
  {
    :hostname => "web1." + "#{DOMAIN}",
    :box => "#{VM}",
    :ram => "#{RAM}",
    :updater         => "./files/scripts/updater_deb.sh",
    :ip => "#{NETWORK}" + "12",
    :ssh_port => "#{SSH}" + "12",
    :source          => "./files",
    :destination     => "/home/vagrant"
  },
  {
    :hostname => "web2." + "#{DOMAIN}",
    :box => "#{VM}",
    :ram => "#{RAM}",
    :updater         => "./files/scripts/updater_deb.sh",
    :ip => "#{NETWORK}" + "13",
    :ssh_port => "#{SSH}" + "13",
    :source          => "./files",
    :destination     => "/home/vagrant"
  },
  {
    :hostname => "prom1." + "#{DOMAIN}",
    :box => "#{VM}",
    :ram => "#{RAM}",
    :ip => "#{NETWORK}" + "14",
    :ssh_port => "#{SSH}" + "14",
    :updater         => "./files/scripts/updater_deb.sh",
    :ansible_install => "./files/scripts/ansible_deb.sh",
    :ansible_config  => "./files/scripts/ansible_config.sh",
    :source          => "./files",
    :destination     => "/home/vagrant"
  }]


# Main:

Vagrant.configure(2) do |config|

  # use vagrant-vbguest plugin to auto-update the boxes VBGuest additions:
  config.vbguest.auto_update = true

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

## File Provisioner to copy our scripts to the vagrant boxes that need them:
      if (!machine[:source].nil?)
        node.vm.provision "file", source: machine[:source], destination: machine[:destination], run: "once"
      end

## Shell Provisioner to update the repos of our vagrant boxes:
      if (!machine[:updater].nil?)
        if File.exist?(machine[:updater])
          node.vm.provision "shell", privileged: true, path: machine[:updater], run: "once"
        end
      end

## Ansible Install & Configure:
      if (!machine[:ansible_install].nil?)
        if File.exist?(machine[:ansible_install])
          node.vm.provision "shell", privileged: true, path: machine[:ansible_install], run: "once"
        end
        if File.exist?(machine[:ansible_config])
          node.vm.provision "shell", path: machine[:ansible_config], run: "once"
#  we could launch ansible playbooks from here to provision software, but we have more control by invoking them from
#  bash scripts:
#         node.vm.provision "shell", inline: "sudo -u vagrant ansible-playbook ~vagrant/playbooks/nginx_config.yaml"
        end
      end # ansible

    end   # define
  end     # each

  # VM boot timeout increase to 8 minutes instead of the default 300, for lazy boxes:
  config.vm.boot_timeout = 480

  # Shell provisioner to create SSH key and set the recommended permissions:
  config.vm.provision "shell", inline: "echo 'appending SSH public key to ~vagrant/.ssh/authorized_keys' && echo '#{rsa_pub}' >> ~vagrant/.ssh/authorized_keys && chmod 700 ~vagrant/.ssh && chmod 600 ~vagrant/.ssh/authorized_keys"
  
  # don't let vagrant insert it's insecure SSH keypair:
  config.ssh.insert_key = false

end	# configure

# End
