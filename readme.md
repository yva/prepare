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
