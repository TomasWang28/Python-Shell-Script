from flask import Blueprint

work_order = Blueprint('work_order', __name__)

from . import views