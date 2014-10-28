
all: build

docker: aufs
	egrep -i "^docker" /etc/group || groupadd docker
	curl https://get.docker.io/gpg | apt-key add -
	echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
	apt-get update
ifdef DOCKER_VERSION
	apt-get install -y lxc-docker-${DOCKER_VERSION}
else
	apt-get install -y lxc-docker
endif
	sleep 2 # give docker a moment i guess

aufs:
	lsmod | grep aufs || modprobe aufs || apt-get install -y linux-image-extra-`uname -r`

clean:
	@$(QUIET) docker ps -a | awk '{ print $$1 }' | grep -v CONTAINER | xargs -r docker kill
	@$(QUIET) docker ps -a | awk '{ print $$1 }' | grep -v CONTAINER | xargs -r docker rm -f
	@$(QUIET) docker images -q | xargs docker rmi -f

build: clean
	@$(QUIET) rm -f ./stack/.scipy
	docker build -t progrium/buildstep .

build-scipy: clean
	@$(QUIET) touch ./stack/.scipy
	docker build -t progrium/buildstep .
