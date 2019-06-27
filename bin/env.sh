#ROOT='/nfs/public/rw/ensembl/websites/parasite/current/restapi'
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
PORT=8034
export ENSEMBL_REST_ROOT=$ROOT
export ENSEMBL_REST_PORT=$PORT
export ENSEMBL_REST_CONFIG=$ROOT/parasite-rest/parasite_rest.conf
export PERL5LIB=$ROOT/ensembl/modules-io:$ROOT/ensembl/modules:$ROOT/ensembl-compara/modules:$ROOT/ensembl-variation/modules:$ROOT/ensembl-funcgen/modules:$ROOT/eg-rest/lib:$ROOT/parasite-rest/lib:$ROOT/ensembl-rest/lib:$ROOT/ensemblgenomes-api/modules:$ROOT/ensembl-io/modules:/home/linuxbrew/.linuxbrew/Cellar/perl/5.28.0/lib/perl5/site_perl/5.28.0:/home/linuxbrew/.linuxbrew/opt/bioperl-169/libexec
