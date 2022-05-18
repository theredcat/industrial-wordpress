install:
	composer install --no-interaction
	composer install --no-interaction
	wp_dir="$$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["wordpress-install-dir"];')"; \
		test -f "$$wp_dir/wp-content/plugins/hello.php" && rm "$$wp_dir/wp-content/plugins/hello.php" || true; \
		cp src/wp-config.php $$wp_dir; \
		cp config/nginx.conf $$wp_dir;

setup:
	./setup.sh

clear:
	git clean -xffd
	docker-compose down -v
