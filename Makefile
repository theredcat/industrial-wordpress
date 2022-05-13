install:
	composer install --no-interaction
	wp_dir="$$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["wordpress-install-dir"];')"; \
		test -f "$$wp_dir/wp-content/plugins/hello.php" && rm "$$wp_dir/wp-content/plugins/hello.php" || true; \
		cp src/wp-config.php $$wp_dir; \
		cp config/nginx.conf $$wp_dir; \
		cd "$$wp_dir/wp-content/plugins/"; \
		test -d advanced-custom-fields-wpcli || git clone https://github.com/hoppinger/advanced-custom-fields-wpcli

setup:
	./setup.sh

clear:
	git clean -xffd
	docker-compose down -v
