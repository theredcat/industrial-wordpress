wpcli="$1"
wpparameters="$2"
project_root="$3"

echo "Indexing data for the first time in ElasticPress"
$wpcli elasticpress index --setup
