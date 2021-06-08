OS_NAME := $(shell uname -s | tr A-Z a-z)

ifeq ($(OS_NAME), darwin)
	# Need to use `brew install gnu-tar` if running on MacOS
	TAR=gtar
else
	TAR=tar
endif
APPINSPECT=splunk-appinspect

build:
	$(TAR) --transform 's,^\.,splunk-hyperledger-fabric,' --exclude='.git' --exclude='.ve' -cvzf ../splunk-hyperledger-fabric.tgz ./

inspect:
	$(APPINSPECT) inspect ../splunk-hyperledger-fabric.tgz