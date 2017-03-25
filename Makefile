install:
	composer install
	test -f wp/wp-content/plugins/hello.php && rm wp/wp-content/plugins/hello.php || true
	cp src/wp-config.php wp/
	cp config/nginx.conf wp/

setup:
	./setup.sh

clean:
	rm -f config/parameters.yml

clear: clean
	rm -fr wp/ vendor/
	docker-compose rm -f
