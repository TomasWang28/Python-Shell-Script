from flask import Blueprint

cron = Blueprint('cron', __name__)

from . import views
