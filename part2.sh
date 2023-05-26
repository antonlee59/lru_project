#!/usr/bin/env bash

DBNAME=lru_project
RESULTFILE=part2_result.txt
NUM_CLIENTS=10
SCALE_FACTOR=4
DURATION=360


# check that server is running
if ! pg_ctl status > /dev/null; then
	echo "ERROR: postgres server is not running!"
	exit 1;
fi


# check if database named $DBNAME exists; if not, create it
if ! psql -l | grep -q "$DBNAME"; then
	createdb "${DBNAME}"
fi

# check that number of shared buffer pages is configured to 64MB
if ! psql -c "SHOW shared_buffers;" $DBNAME | grep "64MB"; then
	echo "ERROR: restart server using -B 8192!"
	exit 1;
fi

# create benchmark database relations 
pgbench -i -s ${SCALE_FACTOR} --unlogged-tables  $DBNAME

# show size of shared buffers
psql -c "show shared_buffers;" $DBNAME  >| ${RESULTFILE}

# reset statistics counters 
psql -c "SELECT pg_stat_reset();" $DBNAME

echo >> ${RESULTFILE}
date >> ${RESULTFILE}
echo >> ${RESULTFILE}


# run benchmark  test
pgbench -c ${NUM_CLIENTS} -T ${DURATION} -j ${NUM_CLIENTS} -s ${SCALE_FACTOR} $DBNAME >> ${RESULTFILE}

echo >> ${RESULTFILE}
date >> ${RESULTFILE}
echo >> ${RESULTFILE}


# calculate buffer hit ratio
psql -c "SELECT SUM(heap_blks_read) AS heap_read, SUM(heap_blks_hit)  AS heap_hit, SUM(heap_blks_hit) / (SUM(heap_blks_hit) + SUM(heap_blks_read))  AS hit_ratio FROM pg_statio_user_tables;" $DBNAME >> ${RESULTFILE}

cat ${RESULTFILE}

