from . import audit
from flask import render_template
from flask.ext.login import login_required
import pymysql
from config import Config

# mysql db
mysql_server = Config.mysql_server
mysql_username = Config.mysql_username
mysql_password = Config.mysql_password
mysql_port = 3306
mysql_db = Config.mysql_db


@audit.route('/audit')
@login_required
def audit_list():
    conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                           charset='utf8')
    curs = conn.cursor()
    curs.execute(
        '''select audit_type,audit_op,audit_content, audit_time,audit_user from Audit
WHERE DATE_SUB(CURDATE(), INTERVAL 90 DAY) <= DATE(`audit_time`) ORDER BY audit_time DESC''')
    audit_tuple = curs.fetchall()
    print(audit_tuple)
    return render_template('Audit/Audit.html', audit_tuple=audit_tuple)
