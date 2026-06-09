# REDIS
# All commands you need to know

## Some general commands 
### GET key
- Retrieves the string value stored at the key, returns nil if the key does not exist
- Example: `GET total_students`

### INCR key
- Atomically increments the value of the key by 1
- Example: `INCR total_students`

### DECR key
- Same as increment, but reversed
- Example: `DECR total_students`

### INCRBY / DECRBY key
- Increments / decrements by a specific value
- Example: `INCRBY student:1001:credits 6` / `DECRBY student:1001:credits 6`

### MGET key1, key2, key3... / MSET key1, key2, key3...
- Reads/ writes multiple string keys at the same time in a single round trip
- Example: `MSET total_students 5 total_courses 4 platform "lms"` or `MGET total_students total_courses`

### SETEX key seconds value
- Sets a key to a string value and attaches TTL countdown in seconds in an atomic way
- Example: `SETEX token:auth:1001 60 "session_secret_xyz"`

## Hashes (structured objects)
- Hashes are maps of fields and values, great for representing real world objects like user profiles, student records, etc.

### HSET key field value
- Sets the value of one or more fields within a hash, creates the hash if it does not exist
- Example: `HSET student:1003 name "alice" age 21 email "alice@example.com"`

### HGET key field
- Retrieves the value associated with a specific field inside of a hash
- Example: `HGET student:1003 age`

### HGETALL key 
- Retrieves all fields and values stored within a hash
- Example: `HGETALL student:1003`

### HEXISTS key fields
- Verifies if a specific field exists within a hash
- Example: `HEXISTS student:1003 graduation_date`

### HKEYS / HVALS
- Returns only the property keys / values
- Example: `HKEYS student:1003` or `HVALS student:1003`

### HDEL key field 1 (this is unlikely to happen but you never know)
- Deletes one or more fields from a hash
- Example: `HDEL student:1003 status`

## LISTS
- Ordered chains of strings, linked using a doubly linked list layout. You would use a list when you are dealing with something that has an order (like waiting in line, head is most urgent, tail is least urgent)

### LPUSH key value
- Pushes a value to the head of the list
- Example: `LPUSH user:1001:actions "login"`

### RPUSH key value
- Pushes a value to the tail of the list
- example: `LPUSH user:1001:actions "logout"`

### LRANGE key start stop
- Fetches a slice of elements using indexes (0 -1 if you want everything, otherwise 0 x, x being the index you want to stop at)
- Example: `LRANGE student:1001:activity 0 -1` or `LRANGE student:1001:activity 0 4`

### LTRIM key start stop
- Trims an existing list down so it contains a specific slice of index ranges and discards everything that falls outside of the boundaries
- Example: `LTRIM user:101:actions 0 r`

### LPOP key / RPOP key 
- Extracts the first / last element of the list. So head and tail elements. 
- Example: `LPOP job:queue` or `RPOP user:name`

### LLEN key
- Returns the total index size or length count of a list
- Example: `LLEN student:1002:activity`

## SETS (unique, unordered, no duplicates)
- Great for adding a lot of data for one table, like students to a course, or courses to a student, many to many relationship in a nutshell. 

### SADD key member 
- Adds unique items into a specified set
- Examples: `SADD course:CS101:students 1001 1002 1003`

### SMEMBERS key
- To return a list of all items in a set
- Example: `SMEMBERS course:CS101:students`

### SISMEMBERS key
- Evaluates if an element is in a set
- Example: `SISMEMBERS course:CS101:students 1004`

### SINTER key1 key2 ...
- Evalutes and returns an intersection across multiple different sets
- Example: `SINTER course:CS101:students course:CS102:students`

### SUNION key1 key2 ...
- Evalutes and returns a union across multiple different sets
- Example: `SUNION course:CS101:students course:CS102:students`

### SDIFF key1 key2 ...
- Evalutes and returns a difference subtraction across multiple different sets
- Example: `SDIFF course:CS101:students course:CS102:students`

### SREM key member
- Deletes one or more specific tracked items from a set
- Example: `SREM course:CS101:students 1002`

## SORTED SETS (ranked leaderboards)
- Yeah. Self explanatory. Only use this when you are tallying scores. 

### ZADD key score member 
- Inserts or updates members with scores into a sorted set
- Example: `ZADD course:CS101:grades 88 1001 90 1002 50 1003`

### ZRANGE key start stop WITHSCORES
- Returns a slice of elements from a sorted set, in order of lowest to highest
- Examples: `ZRANGE course:CS101:grades 0 -1 WITHSCORES`

### ZREVRANGE key start stop WITHSCORES
- Returns a slice of elements from a sorted set, in order of highest to lowest
- Examples: `ZREVRANGE course:CS101:grades 0 -1 WITHSCORES`

### ZRANGEBYSCORE key min max WITHSCORES / ZRANGE .. BYSCORE WITHSCORE
- Filters members based on numerical boundaries, uses +inf and -inf
- Example: `ZRANGEBYSCORE course:CS101:grades 90 +inf WITHSCORE` or `ZRANGE course:CS101:grades 75 +inf BYSCORE WITHSCORE` 

### ZCOUNT / ZCARD min max
- Returns the total count integer of elements whose score attributes reside within the min and max values
- Example: `ZCOUNT course:CS101:grades 60 100`

### ZSCORE key member
- Direct lookup query, exposes exact numerical value for a single item
- Example: `ZSCORE course:CS101:grades 1003`

### ZINCRBY / ZDECRBY key increment member
- Increments a score, or decrements depends what you want
- Example: `ZINCRBY course:CS101:grades 5 1001`

## PUB / SUB 
- For broadcasting structural event payloads onto named channels. Like when you subscribe to a youtube channel and you get notifications. 

### SUBSCRIBE channel 
- Subscribe to a channel, duh
- Example: `SUBSCRIBE page_events university:notifications`

### PUBLISH channel message
- A notification
- Example: `PUBLISH page_events "page 501 received a like"`

## ATOMIC TRANSACTION 
- All or nothing. 

### MULTI / EXEC
- Atomic transaction wrapper. Commands are queued, and executed back to back when exec is triggered. 
- Example: `EXEC SADD student:1005:courses CS102 SADD course:CS102:students 1005 EXEC`

### TTL
- Time to live, exposes the lifetime remaining for a key in seconds
- Example: `TTL session:1001`

### EXISTS key
- Makes sure the key exists
- Example `EXISTS session:1001`

### TYPE key
- Returns the data type of a key
- Example: `TYPE session:1001`

### DEL key
- Drops the key out of the memory
- Example: `DEL session:1001`

### FLUSHALL 
- Comletely flushes everyting out of the memory
- Example: `FLUSHALL`