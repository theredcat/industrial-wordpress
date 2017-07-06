install:
	composer install --no-interaction
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

acf_export:
	cd wp && ../vendor/bin/wp acf export all
	cd wp && cp -aR $$(../vendor/bin/wp eval "echo get_stylesheet_directory();")"/field-groups/" ../src/acf/

acf_import:
	cd wp && cp -aR ../src/acf/field-groups/ $$(../vendor/bin/wp eval "echo get_stylesheet_directory();")
	cd wp && ../vendor/bin/wp acf clean
	cd wp && ../vendor/bin/wp acf import all

