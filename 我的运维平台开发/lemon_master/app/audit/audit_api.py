import pymysql
import datetime


# mysql db
mysql_server = '10.48.192.162'
mysql_username = 'lemon'
mysql_password = 'memory'
mysql_port = 3306
mysql_db = 'Lemon_GO'

audit_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')

def audit_user(audit_type, audit_op, audit_content, audit_time, audit_user):
    try:
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                               charset='utf8')
        curs = conn.cursor()
        curs.execute('''insert into audit (audit_type,audit_op,audit_content, audit_time,audit_user)
    VALUES ('%(audit_type)s', '%(audit_op)s', '%(audit_content)s','%(audit_time)s' , '%(audit_user)s')'''
                     % {'audit_type': audit_type, 'audit_op': audit_op, 'audit_content': audit_content, 'audit_time': audit_time, 'audit_user': audit_user})
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            return 'audit Ok'

    except Exception as e:
        return e
    finally:
        curs.close()
        conn.close()

if __name__ == '__main__':
    audit_user(audit_type='cron', audit_op='add', audit_content='backup-nginx', audit_time=audit_time, audit_user='mgcheng')
