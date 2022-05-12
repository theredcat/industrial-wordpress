install:
	composer install --no-interaction
	test -f wp/wp-content/plugins/hello.php && rm wp/wp-content/plugins/hello.php || true
	cp src/wp-config.php wp/
	cp config/nginx.conf wp/

setup:
	./setup.sh

clear:
	git clean -xffd
	docker-compose down -v
