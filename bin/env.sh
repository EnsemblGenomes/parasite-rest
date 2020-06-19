ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
PORT=8034
export ENSEMBL_REST_ROOT=$ROOT
export ENSEMBL_REST_PORT=$PORT
export ENSEMBL_REST_CONFIG=$ROOT/parasite-rest/parasite_rest.conf
export ENSEMBL_REST_LOG=$ROOT/logs
export PERL5LIB=$ROOT/ensembl-taxonomy/modules:$ROOT/ensembl-metadata/modules:$ROOT/ensembl/modules-io:$ROOT/ensembl/modules:$ROOT/ensembl-compara/modules:$ROOT/ensembl-variation/modules:$ROOT/ensembl-funcgen/modules:$ROOT/parasite-rest/lib:$ROOT/ensembl-rest/lib:$ROOT/ensembl-io/modules:/nfs/public/release/ensweb-software/sharedsw/2019_02_07/linuxbrew/opt/bioperl-169/libexec
