Effective Kafka
===
This is the repository accompanying [Effective Kafka](https://apachekafkabook.com).

<a href="https://apachekafkabook.com"><img src="https://www.apachekafkabook.com/hero2x.jpeg" width="50%" alt="Effective Kafka cover"/></a>


## Chapter 5

create a topic
```
kafka-topics --bootstrap-server localhost:9092 \
--create --partitions 3 --replication-factor 1 \
--topic getting-started
```

publish record
```
kafka-console-producer \
--broker-list localhost:9092 \
--topic getting-started --property "parse.key=true" \
--property "key.separator=:"
```

```
foo:first message
foo:second message
bar:first message
foo:third message
bar:second message
```

consumer records
- return the records from previous producer
```
kafka-console-consumer \
--bootstrap-server localhost:9092 \
--topic getting-started \
--group cli-consumer \
--from-beginning \
--property "print.key=true" \
--property "key.separator=:"
```

consumer records
- doesn't return the records from previous producer
- because the consumer group has already consumed the records
```
kafka-console-consumer \
--bootstrap-server localhost:9092 \
--topic getting-started \
--group cli-consumer \
--property "print.key=true" \
--property "key.separator=:"
```

list topics
```
kafka-topics \
--bootstrap-server localhost:9092 \
--list \
--exclude-internal
```

describe a topic
```
kafka-topics \
--bootstrap-server localhost:9092 \
--describe \
--topic getting-started
```

delete a topic
```
kafka-topics \
--bootstrap-server localhost:9092 \
--topic getting-started \
--delete
```


truncate partitions
- truncate all records in the log up to a user-specified low-water mark
- the new low-water mark is in the offset attribute
```
cat << EOF > /tmp/offsets.json
{
"partitions": [
{"topic": "getting-started", "partition": 2, "offset": 1}
],
"version": 1
}
EOF
```
- truncate the first record from getting-started:2, leaving records at offeset 1 and newer intact

```
kafka-delete-records \
--bootstrap-server localhost:9092 \
--offset-json-file /tmp/offsets.json
```
- it deletes the records based on the offset

list consumer groups
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--list
```

describe consumer group
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--describe \
--group cli-consumer
```

iterate the consumer groups and describe them
```
sh /mnt/scripts/list-consumer-groups.sh
```

describe all groups
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--describe --all-groups --all-topics
```

include ID of coordinator node
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--describe --all-groups --state
```

### Resetting offsets
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--topic getting-started --group cli-consumer \
--reset-offsets --to-earliest --execute
```
- it would reset the offsets to the earliest so that you can consumer earliest records
delete consumer group

```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--topic getting-started:0,1 --group cli-consumer \
--reset-offsets --to-offset 2 --execute
```
- this reset command is performed on a subset of the topic's partitions.
- it only reset the partitions 0 and 1

```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--topic getting-started:2 --group cli-consumer \
--reset-offsets --to-datetime 2020-01-27T14:35:54.528+11:00 \
--execute
```
- it reset the offsets based on specific datetime

### Deleting offsets
- remove tracking information telling consumers where they left off reading a topic
- remove the committed offeset for consumer groups from kafka's internal storage
- doesn't remove any records
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--topic getting-started --group cli-consumer --delete-offsets
```

### Deleting consumer groups
- remove the consumer group's metadata and committed offesets from kafka interal storage
- Deleting the consumer group is equivalent to deleting offsets for all topics and all partitions
- doesn't remove any records
```
kafka-consumer-groups \
--bootstrap-server localhost:9092 \
--group cli-consumer --delete  
```

### Using Java library
```
# you may change java version from bash_profile
source ~/.bash_profile
brew install gradle@7
cd /opt/git/wilsonchan0709/effectivekafka
```