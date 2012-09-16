# -*- coding: utf-8 -*-
# $File: files.py
# $Date: Sun Sep 16 20:36:19 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = 'Notify'

from cres.model._base import *

class Ignored(Base):
    __tablename__ = 'files_ignored'
    
    name = Column(Text, primary_key = True)

