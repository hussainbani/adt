APP=adjustapi
DOCKER_TARGETS=$(addsuffix .docker, $(APPS))
DOCKER_PUSH_TARGETS=$(addsuffix .push, $(APPS))
DOCKER_URL=hussainbani
PYTHONV=python3
TAG := $(shell date +'%Y.%m.%d')

test:
	cd $(APP) && $(PYTHONV) -m pip install -r requirements.txt && $(PYTHONV) -m pytest

lint:
	cd $(APP) && $(PYTHONV) -m pip install -r requirements.txt && flake8 $(APP)/api/ $(APP)/tests/ $(APP)/app.py

bandit:
	cd $(APP) && $(PYTHONV) -m pip install -r requirements.txt && bandit -r .

python_clean:
	find . -name "*.py[co]" -delete
	find . -name ".pytest*" -exec rm -rf {} +
	find . -type d -name "__pycache__" -delete 

image_build:
	$(eval IMAGE_NAME = $(subst -,_,$(APP)))
	docker build -t $(DOCKER_URL)/$(IMAGE_NAME):$(TAG) .

image_push:
	@echo "Enter your Docker credentials:"
	@docker login
	docker push $(DOCKER_URL)/$(IMAGE_NAME):$(TAG)

docker: python_clean image_build image_push
