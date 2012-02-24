# -*- coding: utf-8 -*-
# $File: _base.py
# $Date: Fri Feb 24 15:32:12 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

from sqlalchemy import Table, Column, event, ForeignKey
from sqlalchemy.types import *
from sqlalchemy.orm import relationship, backref
from sqlalchemy.orm.session import object_session
from sqlalchemy.sql.expression import *

from sqlalchemy.ext.declarative import declarative_base as _base

Base = _base()

