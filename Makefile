MKFILE_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
OPT :=

ubuntu: export YVA_BOX=ubuntu/bionic64
ubuntu: _do

centos: export YVA_BOX=centos/7
centos: _do

_do:
	vagrant up --provision

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

all: clean _provisoin local