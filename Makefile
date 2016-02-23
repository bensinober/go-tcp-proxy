.PHONY: all test
IMAGE ?= digibib/tcp-proxy

all: reload provision run

reload: halt up

halt:
	vagrant halt || true

up:
	vagrant up --no-provision

provision:
	sleep 3 && vagrant provision

run: delete
	@echo "======= RUNNING TCP-PROXY CONTAINER ======\n"
	@vagrant ssh -c 'sudo docker run -d --name tcp-proxy -p 9999:9999 $(IMAGE)'

stop:
	@echo "======= STOPPING TCP-PROXY CONTAINER ======\n"
	vagrant ssh -c 'sudo docker stop tcp-proxy' || true

delete: stop
	@echo "======= DELETING TCP-PROXY CONTAINER ======\n"
	vagrant ssh -c 'sudo docker rm tcp-proxy' || true

test:
	vagrant ssh -c 'docker stats --no-stream tcp-proxy'

login: # needs EMAIL, PASSWORD, USERNAME
	@ vagrant ssh -c 'docker login --email=$(EMAIL) --username=$(USERNAME) --password=$(PASSWORD)'

TAG = "$(shell git rev-parse HEAD)"

tag:
	vagrant ssh -c 'docker tag -f $(IMAGE) $(IMAGE):$(TAG)'

push: tag
	@echo "======= PUSHING KOHA CONTAINER ======\n"
	vagrant ssh -c 'docker push $(IMAGE):$(TAG)'

docker_cleanup:
	@echo "cleaning up unused containers and images"
	@vagrant ssh -c '/vagrant/docker-cleanup.sh'