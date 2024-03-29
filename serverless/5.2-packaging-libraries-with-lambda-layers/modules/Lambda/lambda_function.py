from datetime import datetime
import requests

SITE = "https://www.amazon.com/"  # URL of the site to check, stored in the site environment variable
EXPECTED = "shopping"  # String expected to be on the page, stored in the expected environment variable


def validate(res):
    '''Return False to trigger the canary

    Currently this simply checks whether the EXPECTED string is present.
    However, you could modify this to perform any number of arbitrary
    checks on the contents of SITE.
    '''
    return EXPECTED in res


def lambda_handler(event, context):
    print('Checking {} '.format(SITE))
    try:
        req = requests.get(SITE, headers={'User-Agent': 'AWS Lambda'})
        if not validate(str(req.text)):
            raise Exception('Validation failed')
    except:
        print('Check failed!')
        raise
    else:
        print('Check passed!')
        return "Completed"
    finally:
        print('Check complete at {}'.format(str(datetime.now())))