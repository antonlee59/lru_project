CPP=gcc
OPTS=-g -Wall
LIBS=-lresolv -ldl -lm

# Modify SRC_DIR as necessary
SRC_DIR=$(HOME)/postgresql-15.0

INCLUDE=-I$(SRC_DIR)/src/include     

freelist-lru.o: freelist-lru.c
	$(CPP) $(OPTS) $(INCLUDE) -c -o freelist-lru.o freelist-lru.c

clean:
	rm -f *.o

lru: copylru pgsql

clock: copyclock pgsql

copylru:
	cp freelist-lru.c $(SRC_DIR)/src/backend/storage/buffer/freelist.c
	cp bufmgr.c $(SRC_DIR)/src/backend/storage/buffer/bufmgr.c

copyclock:
	cp freelist.original.c $(SRC_DIR)/src/backend/storage/buffer/freelist.c
	cp bufmgr.original.c $(SRC_DIR)/src/backend/storage/buffer/bufmgr.c

pgsql:
	cd $(SRC_DIR) && make && make install

