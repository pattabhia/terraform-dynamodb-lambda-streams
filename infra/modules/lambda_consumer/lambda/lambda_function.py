import json
from boto3.dynamodb.types import TypeDeserializer

deser = TypeDeserializer()

def _unmarshall(ddb_json):
    return {k: deser.deserialize(v) for k, v in ddb_json.items()}

def lambda_handler(event, context):
    for rec in event.get("Records", []):
        ev = rec.get("eventName")
        keys = _unmarshall(rec["dynamodb"]["Keys"])

        new_img = rec["dynamodb"].get("NewImage")
        old_img = rec["dynamodb"].get("OldImage")
        new_item = _unmarshall(new_img) if new_img else None
        old_item = _unmarshall(old_img) if old_img else None

        print(json.dumps({
            "eventName": ev,
            "keys": keys,
            "old": old_item,
            "new": new_item,
            "approximateCreationTime": rec["dynamodb"].get("ApproximateCreationDateTime")
        }, default=str))

    return {"statusCode": 200}
