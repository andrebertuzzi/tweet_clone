import os

import settings
import tweepy
from googletrans import Translator
from boto3.dynamodb.conditions import Key
import boto3

auth = tweepy.OAuthHandler(os.getenv('CONSUMER_KEY'),
                           os.getenv('CONSUMER_SECRET'))
auth.set_access_token(os.getenv('ACCESS_TOKEN'),
                      os.getenv('ACCESS_TOKEN_SECRET'))

api = tweepy.API(auth)
translator = Translator()

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('tweets')


def handler(event, context):
    # Get tweet from dynamo
    response = table.scan(FilterExpression=Key('status').eq(0), Limit=100)
    tweet = response['Items'][0]
    print(tweet['text'])
    # Translate to portuguese
    tweet_pt = translator.translate(tweet['text'], dest='pt')
    print(tweet_pt.text)
    # Post
    api.update_status(tweet_pt.text)
    # Update status
    table.update_item(Key={'id': tweet['id']}, UpdateExpression='set #s =:s', ExpressionAttributeValues={
                      ':s': 1}, ExpressionAttributeNames={"#s": "status"}, ReturnValues="UPDATED_NEW")
    return {
        'message': 'Executado com sucesso'
    }


if __name__ == '__main__':
    handler(None, None)
