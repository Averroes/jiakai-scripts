# -*- coding: utf-8 -*-
# $File: __init__.py
# $Date: Sat Feb 25 00:17:38 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['install_db']


from cres import conf

_session = None

def getsession():
    return _session()

def init():
    import os.path

    from sqlalchemy import create_engine, event
    from sqlalchemy.orm import sessionmaker, scoped_session

    DBFILE = os.path.join(conf.OUTPUT_DIR, 'course_res.db')

    need_install = not os.path.isfile(DBFILE)

    engine = create_engine('sqlite:///' + DBFILE)
    event.listen(engine, 'connect', lambda con, record:
            con.execute('PRAGMA foreign_keys=ON'))

    global _session

    _session = scoped_session(sessionmaker(bind = engine))

    if need_install:
        from os import makedirs
        if not os.path.isdir(conf.OUTPUT_DIR):
            makedirs(conf.OUTPUT_DIR)

        from pkgutil import walk_packages
        for loader, module_name, is_pkg in walk_packages(__path__, __name__ + '.'):
            __import__(module_name, globals(), locals(), [], -1)

        from cres.model._base import Base
        Base.metadata.create_all(engine)


