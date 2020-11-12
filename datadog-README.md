# datadog setup
DevOps#1 project - Carlos Ijalba 2020.

-Description:  

Datadog monitoring of the DevOps#1 infra:

       1.- web1, with nginx
       2.- web2, with apache2
       3.- prom1, with prometheus and the ansible control node
       4.- graf1, with grafana

-Intructions: 

  The passwords are kept in .sec files, which are ignored by git (customized on .gitignore file) and therefore not kept in the repository.
  In order for this project to work, you will have to create this files with your secret details (user/pass, API keys, etc).

  This files are:

	files/secrets/datadog_api.sec		# contains datadot API KEY, used by config_datadog.sh

  In order to deploy datadog on this LAB, perform the following instructions:

	1.- create a datadog 15-day trial by registering on the web:

		https://www.datadoghq.com/ - FREE TRIAL

	    Once registered with an email account, you will get a datadog API KEY (copy it to your clipboard).


	2.- log into datadog and go into Infrastructure > Host map
	
		https://app.datadoghq.com/infrastructure/map


	3.- go to vagrant/secrets/ and:

		/home/vagrant>$ vi datadog_api.sec

	    type the following:

		---
		# This is a secrets file (.sec, git ignored) to hold the datadog API Key.
		datadog_api_key: 25c6081e8bbabbabbbabbxxxxxxeeeeee

	    save the file and quit ( <ESC> :wq <enter> )


	4.- log into prom1 (from vagrant main folder):

	  4.1.- load ssh shortcuts:

		/home/vagrant>$ source access.sh

		O-> Proj. #01 Ver 1.02, Loading vagrant SSH vars...

		alias graf1='ssh vagrant@localhost -p 2211'
		alias prom1='ssh vagrant@localhost -p 2214'
		alias web1='ssh vagrant@localhost -p 2212'
		alias web2='ssh vagrant@localhost -p 2213'

		o-> prometheus port: 9090
		o-> grafana port:    3000
		
		/home/vagrant>$ prom1
		Linux prom1 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64

		This system is built by the Bento project by Chef Software
		More information can be found at https://github.com/chef/bento

		The programs included with the Debian GNU/Linux system are free software;
		the exact distribution terms for each program are described in the
		individual files in /usr/share/doc/*/copyright.

		Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
		permitted by applicable law.
		Last login: Thu Nov 12 08:53:33 2020 from 10.0.2.2

	  4.2.- run script to install ansible datadog role:

	        vagrant@prom1:~$ ./scripts/datadog_install.sh
		- downloading role 'datadog', owned by datadog
		- downloading role from https://github.com/DataDog/ansible-datadog/archive/4.5.0.tar.gz
		- extracting datadog.datadog to /home/vagrant/.ansible/roles/datadog.datadog
		- datadog.datadog (4.5.0) was installed successfully

	  4.3.- run ansible datadog playbook:

		vagrant@prom1:~$ ansible-playbook ./playbooks/datadog_install.yaml

		PLAY [all] ***********************************************************************************************

		TASK [Gathering Facts] ***********************************************************************************
		ok: [web2.local]
		ok: [web1.local]
		ok: [graf1.local]
		ok: [prom1.local]

		TASK [datadog.datadog : Check if OS is supported] ********************************************************
		included: .ansible/roles/datadog.datadog/tasks/os-check.yml for prom1.local, web1.local, web2.local, graf1.local

		TASK [datadog.datadog : Fail if OS is not supported] *****************************************************
		skipping: [prom1.local]
		skipping: [web1.local]
		skipping: [web2.local]
		skipping: [graf1.local]
		...

	5.- wait around 5 minutes and look at your datadog Host map, you will see the 4 hosts being monitored by datadog.

	6.- now you have your 4 hosts monitored by datadog and can play with it or compare it against prometheus/grafana.

  Once the 15-day period has expired, you can convert to a free plan and carry on using the limited datadog account forever,
  limited to 5 hosts, no monitors and 1 day of metrics storage.


-Author:  Carlos Ijalba. Project Started in 2020.
#
