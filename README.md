Effective Kafka
===
This is the repository accompanying [Effective Kafka](https://apachekafkabook.com).

<a href="https://apachekafkabook.com"><img src="https://www.apachekafkabook.com/hero2x.jpeg" width="50%" alt="Effective Kafka cover"/></a>


## chapter 5

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

Resetting offsets

delete consumer group
