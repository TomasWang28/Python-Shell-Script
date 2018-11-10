from flask.ext.script import Manager, Server, Shell
from werkzeug import generate_password_hash
from app import create_app
from app.models import User, Role
import datetime

app = create_app()

manager = Manager(app)

# Shell名令启动一个Python shell。可以穿进去一个make_context参数，这个参数必须是一个字典。默认情况下，将返回你的 Flask应用实例。
def make_shell_context():
    return dict(app=app, User=User, Role=Role)

manager.add_command("shell", Shell(make_context=make_shell_context))

manager.add_command("runserver",
                    Server(host="0.0.0.0", port=80, use_debugger=True))

@manager.command
def create_db():
    """create related  tables"""
    from app.models import db
    db.create_all()
    a = User.query.all()
    print(a)


@manager.command
def create_admin():
    """ Create default admin user """
    from app.models import db
    role = Role(id=1, role_name='administrator')
    #email='admin@lemon.com'
    admin = User(id=1, user_name='admin', user_email='admin@lemon.com', password_hash=generate_password_hash('tomas'), created_time = datetime.datetime.now().strftime('%Y/%m/%d %H:%M:%S'), role_id=1)
    #Qdb.session.add(role)
    db.session.add(admin)
    db.session.commit()     # This is needed to write the changes to database
    print("Default admin user, username:  admin   password: tomas")


if __name__ == '__main__':
    manager.run()
