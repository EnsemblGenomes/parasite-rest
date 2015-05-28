#!/bin/bash
ver1=$1
ver2=$2
ver3=$3

if [ $ver1 ]; then ENSEMBL_BRANCH="$ver1"; fi
if [ $ver2 ]; then EG_BRANCH="$ver2"; fi
if [ $ver3 ]; then WBPS_BRANCH="$ver3"; fi


## Check out *Ensembl* code (API, web and (web) tools) from GitHub:
for repo in \
    ensembl \
    ensembl-compara \
    ensembl-funcgen \
    ensembl-tools \
    ensembl-variation \
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

## Check out *Ensembl Genomes* code (API, web and (web) tools) from GitHub:
for repo in \
    ensemblgenomes-api \
    eg-rest;
do
    if [ ! -d "$repo" ]; then
        echo "Checking out $repo (branch ${EG_BRANCH})"
        git clone --branch ${EG_BRANCH} https://github.com/EnsemblGenomes/${repo}
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
cp -v ensembl_rest.conf ../ensembl-rest
cp -v ../eg-rest/ensembl_rest.psgi ../ensembl-rest
cp -rv ../eg-rest/root/static/* ../ensembl-rest/root/static/
cp -rv root/static/* ../ensembl-rest/root/static/
cp -v ./root/favicon.ico ../ensembl-rest/root/favicon.ico
cp -v ./root/root/wrapper.tt ../ensembl-rest/root/wrapper.tt

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
rm -v ../eg-rest/root/documentation/variation.conf
rm -v ../eg-rest/root/documentation/vep.conf
rm -v ../eg-rest/root/documentation/compara.conf
rm -v ../eg-rest/root/documentation/info.conf
rm -v ../eg-rest/root/documentation/overlap.conf


