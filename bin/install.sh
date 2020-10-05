#!/bin/bash
ver1=$1
ver2=$2
ver3=$3

if [ $ver1 ]; then ENSEMBL_BRANCH="$ver1"; fi
if [ $ver2 ]; then WBPS_BRANCH="$ver2"; fi
if [ $ver3 ]; then REST_VERSION="$ver3"; fi

eval `ssh-agent -s`
ssh-add

## Check out *Ensembl* code (API, web and (web) tools) from GitHub:
for repo in \
    ensembl \
    ensembl-compara \
    ensembl-funcgen \
    ensembl-variation \
    ensembl-metadata \
    ensembl-rest \
    ensembl-io;
do
    if [ ! -d "$repo" ]; then
        echo "Checking out $repo (branch ${ENSEMBL_BRANCH})"
        git clone --branch ${ENSEMBL_BRANCH} https://github.com/Ensembl/${repo}
    else
        echo Already got $repo, attempting to pull...
        cd $repo
        git pull
        git status
        cd ../
    fi

    echo
    echo
done

# Taxonomy
git clone --branch master https://github.com/Ensembl/ensembl-taxonomy.git

## Check out the ParaSite code
for repo in \
    parasite-rest;
do
    if [ ! -d "$repo" ]; then
        echo "Checking out $repo (branch ${WBPS_BRANCH})"
        git clone --branch ${WBPS_BRANCH} https://github.com/EnsemblGenomes/${repo}
    else
        echo Already got $repo, attempting to pull...
        cd $repo
        git pull
        git status
        cd ../
    fi

    echo
    echo
done

## Dir for starman logs and pid file
mkdir logs

## Finally, checkout EBI specific web-server and db-server configuration from our internal EG Git server...
cd parasite-rest

## ParaSite Configuration
cp -rv root/static/* ../ensembl-rest/root/static/
cp -v ./root/favicon.ico ../ensembl-rest/root/favicon.ico
cp -v ./root/wrapper.tt ../ensembl-rest/root/wrapper.tt
cp -v ./root/documentation/index.tt ../ensembl-rest/root/documentation/index.tt
cp -v ./root/documentation/info.tt ../ensembl-rest/root/documentation/info.tt
cp -v ensembl_rest.psgi ../ensembl-rest/ensembl_rest.psgi 

## Remove controller libs we dont want
rm -rfv ../ensembl-rest/lib/EnsEMBL/REST/Controller/VEP.pm
rm -rfv ../ensembl-rest/lib/EnsEMBL/REST/Controller/VariantRecoder.pm
rm -rfv ../ensembl-rest/lib/EnsEMBL/REST/Controller/ga4gh
rm -rfv ../ensembl-rest/lib/EnsEMBL/REST/Model/ga4gh

## Remove some some endpoints we dont want
rm -v ../ensembl-rest/root/documentation/vep.conf
rm -v ../ensembl-rest/root/documentation/compara.conf
rm -v ../ensembl-rest/root/documentation/overlap.conf
rm -v ../ensembl-rest/root/documentation/regulatory.conf
rm -v ../ensembl-rest/root/documentation/taxonomy.conf
rm -v ../ensembl-rest/root/documentation/variation.conf
rm -v ../ensembl-rest/root/documentation/gavariant.conf
rm -v ../ensembl-rest/root/documentation/gavariantset.conf
rm -v ../ensembl-rest/root/documentation/gacallset.conf
rm -v ../ensembl-rest/root/documentation/assembly.conf
rm -v ../ensembl-rest/root/documentation/info.conf
rm -v ../ensembl-rest/root/documentation/lookup.conf
rm -v ../ensembl-rest/root/documentation/map.conf
rm -v ../ensembl-rest/root/documentation/sequence.conf
rm -v ../ensembl-rest/root/documentation/xrefs.conf
rm -v ../ensembl-rest/root/documentation/archive.conf
rm -v ../ensembl-rest/root/documentation/ld.conf
rm -v ../ensembl-rest/root/documentation/phenotypefeatures.conf

#Update Rest version to be Parasite's version
sed -i "/\$VERSION/c our \$VERSION = $REST_VERSION;" ../ensembl-rest/lib/EnsEMBL/REST.pm
