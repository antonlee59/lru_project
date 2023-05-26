# lru_project
Modified PostgreSQL's buffer manager from Clock Replacement Policy to Stack LRU

Main changes:
* Implemented the following functions in freelist-lru.c: 
  * StrategyUpdateAccessedBuffer
  * StrategyShmemSize
  * StrategyGetBuffer
  * StrategyFreeBuffer 
* Some test data to test the implementation against the original implementation by PostgreSQL


*Changes to the original source codes are demarcated with `modified by Anton Lee` to help ease the search*
