#!/usr/bin/env bash

DIR=$HOME/lru_project
TEST_DIR=${DIR}/testresults
DBNAME=lru_project

# check that server is running
if ! pg_ctl status > /dev/null; then
	echo "ERROR: postgres server is not running!"
	exit 1;
fi

# if database doesn't exists, create database
if ! psql -l | grep -q "$DBNAME"; then
	echo "Creating database ${DBNAME} ..."
	createdb "${DBNAME}"
fi


# check that number of shared buffer pages is configured to 16 pages
if ! psql -c "SHOW shared_buffers;" $DBNAME | grep -q "128kB" ; then
	echo "ERROR: restart server with 16 buffer pages!"
	exit 1;
fi


# load data into movies relation if necessary
if ! psql -c "SELECT COUNT(*) FROM movies;" $DBNAME | grep "1681"; then
	psql -f ${DIR}/testdata/load-data.sql $DBNAME
fi


# create test_bufmgr extension if necessary
psql -c "CREATE EXTENSION IF NOT EXISTS test_bufmgr;" $DBNAME


# run tests

if [ -d ${TEST_DIR} ]; then
	\rm -f ${TEST_DIR}/*.txt
else
	mkdir -p ${TEST_DIR}
fi

for testno in  {0..9}
do
	resultfile="${DIR}/testresults/result-$testno.txt"
	echo "Running test case ${testno} -> ${resultfile} ..."
	psql -c "SELECT test_bufmgr('movies', $testno);" $DBNAME 2> ${resultfile}
done

