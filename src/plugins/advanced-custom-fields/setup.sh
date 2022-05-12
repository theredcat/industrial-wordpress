wpcli="$1"
wpparameters="$2"
project_root="$3"
here="$(dirname $0)"

cp -aR "$here/field-groups/" $($wpcli eval "echo get_stylesheet_directory();")
$wpcli acf clean
$wpcli acf import all
