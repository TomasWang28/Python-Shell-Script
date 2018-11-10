import pymysql

# mysql db
mysql_server = '10.48.192.162'
mysql_username = 'lemon'
mysql_password = 'memory'
mysql_port = 3306
mysql_db = 'Lemon_GO'

user_id = 13
user_password = 'memory'

conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                       db=mysql_db, charset='utf8')

# with conn.cursor() as curs:
#     try:
#         curs.execute(
#             "update users set user_password = '%(user_password)s' where id = '%(user_id)s'" % {
#                 'user_password': user_password, 'user_id': user_id})
#     except Exception as e:
#         print('aaaaaaaaaaaaaaaaaaaaa')
#         print(e)

try:
    curs = conn.cursor()
    curs.execute(
        "update users set user_password = '%(user_password)s' where id = '%(user_id)s'" % {
            'user_password': user_password, 'user_id': user_id})
    print('bbbbbbbbbbbbbbbbbbbbbbbbb')
except Exception as e:
    # data = curs.fetchall()
    print(e)
    print('aaaaaaaaaaaaaaaaaaaaaaaaaa')

