import json
import os
import urllib.request

import boto3

ssm = boto3.client("ssm")


def lambda_handler(event, context):
    parameter_name = os.environ["SLACK_WEBHOOK_PARAMETER"]

    response = ssm.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )

    webhook_url = response["Parameter"]["Value"]

    message = event.get("message", "Hello from AWS Lambda!")

    payload = json.dumps({
        "text": message
    }).encode("utf-8")

    request = urllib.request.Request(
        webhook_url,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    with urllib.request.urlopen(request, timeout=10) as result:
        status = result.status

    return {
        "statusCode": status,
        "body": "Message sent to Slack"
    }