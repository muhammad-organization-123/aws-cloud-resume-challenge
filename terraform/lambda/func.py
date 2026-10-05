import json
import boto3

table = boto3.resource("dynamodb").Table("visitor-counter")


def lambda_handler(event, context):
    result = table.update_item(
        Key={"id": "visitors"},
        UpdateExpression="ADD visits :inc",
        ExpressionAttributeValues={":inc": 1},
        ReturnValues="UPDATED_NEW",
    )
    return {
        "statusCode": 200,
        "body": json.dumps({"count": int(result["Attributes"]["visits"])}),
    }