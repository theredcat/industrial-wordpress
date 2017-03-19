clean:
	rm -f config/parameters.yml

clear: clean
	rm -fr wp/ vendor/
	sudo docker-compose rm
