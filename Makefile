all:	build


build:
	docker-compose build $(CACHE) alsynth

up:
	(unset DOCKER_HOST ; ALSYNTHCONF=$$PWD/99-alsynth.conf docker-compose up --force-recreate alsynth)

shell:
	(unset DOCKER_HOST ; docker exec -ti -e DISPLAY -e XMMC="`xauth list $$DISPLAY | cut -d' ' -f 2-`" alsynth bash -login; return 0)

gmrun:
	(unset DOCKER_HOST ; docker exec -ti -e DISPLAY -e XMMC="`xauth list $$DISPLAY | cut -d' ' -f 2-`" alsynth bash -login -c gmrun; return 0)


