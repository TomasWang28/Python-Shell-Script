from . import work_order
from flask import render_template, request, session, redirect
from flask.ext.login import login_required
import pymysql
from config import Config
import datetime
import json
from random import Random
from ..pyhighcharts import Highchartsdict


all_department_list = ["IBS", "ICS", "TOP", "HR", "IT"]
all_wo_type_list = ["技术支持", "资源申请", "故障处理"]

# mysql db
mysql_server = Config.mysql_server
mysql_username = Config.mysql_username
mysql_password = Config.mysql_password
mysql_port = 3306
mysql_db = Config.mysql_db

# TypeError: datetime.date(2016, 7, 14) datetime.datetime(2015, 12, 2, 9, 51, 42)  is not JSON serializable
class CJsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            # return obj.strftime('%Y-%m-%d %H:%M:%S')
            return obj.isoformat()
        elif isinstance(obj, datetime.date):
            # return obj.strftime('%Y-%m-%d')
            return obj.isoformat()
        else:
            return json.JSONEncoder.default(self, obj)

def random_str(randomlength=5):
    str = ''
    chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
    length = len(chars) - 1
    random = Random()
    for i in range(randomlength):
        str+=chars[random.randint(0, length)]
    return str

# work_order view
@work_order.route('/work_order')
@login_required
def work_order_list():
    conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                           charset='utf8')
    curs = conn.cursor()
    curs.execute(
        'select wo_id,wo_sn,wo_content,wo_type,wo_department,submitter,submit_time,wo_accepter,wo_group,wo_state from work_orders')
    work_order_list = curs.fetchall()
    return render_template('work_order/Work_order.html', work_order_list=work_order_list, user_name=session.get('username'), role_id=session.get('role_id'))

@work_order.route('/addWorkOrder', methods=['POST'])
@login_required
def addWorkOrder():
    try:
        current_datetime = datetime.datetime.now()
        wo_sn = random_str() + current_datetime.strftime('%m%d%H%M%S')
        wo_content = request.form['addWO_content']
        wo_type = request.form['addWO_type']
        wo_department = request.form['addWO_department']
        submitter = session.get('username')
        submit_time = current_datetime.strftime('%Y/%m/%d %H:%M:%S')
        wo_group = request.form['addWO_group']
        wo_state = '待处理'
        print(wo_sn, wo_content, wo_type, wo_department)

        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')

        curs = conn.cursor()

        curs.execute('''insert into work_orders (wo_sn, wo_content, wo_type, wo_department, submitter, submit_time,
wo_group, wo_state)
                        VALUES( '%(wo_sn)s', '%(wo_content)s', '%(wo_type)s', '%(wo_department)s',
                        '%(submitter)s', '%(submit_time)s','%(wo_group)s',
                        '%(wo_state)s')''' % {'wo_sn': wo_sn, 'wo_content': wo_content, 'wo_type': wo_type,
                        'wo_department': wo_department, 'submitter': submitter,
             'submit_time': submit_time, 'wo_group':wo_group, 'wo_state':wo_state})

        data = curs.fetchall()
        print(data)

        if len(data) is 0:
            conn.commit()
            return redirect('/work_order')
        else:
            return render_template('Errors/error.html', error='An error occurred!')

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))

    finally:
        curs.close()
        conn.close()


@work_order.route('/get_work_order_byid',methods=['POST','GET'])
@login_required
def get_work_order_byid():
    try:
        wo_id = request.args.get('wo_id') or request.form['wo_id']
        work_order_info_list = []
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password, db=mysql_db,
                               charset='utf8')
        curs = conn.cursor()

        curs.execute(
            "select wo_sn,wo_content,wo_type,wo_department,submitter,submit_time,wo_accepter,wo_group,wo_state,wo_priority,accept_time,done_time,process_time from work_orders where wo_id='%s'" % (
                wo_id))
        work_order_info = curs.fetchall()

        work_order_info_list.append({
            'wo_sn': work_order_info[0][0],
            'wo_content': work_order_info[0][1],
            'wo_type': work_order_info[0][2],
            'wo_department': work_order_info[0][3],
            'submitter': work_order_info[0][4],
            'submit_time': work_order_info[0][5],
            'wo_accepter': work_order_info[0][6],
            'wo_group': work_order_info[0][7],
            'wo_state': work_order_info[0][8],
            'wo_priority': work_order_info[0][9],
            'accept_time': work_order_info[0][10],
            'done_time': work_order_info[0][11],
            'process_time': work_order_info[0][12]
        })

        if request.method == 'GET':
            print(wo_id)
            return render_template('work_order/work_order_detail.html', work_order_info_list=work_order_info_list)
        else:
            print(wo_id)
            return json.dumps(work_order_info_list, cls=CJsonEncoder, ensure_ascii=False)
    except Exception as e:
        return render_template('Errors/error.html', error=str(e))

    finally:
        curs.close()
        conn.close()


