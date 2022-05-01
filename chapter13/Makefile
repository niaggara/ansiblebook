lint:
	vagrant validate
	ansible-inventory  --graph
	ansible-lint playbooks/build-image.yml playbooks/publish.yml playbooks/deploy.yml
	ansible-later

clean:
	@vagrant halt
	vagrant destroy

provision: lint
	vagrant up

build:
	playbooks/build-image.yml

publish:
	playbooks/publish.yml

deploy:
	playbooks/deploy.yml

all: build publish provision deploy
