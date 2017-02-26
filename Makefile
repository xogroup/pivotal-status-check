build:
	docker build -t pivotal-status-check .
tag:
	docker tag pivotal-status-check justneph/pivotal-status-check:latest
test: build
	docker run pivotal-status-check:latest rspec
push:
	docker push justneph/pivotal-status-check
release: build tag push
