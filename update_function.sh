export AWS_PROFILE=YOUR_PROFILE
export AWS_DEFAULT_REGION=us-west-2
LAMBDA=tweet_clone

## UPDATE FUNCTION WITH DEPENDENCY
cd venv/lib/python3.7/site-packages   
zip -r9 ${OLDPWD}/function.zip . 
cd $OLDPWD 
zip -g function.zip post_tweet.py settings.py .env
aws lambda update-function-code --function-name ${tweet_clone} --zip-file fileb://function.zip