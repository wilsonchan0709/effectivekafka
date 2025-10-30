#!/bin/bash

# Command to list all consumer groups
list_groups_cmd="kafka-consumer-groups \
--bootstrap-server localhost:9092 --list"

# Execute the command and iterate over each consumer group
for group in $(bash -c "$list_groups_cmd"); do
  echo "Found consumer group: $group"

  # Command to describe the consumer group
  describe_group_cmd="kafka-consumer-groups \
  --bootstrap-server localhost:9092 --describe --group $group"

  # Execute the describe command and print the output
  echo "Details for consumer group $group:"
  bash -c "$describe_group_cmd"

  echo "----------------------------------------"
done
