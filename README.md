# vmware-sdwan-client-container

This Docker file is used to create an unofficial container image of the VMware
SD-WAN Client software, specifically for use with the Client Connector node in the product.

## Before You Build

Before you begin, check the candidate version number of the SD-WAN Client
Software. The container will be built using the candidate version. You can
perform this action directly on the Linux machine hosting the container. The
example below is taken from Ubuntu 20.04.

```shell
curl -s https://packagecloud.io/install/repositories/Ananda/release/script.deb.sh | sudo bash 
sudo apt-get update
sudo apt-cache policy sdwan-client-service 
sdwan-client-service:
  Installed: (none)
  Candidate: 1.25.4
  Version table:
     1.25.4 500
        500 https://packagecloud.io/Ananda/release/ubuntu focal/main amd64 Packages
     1.24.8 500
        500 https://packagecloud.io/Ananda/release/ubuntu focal/main amd64 Packages
```

It is a good idea to tag the image with the version of the SD-WAN client
software it is built with. The remaining build and run commands will demonstrate
this practice using the version (1.25.4) shown above.

## Clone

Clone the repository and change directory to the repository on the local
machine.

```shell
git clone git@gitlab.eng.vmware.com:sebu-tpm-labs/sdwan-client-container.git
cd sdwan-client-container/
```

## Build

Build the image and tag it with the version number discovered in the 'Before You
Build' step.

```shell
sudo docker image build --tag vmware-sdwan-client:1.25.4 .

sudo docker image ls
REPOSITORY            TAG                  IMAGE ID       CREATED          SIZE
vmware-sdwan-client   1.25.4               a09bddcb37f8   27 minutes ago   265MB
```

## Run

The container must run with all the flag options shown below. They are necessary
for setting the correct permissions to build the overlay tunnel interface.

```shell
sudo docker run -itd --sysctl net.ipv6.conf.all.disable_ipv6=0 --privileged --cap-add=NET_ADMIN --device=/dev/net/tun --name cc-1-1.25.4 vmware-sdwan-client:1.25.4

sudo docker container ls
CONTAINER ID   IMAGE                        COMMAND                  CREATED          STATUS          PORTS     NAMES
7f1d9665634e   vmware-sdwan-client:1.25.4   "/usr/bin/supervisord"   26 minutes ago   Up 26 minutes             cc-1-1.25.4
```

## Check SD-WAN Client Service is operational

You can interact directly with the running container by sending sdwan-client-cli
commands (or other bash commands) using the exec function.

```shell
sudo docker container exec -it sdwan-client-test sdwan-client-cli -v
```

## Authenticate the Client Connector to the fabric

This is how you authenticate the Client Connector to the fabric.

```shell
sudo docker container exec -it sdwan-client-test sdwan-client-cli --login {{ SECURITY_TOKEN }} 
```

## Which Interface Do You Use in the Orchestrator?

Please specify the following interface in the SD-WAN Orchestrator for the Client
Connector:

```shell
eth0
```

This is the interface that the client is built with.
