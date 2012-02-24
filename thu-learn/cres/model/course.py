# -*- coding: utf-8 -*-
# $File: course.py
# $Date: Fri Feb 24 15:21:08 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['Course']

from cres.model._base import *

COURSE_NAME_LEN_MAX = 255

class Course(Base):
    __tablename__ = 'course'

    id = Column(Integer, primary_key = True)
    name = Column(String(COURSE_NAME_LEN_MAX), index = True, unique = True)

    notifies = None
    """backref defined in the Notify model"""

