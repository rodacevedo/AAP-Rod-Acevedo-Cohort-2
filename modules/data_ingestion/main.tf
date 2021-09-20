#data ingestion module
# incoming files are stored in a bucket and trigger a lambda function to determine validity
# invalid files are placed another bucket and a mesage is sent to stakeholders with details
# valid files are placed in a third bucket where they will consumed and life-cycled
