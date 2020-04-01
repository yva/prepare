MKFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPT :=
BOX := centos/7

ubuntu: BOX=ubuntu/bionic64
ubuntu: _do

centos: BOX=centos/7
centos: _do

_do:
	YVA_BOX=$(BOX) vagrant up --provision

_stop:
	@echo "###\n### Stopping vm\n###"
	vagrant halt

_rm: _stop
	@echo "###\n### Remove vm\n###"
	vagrant destroy -f
	
ssh:
	@echo "###\n### Openning shell in container\n###"
	vagrant ssh

clean: _stop _rm

all: clean centos