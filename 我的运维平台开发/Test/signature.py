import urllib.parse
import time
import uuid
import base64
import hmac
from hashlib import sha1

def percent_encode(string):
    res = urllib.parse.quote(string.encode('utf8'), '')  # Python 3中str不再具有decode方法，因为它存储的是“未编码”的字符串。decode操作交由byte完成了
    res = res.replace('+', '%20')
    res = res.replace('*', '%2A')
    res = res.replace('%7E', '~')
    return res
a = percent_encode('aaa')
print(a)

def compute_signature(parameters, access_key_secret):
    sortedParameters = sorted(parameters.items(), key=lambda parameters: parameters[0])
    canonicalizedQueryString = ''
    for (k, v) in sortedParameters:
        canonicalizedQueryString += '&' + percent_encode(k) + '=' + percent_encode(v)
    stringToSign = 'GET&%2F&' + percent_encode(canonicalizedQueryString[1:])
    h = hmac.new(access_key_secret.encode() + "&".encode(), stringToSign.encode(), sha1)
    signature = base64.encodebytes(h.digest()).strip()

    #return signature
    return str(signature, 'UTF-8')
timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
parameters = { \
    'Format': 'JSON', \
    'Version': '2014-11-11', \
    'AccessKeyId': 'afafdasfas', \
    'SignatureVersion': '1.0', \
    'SignatureMethod': 'HMAC-SHA1', \
    }
b = compute_signature(parameters, 'afsafasfasf')
print(b)

def make_digest(message, key):
    key = bytes(key, 'UTF-8')
    message = bytes(message, 'UTF-8')

    digester = hmac.new(key, message, sha1)
    # signature1 = digester.hexdigest()
    signature1 = digester.digest()
    # print(signature1)

    # signature2 = base64.urlsafe_b64encode(bytes(signature1, 'UTF-8'))
    signature2 = base64.urlsafe_b64encode(signature1)
    # print(signature2)

    return str(signature2, 'UTF-8')

result = make_digest('message', 'private-key')
print(result)
