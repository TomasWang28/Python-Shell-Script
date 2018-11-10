from email import encoders
from email.header import Header
from email.mime.text import MIMEText
from email.utils import parseaddr, formataddr
from email.mime.multipart import MIMEMultipart
from email.mime.multipart import MIMEBase
import os

import smtplib

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr))

# 输入Email地址和口令:
from_addr = '18222273318@163.com'
password = os.environ.get('MALLPASSWORD')
# 输入收件人地址:
to_addr = '674132274@qq.com'
# 输入SMTP服务器地址:
smtp_server = 'smtp.163.com'
smtp_port = 25


# msg = MIMEText('<html><body><h1>Hello</h1>' +
#                '<p>send by <a href="http://www.python.org">Python</a>...</p>' +
#                '</body></html>', 'html', 'utf-8')
msg = MIMEMultipart()
# msg.attach(MIMEText('<html><body><h1>Hello</h1>' +
#                     '<p><img src="https://cdn.liaoxuefeng.com/cdn/files/attachments/001408019030110a0be121000cc46139f7a72982b19daf3000"></p>' +
#                     '</body></html>', 'html', 'utf-8'))
msg['From'] = _format_addr('Python爱好者 <%s>' % from_addr)
msg['To'] = _format_addr('管理员 <%s>' % to_addr)
msg['Subject'] = Header('来自SMTP的问候……', 'utf-8').encode()

msg.attach(MIMEText('send with file...', 'html', 'utf-8'))

with open('640.jpg', 'rb') as f:
    # 设置附件的MIME和文件名，这里是png类型:
    mime = MIMEBase('image', 'jpg', filename='640.jpg')
    # 加上必要的头信息:
    mime.add_header('Content-Disposition', 'attachment', filename='640.jpg')
    mime.add_header('Content-ID', '<0>')
    mime.add_header('X-Attachment-Id', '0')
    # 把附件的内容读进来:
    mime.set_payload(f.read())
    # 用Base64编码:
    encoders.encode_base64(mime)
    # 添加到MIMEMultipart:
    msg.attach(mime)

msg.attach(MIMEText('<html><body><h1>Hello</h1>' +
                    '<p><img src="cid:0"></p>' +
                    '</body></html>', 'html', 'utf-8'))

server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()
server.set_debuglevel(1)
server.login(from_addr, password)
server.sendmail(from_addr, [to_addr], msg.as_string())
server.quit()