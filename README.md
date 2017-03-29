Wordpress
====

Install dev env
---------------

You must have docker-compose installed

You may have to change user ID in the `docker-compose.yml` and/or the wordpress url in `config/parameters.yml`

<code>
docker-compose up --build
</code>

Automatic deploy in production/preproduction/ci
-----------------------------------------------
Copy the code to your destination server and run the `make install` command. The command can also be run on a deployment server, which will install the dependancies and then transfer it to the prod/preprod server.

To handle parameters, a mapping of environement variables is defined in the `composer.json` this allow to populate the environement setting on deployments. This will create a `config/parameters.yml` file which will be read at runtime by the `src/wp-config.php` (which is copied in `wp/` directory on deployments).

This line in the composer.json :
```
"database_wp_host": "DATABASE_WP_HOST",
```
mean that you should have a environnement variable `DATABASE_WP_HOST` when running `make install`.

If you're deploying using a home made tool, you should be able to do this:
```
#> export DATABASE_WP_HOST="my.production.database"
#> export DATABASE_WP_PORT="3306"
[... do this for all vars in composer.json...]
#> my_deploy_script.sh
```


Add a plugin/theme
------------------
Go to https://wpackagist.org/ and search for a plugin/theme

Click on the version of the plugin to install

Copy/paste the generated line in `composer.json` in the `require` section



Add a custom plugin/theme
-------------------------
You should put your plugin/theme the `src/` folder and add a copy command in the `install` section of `Makefile` like this:

```
install:
        cp -R src/my-awesome-plugin wp/wp-content/plugins
        cp -R src/my-awesome-theme wp/wp-content/themes
```

Add a configuration in Wordpress via a `define`
-----------------------------------------------
First, go to `config/parameters.yml.dist` (NEVER EVER MODIFY OR COMMIT THE `parameters.yml` file) and add your setting. You can use arrays or map, but for simplivity sake, you should stay with a flat key/value file.

Second, open `composer.json` and create the mapping in the `extra:incenteev-parameters:env-map` section. Usually, you should use for environement variable the same name as your setting in the `parameters.yml.dist`, but in uppercase

Third, go to `src/wp-config.php` and add a line just before `/** Absolute path to the WordPress directory. */`. You line should look like this:

```
define('MY_PLUGIN_SETTING', $config['my_plugin_setting']);
```
Where `my_plugin_setting` is the setting you've added

Finally, run a `make install`, and voilà! You're done

