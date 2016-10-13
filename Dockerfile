# Lightweight Linux distro with an Oracle JDK 8 installation
FROM frolvlad/alpine-oraclejdk8:slim

MAINTAINER Daniel Rhoades <daniel@danielrhoades.com>

# Create a user to run dynamo
RUN adduser -S aws

# Create a dir to hold the database (if a volume hasn't been explicitly mounted)
RUN mkdir /var/dynamodb_store
RUN mkdir /home/aws/dynamodb

WORKDIR /home/aws

# Download the latest dynamo image
ADD http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz /home/aws/dynamodb_local_latest.tar.gz
RUN tar zxf /home/aws/dynamodb_local_latest.tar.gz -C /home/aws/dynamodb

EXPOSE 8000

VOLUME ["/var/dynamodb_store"]

# Run Dynamo
USER aws
CMD ["java", "-Djava.library.path=/home/aws/dynamodb/DynamoDBLocal_lib", "-jar", "/home/aws/dynamodb/DynamoDBLocal.jar", "-dbPath", "/var/dynamodb_store"]