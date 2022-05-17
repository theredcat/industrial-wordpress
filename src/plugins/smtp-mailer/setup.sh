wpcli="$1"
wpparameters="$2"
project_root="$3"

mail_sender_email=$(php -r 'echo yaml_parse_file("'$wpparameters'")["parameters"]["docker_wordpress_email"];')
mail_sender_name=$(php -r 'echo yaml_parse_file("'$wpparameters'")["parameters"]["docker_wordpress_title"];')


echo "Setup smtp-mailer host to use maildev container"
$wpcli option update smtp_mailer_options '{"smtp_host":"maildev","smtp_auth":"false","smtp_username":"","smtp_password":"","type_of_encryption":"none","smtp_port":"","from_email":"'"$mail_sender_email"'","from_name":"'"$mail_sender_name"'","disable_ssl_verification":""}' --format=json
