# HEAppE - Local Computing

This extension allows you to simulate the behavior of HEAppE middleware without having to connect to a physical HPC cluster. The behavior of the scheduler on the HPC cluster is simulated locally, HEAppE communicates with this virtual machine via SSH, as is the case with a physical cluster.

Simulation of local calculations has limited possibilities, it is not a full-fledged scheduler.

## Features
* Cluster Information
* File Transfer
* Job Management
* Job Reporting
* Management
* User And Limitation Management

## Usage
The virtual machine setup is ready, just pass the configuration (Dockerfile) to Docker and modify your Database seed.

In the example below we use 49005 port for HEAppE-LocalHPC communication, we cannot use port 22.

>For LocalHPC MasterNodeName is important to use 'host.docker.internal', and for DomainName is important to use 'localhost', because of internal Docker container communication.

>Also you must generate or use your RSA key pair (private and public). It is important to store your public key in 'LocalHPC\.ssh\authorized_keys'. You can use command described here: https://linux.die.net/man/1/ssh-copy-id.

1. Store LocalHPC (Extended cluster setup for LocalComputing) to your PC
2. Extend HEAppE docker-compose configuration (example below)
```txt
    localhpc:
    container_name: localhpc
    build:
      context: .
      dockerfile: Dockerfile
    ports:
        - "49005:22"
```
3. Modify HEAppE seed
4. Modify appsettings.json file with path to scripts
5. Start HEAppE