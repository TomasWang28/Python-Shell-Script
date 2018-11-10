from . import cron 
from flask import render_template, request, redirect,session
from flask.ext.login import login_required
import pymysql
import datetime
from config import Config
import json
import subprocess
from ..audit.audit_api import audit_user


# mysql db
mysql_server = Config.mysql_server
mysql_username = Config.mysql_username
mysql_password = Config.mysql_password
mysql_port = 3306
mysql_db = Config.mysql_db


# cron view
@cron.route('/cron')
@login_required
def cron_list():
    try:
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                               charset='utf8')
        curs = conn.cursor()
        curs.execute(
            'select cron_id, cron_name, cron_command, cron_schedule, cron_owner, cron_server, cron_user  from cron')
        cron_tuple = curs.fetchall()
        cron_server_list = []

        for cron_server in cron_tuple:
            cron_server_list.append(cron_server[5])

        return render_template("cron/Cron.html", cron_tuple=cron_tuple, cron_server_list=list(set(cron_server_list)))
    except Exception as e:
        return json.dumps({'status': str(e)})
    finally:
        curs.close()
        conn.close()


@cron.route('/addCron', methods=['POST'])
@login_required
def addCron():
    try:
        cron_name = request.form['add_cron_name']
        cron_command = request.form['add_cron_command']
        cron_schedule = request.form['add_cron_minute'] + ' ' + request.form['add_cron_hour'] + ' ' + request.form[
            'add_cron_day'] + ' ' + request.form['add_cron_month'] + ' ' + request.form['add_cron_week']
        cron_owner = request.form['add_cron_owner']
        cron_user = request.form['add_cron_user']
        cron_server = request.form['add_cron_server']
        created_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')

        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()
        curs.execute('''insert into cron (cron_name, cron_command, cron_schedule,cron_owner, cron_user, cron_server,created_time)
                        VALUES( '%(cron_name)s', '%(cron_command)s', '%(cron_schedule)s', '%(cron_owner)s', '%(cron_user)s',
                        '%(cron_server)s','%(created_time)s')''' % {
            'cron_name': cron_name, 'cron_command': cron_command, 'cron_schedule': cron_schedule,
            'cron_owner': cron_owner, 'cron_user': cron_user, 'cron_server': cron_server, 'created_time': created_time})
        data = curs.fetchall()
        print(data)

        if len(data) is 0:
            conn.commit()
            audit_user(audit_type='cron', audit_op='add', audit_content=cron_name, audit_time=created_time, audit_user=session.get('username'))
            return redirect('/cron')
        else:
            return render_template('Errors/error.html', error='An error occurred!')

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))
    finally:
        curs.close()
        conn.close()

@cron.route('/deleteCron', methods=['POST'])
def deleteCron():
    try:
        cron_id = request.form['cron_id']
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()
        curs.execute("delete from cron where cron_id='%s'" % (cron_id))
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            audit_user(audit_type='cron', audit_op='delete', audit_time=datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S'), audit_user=session.get('username'))
            return json.dumps({'status': 'OK'})
        else:
            return json.dumps({'status': 'An Error occured'})

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))
    finally:
        curs.close()
        conn.close()


@cron.route('/get_cron_byid',methods=['POST'])
def get_cron_byid():
    try:
        cron_id = request.form['cron_id']
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                               charset='utf8')
        curs = conn.cursor()

        curs.execute("select cron_id,cron_name,cron_command,cron_schedule,cron_owner,cron_server,cron_user from cron where cron_id='%s'" %(cron_id))

        cron_info_tuple = curs.fetchall()
        cron_info_list = []
        cron_info_list.append({
                    'cron_id': cron_info_tuple[0][0],
                    'cron_name': cron_info_tuple[0][1],
                    'cron_command': cron_info_tuple[0][2],
                    'cron_schedule': cron_info_tuple[0][3].split(' '),
                    'cron_owner': cron_info_tuple[0][4],
                    'cron_server': cron_info_tuple[0][5],
                    'cron_user': cron_info_tuple[0][6]
                    })
        return json.dumps(cron_info_list)
    except Exception as e:
        return json.dumps({'status': str(e)})
    finally:
        curs.close()
        conn.close()


@cron.route('/updateCron', methods=['POST'])
def updateCron():
    try:
        cron_id = request.form['cron_id']
        cron_name = request.form['cron_name']
        cron_command = request.form['cron_command']
        cron_schedule = request.form['cron_minute'] + ' ' + request.form['cron_hour'] + ' ' + request.form[
            'cron_day'] + ' ' + request.form['cron_month'] + ' ' + request.form['cron_week']
        cron_owner = request.form['cron_owner']
        cron_user = request.form['cron_user']

        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()
        curs.execute(
            "update cron set cron_name = '%(cron_name)s', cron_command = '%(cron_command)s', "
            "cron_schedule = '%(cron_schedule)s', cron_owner = '%(cron_owner)s', cron_user = '%(cron_user)s'"
            "where cron_id = '%(cron_id)s'" % {'cron_name': cron_name, 'cron_command': cron_command,
                                               'cron_schedule': cron_schedule, 'cron_owner': cron_owner, 'cron_user': cron_user, 'cron_id': cron_id})
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            return json.dumps({'status': 'OK'})
        else:
            return json.dumps({'status': 'ERROR'})

    except Exception as e:
        return json.dumps({'status': str(e)})
    finally:
        curs.close()
        conn.close()


@cron.route('/cron/generateCron', methods=['POST'])
def generateCron():
    try:
        cron_server = request.form['g_Cron_server']
        cron_user = request.form['cron_user']
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                               charset='utf8')
        curs = conn.cursor()
        curs.execute("select cron_name, cron_command, cron_schedule, cron_user from cron where cron_server='%(cron_server)s'"
                     "and cron_user='%(cron_user)s'"
                     % {'cron_server': cron_server, 'cron_user': cron_user})
        server_cron_tuple = curs.fetchall()

        cron_list = []
        for cron in server_cron_tuple:
            cron_name = cron[0]
            cron_command = cron[1]
            cron_schedule = cron[2]
            cron_list.append(cron_schedule + ' ' + cron_command + ' ' + '#' + '%s'  '\n' % cron_name)

        with open('/srv/salt/crons/%s_%s.cron' % (cron_server, cron_user), 'w') as f:
            f.writelines(cron_list)

        subprocess.check_call(
                "salt '%(cron_server)s' cp.get_file salt://crons/%(cron_server)s_%(cron_user)s.cron  /tmp/%(cron_server)s_%(cron_user)s.cron"
                % {'cron_server': cron_server, 'cron_user': cron_user}, shell=True)

        subprocess.check_call(
            "salt '%(cron_server)s' cron.write_cron_file_verbose %(cron_user)s /tmp/%(cron_server)s_%(cron_user)s.cron"
            % {'cron_server': cron_server, 'cron_user': cron_user}, shell=True)
        return redirect('/cron')

    except Exception as e:
        return json.dumps({'status': str(e)})
    finally:
        curs.close()
        conn.close()