@work_order.route('/updateWorkOrder', methods=['POST'])
@login_required
def updateWorkOrder():
    try:
        wo_id = request.form['wo_id']
        wo_type = request.form['wo_type']
        wo_department = request.form['wo_department']
        wo_group = request.form['wo_group']
        wo_priority = request.form['wo_priority']
        print(wo_priority)
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()
        curs.execute(
            "update work_orders set wo_type = '%(wo_type)s', wo_department = '%(wo_department)s', "
            "wo_group = '%(wo_group)s', wo_priority = '%(wo_priority)s'"
            "where wo_id = '%(wo_id)s'" % {
                'wo_type': wo_type,'wo_department':wo_department, 'wo_group': wo_group, 'wo_priority': wo_priority,
 'wo_id': wo_id })
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            return json.dumps({'status': 'OK'})
        else:
            return json.dumps({'status': 'ERROR'})

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))
    finally:
        curs.close()
        conn.close()


@work_order.route('/acceptWorkOrder', methods=['POST'])
@login_required
def acceptWorkOrder():
    try:
        wo_id = request.form['wo_id']
        wo_accepter = session.get('username')
        wo_state = '正在处理'
        accept_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')

        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()

        curs.execute(
            "update work_orders set wo_accepter = '%(wo_accepter)s', wo_state = '%(wo_state)s', accept_time = '%(accept_time)s' where wo_id = '%(wo_id)s'" % {
                'wo_accepter': wo_accepter, 'wo_state': wo_state, 'wo_id': wo_id, 'accept_time':accept_time })
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            return json.dumps({'status': 'OK'})
        else:
            return json.dumps({'status': 'ERROR'})

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))

    finally:
        curs.close()
        conn.close()


@work_order.route('/finishWorkOrder', methods=['POST'])
@login_required
def finishWorkOrder():
    try:
        wo_id = request.form['wo_id']
        wo_state = '已完成'
        # done_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S')
        done_time = datetime.datetime.now()
        print(done_time)
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()

        curs.execute("select submit_time,accept_time from work_orders where wo_id='%s'" % (wo_id))
        temp_time = curs.fetchall()
        print(temp_time[0][0])
        # submit_time = datetime.datetime.strptime(temp_time[0][0], '%Y-%m-%d %H:%M:%S')
        submit_time = temp_time[0][0]
        accept_time = temp_time[0][1]
        print(type(submit_time))
        print(type(done_time))
        response_time = (accept_time - submit_time).seconds/60   #分钟
        process_time = (done_time - accept_time).seconds/60   #分钟
        print(process_time)

        curs.execute(
            "update work_orders set  wo_state = '%(wo_state)s', response_time = '%(response_time)s',done_time = '%(done_time)s', process_time = '%(process_time)s' where wo_id = '%(wo_id)s'" % {
                'wo_state':wo_state, 'response_time':response_time, 'done_time': done_time, 'wo_state': wo_state,  'process_time':process_time, 'wo_id': wo_id})
        data = curs.fetchall()

        if len(data) is 0:
            conn.commit()
            return json.dumps({'status': 'OK'})
        else:
            return json.dumps({'status': 'ERROR'})

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))

    finally:
        curs.close()
        conn.close()


@work_order.route('/work_order/wo_statistic')
@login_required
def wo_statistic():
    try:
        conn = pymysql.connect(host=mysql_server, port=mysql_port, user=mysql_username, passwd=mysql_password,
                               db=mysql_db, charset='utf8')
        curs = conn.cursor()
        curs.execute(
            "SELECT wo_department,wo_type,COUNT(*) FROM work_orders WHERE wo_group='IT' GROUP BY wo_department,wo_type")
        it_wo_info_tuple = curs.fetchall()
        curs.execute(
            "SELECT wo_department,wo_type,COUNT(*) FROM work_orders WHERE wo_group='SYS' GROUP BY wo_department,wo_type")
        sys_wo_info_tuple = curs.fetchall()

        it_series_list = Highchartsdict().create_highcharts_series_list(it_wo_info_tuple, all_department_list,
                                                                        all_wo_type_list)
        sys_series_list = Highchartsdict().create_highcharts_series_list(sys_wo_info_tuple, all_department_list,
                                                                         all_wo_type_list)
        print(it_series_list)
        it_wo_chart_dict = Highchartsdict().create_highcharts_dict(chart_type='column', chart_height=350, title='IT服务部门占比',
                                             y_title='工单个数',
                                             xAxis_categories=all_department_list,
                                             series_list=it_series_list)
        sys_wo_chart_dict = Highchartsdict().create_highcharts_dict(chart_type='column', chart_height=350, title='运维服务部门占比', y_title='工单个数',
                                              xAxis_categories=all_department_list,
                                              series_list=sys_series_list
                                              )
        all_wo_chart_dict = Highchartsdict().create_highcharts_dict(chart_type='spline', chart_height=350,
                                                                    title='IT服务部门占比', y_title='工单个数',
                                                                    xAxis_categories=all_department_list,
                                                                    series_list=it_series_list
                                                                    )
        return render_template('work_order/work_order_statistic.html', it_wo_chart_dict=it_wo_chart_dict,
                               sys_wo_chart_dict=sys_wo_chart_dict , all_wo_chart_dict=all_wo_chart_dict)

    except Exception as e:
        return render_template('Errors/error.html', error=str(e))
    finally:
        curs.close()
        conn.close()
