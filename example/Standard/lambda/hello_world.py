import json


def print_hello(event, context):
    response = {
        "statusCode": 200,
         "headers": {
        'Content-Type': 'text/html',
    },
        "body": "Hello Welcome To the Lambda Api Integration"
        }

    return response