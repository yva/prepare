# Yva install with ansible

## Prepare

```bash
yum install -y ansible
git clone https://github.com/yva/prepare
# prepare yva.ini & variables file 
nano yva.ini
mkdir group_vars
nano group_vars/all
```

**group_vars/all**

```ini
yva: true
INIT_PLATFORM_ROOT: /srv/data
PLATFORM_USER: yva
YVA_SECURE_PLAIN: [required, generate it https://www.lastpass.com/password-generator]
INIT_DOCKER_USER: [required, Yva provided]
INIT_DOCKER_PASS: [required, Yva provided]
```

Install scenarios vary by different yva.ini (ansible inventory file)

### standalone server

**yva.ini** for localhost

```ini
127.0.0.1 YVA_HOSTROLE=standalone ansible_connection=local
```

**yva.ini** for remote standalone

```ini
host0.internal.wlan YVA_HOSTROLE=standalone
```

## Installation

```bash
ansible-playbook all.yml -i yva.ini
```

## Manual install

In case you don't set YVA_HOSTROLE , it will be pre-installed. Ater that its possible to install yva manually host by host

```bash
# on unique main host
$PLATFORM_ROOT/install.sh --hostrole mngr
# on storage host
$PLATFORM_ROOT/install.sh --hostrole storage
# on processing hosts
$PLATFORM_ROOT/install.sh --hostrole application
# on first standalone server
$PLATFORM_ROOT/install.sh --hostrole stanadlone
```

## Process configuration available
### Scenarious avalilable by setup variables
  ```bash
    # example, how to install cuda docker environment
    ansible-playbook all.yml -i yva.ini --extra-vars cuda=true
  ```

  * *no_common=true* - don't install common packages
  * *yva* - install yva platform
  * *cuda* - install cuda docker environment
  * *ml* - install ml engeneer environment

### Install options by tags 
  ```bash
    # example, how to install cuda docker environment
    ansible-playbook all.yml -i yva.ini --extra-vars yva=true --skip-tags=install-docker
  ```

  * *install-docker* tag for docker install procedure
  * *install-consul* install consul from internet
  * 
### Install options by variables

  * *INSTALL_CONSUL_URL*:  URL 4 consul download, default is https://releases.hashicorp.com/consul/1.0.7/consul_1.0.7_linux_amd64.zip
  * *PLATFORM_CONSUL_CLUSTER_IFS*: interface which consul use for internal cluster communication (first available interface by default)
  * *PLATFORM_CONSUL_AGENT_IFS*: interface which consul use for on host communication (dummy by default)
  * *PLATFORM_SERVICE_BIND_IFS*: interface which our internal services use for communications ( usually === *PLATFORM_CONSUL_CLUSTER_IFS*)
  * *PLATFORM_SERVICE_PUBLIC_IFS*  interface which is binded only by front-end service, its used by end users for using the platform

## Debug scenarios

Create *src/yva/group_vars/all*, ther  *.gitignore*  already

**src/yva/group_vars/all**

```ini
YVA_HOSTROLE: standalone
YVA_SECURE_PLAIN: qwerty
INIT_PLATFORM_ROOT: /srv/data
PLATFORM_USER: yva
INIT_DOCKER_USER: [Use_dev]
INIT_DOCKER_PASS: [Use_dev]
INIT_DOCKER_INSECURE_REGISTERS: 10.0.0.1:1025
INIT_PLATFORM_RELEASE_URL: add yor path
INIT_PLATFORM_KV_OVERLOAD2:
  kv:
    PLATFORM_DOCKER_CR: [Use_dev]
```

### Check

```bash
# centos
make centos

# ubuntu
make ubuntu

# if you want to change os
make clean
make centos
```
