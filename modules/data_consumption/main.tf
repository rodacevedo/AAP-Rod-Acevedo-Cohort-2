#data consumption module
# This is the application for workers to interface and consume from the data lake. It is 
# comprised by a containerized application running in Fargate that has the appropriate access to
# the data lake and to the operational data in a Dynamo DB service
#
# Note: Not part of the POC