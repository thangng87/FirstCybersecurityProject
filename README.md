## Automated ELK Stack Deployment

The purpose of this project is:
- Configure an ELK stack server in order to setup a cloud monitoring system using Microsoft Azure Platform
- Deploy Virtual Machines, Docker containers using Ansible. 
- Design network topology and setup network security rules, load balancer for the ELK stack server


## Network Diagram

![Network Diagram](/Images/Network%20Diagram.jpg) 

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the yaml file may be used to install only certain pieces of it, such as Filebeat.

  - [Install-elk](/Ansible/Install-elk.yml)
  - [filebeat-config](/Ansible/filebeat-config.yml)
  - [filebeat-playbook](/Ansible/filebeat-playbook.yml)
  - [metricbeat-config](/Ansible/metricbeat-config.yml)
  - [metricbeat-playbook](/Ansible/metricbeat-playbook.yml)
  - [Dvwa-Install](/Ansible/pentest.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web Application.

Load balancing ensures that the application will be highly _available_, in addition to restricting _traffic_ to the network.
- What aspect of security do load balancers protect? 
  - Availability, Web Security and Traffic
- What is the advantage of a jump box?
  - Automation config, Security, Access Control
Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the log files and system resources.
- What does Filebeat watch for?
  - Filebeat watch for system logs and forward to the ELK stack server
- What does Metricbeat record?
  - Metricbeat records the usage of computer resources eg: CPU, RAM..

The configuration details of each machine may be found below.


| Name     | Function   | IP Address | Operating System |
|----------|----------  |------------|------------------|
| Jump Box | Gateway    | 10.1.0.4   | Ubuntu           |
| DVWA-VM1 | Client     | 10.1.0.5   | Ubuntu           |
| DVWA-VM2 | Client     | 10.1.0.6   | Ubuntu           |
| DVWA-VM3 | Client     | 10.1.0.8   | Ubuntu           |
| ELK-Stack|Log Monitor | 10.0.0.4   | Unbuntu          |


### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the _Jump Box_ machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- Whitelisted IP addresses: is My Personal Public Ip Address

Machines within the network can only be accessed by _the ansible container inside Jump Box VM. The IP address of Jump Box Machine is 10.1.0.4_.
- Which machine did you allow to access your ELK VM? What was its IP address?
The ELK VM can be accessed through SSH and only Jump Box VM is allowed to access ELK VM. Jump Box's IP address is 10.1.0.4

A summary of the access policies in place can be found in the table below.

| Name     | Publicly Accessible | Allowed IP Addresses                           |
|----------|---------------------|------------------------------------------------|
| Jump Box | Yes                 | My Public Ip                                   |
| DVWA-VM1 | No                  |  10.1.0.4                                      |
| DVWA-VM2 | No                  |  10.1.0.4                                      |
| DVWA-VM3 | No                  |  10.1.0.4                                      |
| ELK-Stack| No                  |  10.1.0.4(SSH), My Public IP (HTTP)            |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
- _It reduces the chance of error when config manually and it also saving time of repeating steps to config multi machines._

The playbook implements the following tasks:
-  In 3-5 bullets, explain the steps of the ELK installation play. E.g., install Docker; download image; etc._
  - Install Docker
    ```bash
      - name: Config ELK with Docker
        hosts: elk
        become: true
        remote_user: ansible
        tasks:
       - name: docker.io
        apt:
          update_cache: yes
          force_apt_get: yes
          name: docker.io
         state: present
    ```
  - Install Python
    ```yaml
        - name: Install pip3
          apt:
          force_apt_get: yes
         name: python3-pip
          state: present
    ```
  - Install apt module (docker python module)
    ```
        - name: Install Docker python module
        pip:
        name: docker
        state: present
    ```
  - Change the size of memory 
    ```- name: change vmap
        command: sysctl -w vm.max_map_count=262144

    ```
  - Use system control to set the memory size everytime system restart
    ```
      - ansible.posix.sysctl:
       name: vm.max_map_count
       value: '262144'
       state: present
       reload: yes
    ```
  - Download ELK container
    ```
         - name: download and launch a docker elk container
        docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
    ```
  - List the port that ELK running and enable ELK service
    ```
        published_ports:
         - 5601:5601
         - 9200:9200
         - 5044:5044
        - name: Enable docker service
         systemd:
          name: docker
         enabled: yes
    ```
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![ELK Screenshot](/Images/ansible.JPG)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- DVWA-VM1 (web1):10.1.0.5 
- DVWA-VM2 (web2):10.1.0.6
- DVWA-VM3 (web3):10.1.0.8

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc.
  - Filebeat collect data from log file then forward to ELK stack server. Filebeat can show the log of SSH attemps or log-in data. Hence we can see if someone try to bruce force log in to our server.
  - Metricbeat collect data on the usage of components(CPU, RAM) in machines in our webservers. By looking at the data from Metricbeat, we can see which machine is using a lot of resources and it could be potential of malware.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the _ansible playbook yaml file_ file to _/etc/ansible/_ directory on your control node.
- Update the _host_ file to include the machines inside a specific group that we want to install the playbook on
- Run the playbook, and navigate to _targeted machines(DVWA-VM1 or ELK server)_ to check that the installation worked as expected.

 Answer the following questions
- Which file is the playbook? Where do you copy it?
  - YAML(Yet Another Markup Language) files are playbook file. We copy playbook files to /etc/ansible/ directory on ansible node 
- Which file do you update to make Ansible run the playbook on a specific machine? We updated hosts file from /etc/ansible/ 
- How do I specify which machine to install the ELK server on versus which to install Filebeat on?
  - There are different groups inside hosts file for different purpose (eg: webservers or ELK). In order to specific which machine to install ELK server on, we need to specify the group that machine belong to in the config playbook file(elk-config.yml). To install Filebeat on specific machine, we also have to specify the group that machine belong to in the config playbook file (filebeat-config.yml)
- Which URL do you navigate to in order to check that the ELK server is running?
  - http://20.55.233.102:5601/app/kibana
- **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc.
  - curl https://github.com/thangng87/FirstCybersecurityProject/blob/main/Ansible/Install-elk.yml >Install-elk.yml
  - nano /etc/ansible/hosts
  - nano /etc/ansible/ansible.cfg
  - ansible-playbook Install-elk.yml
