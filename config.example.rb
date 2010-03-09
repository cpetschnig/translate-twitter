# Configuration file for translate-twitter
# http://github.com/cpetschnig/translate-twitter


#  R E A D
#  =======

# translate the tweets from this account:
TWITTER_MATZ_USERNAME = 'noble_foreigner'
TWITTER_MATZ_USER_ID = '48014477'

# save resources by storing the id of the latest tweet
TIMESTAMP_FILENAME = File.join(File.dirname(__FILE__), "latest_tweet.#{TWITTER_MATZ_USERNAME}")



#  T R A N S L A T E
#  =================

# translation via http://www.microsofttranslator.com/
MS_TRANSLATE_APP_ID = 'my_app_id_for_microsoft_translator'

LANG_SOURCE = 'ja'
LANG_TARGET = 'en'

# Microsoft translator SOAP API
MS_TRANSLATE_SOAP_ACTION = "http://api.microsofttranslator.com/v1/soap.svc/LanguageService/Translate"
MS_TRANSLATE_SOAP_URL = "http://api.microsofttranslator.com/v1/soap.svc"
MS_TRANSLATE_SOAP_NS = "http://api.microsofttranslator.com/v1/soap.svc"

MS_TRANSLATE_SOAP_BODY = %{<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<soapenv:Body>
<m:Translate xmlns:m="http://api.microsofttranslator.com/v1/soap.svc">
<m:appId>#{MS_TRANSLATE_APP_ID}</m:appId>
<m:text>{{TEXT}}</m:text>
<m:from>#{LANG_SOURCE}</m:from>
<m:to>#{LANG_TARGET}</m:to>
</m:Translate>
</soapenv:Body>
</soapenv:Envelope>}




#  P U B L I S H
#  =============

# publish to this twitter account
TWITTER_TARGET_USER = 'twitter_username'
TWITTER_TARGET_PASSWD = 'twitter_password'




# APPLICATION STUFF

LOG_FILE = File.join(File.expand_path(File.dirname(__FILE__)), 'log', "#{Time.new.strftime('%Y-%m-%d')}.log")

