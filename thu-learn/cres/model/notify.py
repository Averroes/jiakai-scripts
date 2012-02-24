# -*- coding: utf-8 -*-
# $File: notify.py
# $Date: Fri Feb 24 15:32:23 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = 'Notify'

from cres.model._base import *

class Notify(Base):
    __tablename__ = 'notify'

    id = Column(Integer, primary_key = True)
    cid = Column(Integer, ForeignKey('course.id'), primary_key = True)

    title = Column(Text)
    author = Column(Text)
    content = Column(Text)
    time = Column(Integer, index = True, unique = False)

    course = relationship('Course', uselist = False,
            backref = backref('notifies', order_by = desc(time)))
