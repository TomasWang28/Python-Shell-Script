#!/usr/bin/env python

import urllib.parse
import urllib.request
import base64
import hmac
from hashlib import sha1
import time
import uuid


class RefreshAliCdn:
    def __init__(self):
        self.cdn_server_address = 'https://cdn.aliyuncs.com'
        self.access_key_id = '4L0n3arqGwoqtjEE'
        self.access_key_secret = '08xqmZm6qjn1TmRu9SiGLglDwJdNpY'

    def percent_encode(self, string):
        res = urllib.parse.quote(string.encode('utf8'), '') # Python 3中str不再具有decode方法，因为它存储的是“未编码”的字符串。decode操作交由byte完成了
        res = res.replace('+', '%20')
        res = res.replace('*', '%2A')
        res = res.replace('%7E', '~')
        return res

    def compute_signature(self, parameters, access_key_secret):
        sortedParameters = sorted(parameters.items(), key=lambda parameters: parameters[0])
        canonicalizedQueryString = ''
        for (k, v) in sortedParameters:
            canonicalizedQueryString += '&' + self.percent_encode(k) + '=' + self.percent_encode(v)
        stringToSign = 'GET&%2F&' + self.percent_encode(canonicalizedQueryString[1:])
        h = hmac.new(access_key_secret.encode() + "&".encode(), stringToSign.encode(), sha1)
        signature = base64.encodebytes(h.digest()).strip()
        return str(signature, 'UTF-8')

    def compose_url(self, user_params):
        timestamp = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        parameters = { \
            'Format': 'JSON', \
            'Version': '2014-11-11', \
            'AccessKeyId': self.access_key_id, \
            'SignatureVersion': '1.0', \
            'SignatureMethod': 'HMAC-SHA1', \
            'SignatureNonce': str(uuid.uuid1()), \
            'TimeStamp': timestamp, \
            }
        for key in user_params.keys():
            parameters[key] = user_params[key]
        signature = self.compute_signature(parameters, self.access_key_secret)
        parameters['Signature'] = signature
        url = self.cdn_server_address + "/?" + urllib.parse.urlencode(parameters)
        print(url)
        return url

    def make_request(self, user_params):
        url = self.compose_url(user_params)
        try:
            res_data = urllib.request.urlopen(url)
            res = res_data.read()
            return res.decode("utf8")
        except:
            return user_params['ObjectPath'] + ' refresh failed!'


if __name__ == '__main__':
    cdn_request = RefreshAliCdn()
    params = {'Action': 'RefreshObjectCaches', 'ObjectPath': 'http://imagecmg.99wuxian.com/mall/', 'ObjectType': 'File'}
    res = cdn_request.make_request(params)
    print(res)

