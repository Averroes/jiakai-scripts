# -*- coding: utf-8 -*-
# $File: __init__.py
# $Date: Sat Mar 24 12:17:08 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['main']

import logging
import sys
import os.path

import mechanize

from cres.resfinder import *
from cres.lib import SummaryWriter
from cres import conf

RESFINDER_LIST = [NotifyFinder, FileFinder, AssignmentFinder]

def fix_mechanize():
    from mechanize import _pullparser
    t = _pullparser._AbstractParser
    orig_func = t.get_text

    def get_text_unicode(self, *args, **kargs):
        ret = orig_func(self, *args, **kargs)
        return unicode(ret, self.encoding)

    t.get_text = get_text_unicode


def fix_ssl_version():
    import ssl

    orig_wrap_socket = ssl.wrap_socket

    def wrap_socket(*args, **kargs):
        kargs['ssl_version'] = ssl.PROTOCOL_SSLv3
        return orig_wrap_socket(*args, **kargs)

    ssl.wrap_socket = wrap_socket

class Course(object):
    """representing a course"""

    url = None
    name = None
    id = None
    """the course id in the website, not the local database"""

    model = None
    """the database model instance"""


    def __init__(self, url, name):
        from sqlalchemy.orm.exc import NoResultFound
        from cres.model import getsession
        from cres.model.course import Course

        name = conf.COURSE_NAME_REGEX.match(name).group(1)

        self.url = url
        self.name = name
        self.id = conf.COURSE_URL_REGEX.match(url).group(1)

        ses = getsession()
        try:
            self.model = ses.query(Course).filter(Course.name == name).one()
        except NoResultFound:
            self.model = Course(name = name)
            ses.add(self.model)
            ses.commit()

    @staticmethod
    def from_browser(br):
        """Return a list of :class:`Course` instances."""
        ret = list()
        br.open(conf.COURSE_LIST_URL)
        for i in br.links(url_regex = conf.COURSE_URL_REGEX):
            ret.append(Course(i.url, i.text.strip()))
        return ret


    def update(self, br, sumwrt, res):
        """*res* is a list of classes based on
        :class:`cres.resource.CourseResourceBase`, representing the resources needed
        to retrieve."""
        
        ins = list()
        br.open(self.url)
        for i in res:
            ins.append(i(br))

        for i in ins:
            i.update(self, sumwrt)


def login():
    import getpass
    """Do a interactive login (request the username and password from the user)
    and return the :class:`mechanize.Browser` instance."""
    br = mechanize.Browser()
    br.set_handle_equiv(True)
    br.set_handle_redirect(True)
    br.set_handle_referer(True)

    br.open(mechanize.urljoin(conf.SITE_URL, conf.LOGIN_URL))
    br.select_form(name = 'form1')
    br['userid'] = raw_input('username: ')
    br['userpass'] = getpass.getpass('password: ')
    resp = br.submit().read()
    if 'alert' in resp:
        sys.exit(resp)
    return br


def init():
    logging.basicConfig(
            level = logging.DEBUG, 
            format = '[%(asctime)s] %(message)s',
            datefmt = '%H:%M:%S')

    from cres import model
    model.init()

    fix_mechanize()
    fix_ssl_version()

def update_all_course(ignore):
    """*ignore* is a set of course ids to be ignored"""
    br = login()
    courses = Course.from_browser(br)
    sumwrt = SummaryWriter()
    for i in courses:
        if i.id in ignore:
            logging.warn(u'course {0} is ignored'.format(i.name))
            continue

        res_list = list()
        for j in range(len(RESFINDER_LIST)):
            if '{0}.{1}'.format(i.id, j) in ignore:
                logging.warn(u'resource finder {0} for ' \
                        'course {1} is ignored'.format(
                            RESFINDER_LIST[j].__name__, i.name))
            else:
                res_list.append(RESFINDER_LIST[j])

        logging.info(u'getting updates for course {0} ...'.format(i.name))
        i.update(br, sumwrt.indent(u'{0}-{1}:'.format(i.id, i.name)), res_list)


    print u'总览：'
    linesep = '=' * 30
    print linesep
    sumwrt.output(sys.stdout)
    summary_output = os.path.join(conf.OUTPUT_DIR, 'summary.txt')
    with open(summary_output, 'w') as f:
        sumwrt.output(f, 'utf-8')
    print linesep
    print u'总览已写入 ' + summary_output


def additional_output():
    fpath = os.path.join(conf.OUTPUT_DIR, u'课程公告.html')
    with open(fpath, 'w') as f:
        f.write(NotifyFinder.all2html())
    print u'课程公告已写入 ' + fpath


def usage():
    print >> sys.stderr, \
            'usage: {0} <output directory> [ignore_term ...]'.\
            format(sys.argv[0])
    print >> sys.stderr, \
    """
    ignore_term=course_id|course_id.resfinder_id
        ignore the course whose id is course_id, or a specific resource in this course
        available resource finders:
            resfinder_id  resource finder name"""
    for i in range(len(RESFINDER_LIST)):
        print >> sys.stderr, "{0}{1:<12}  {2}".format(' ' * 12, i,
                RESFINDER_LIST[i].__name__)
    sys.exit()

def main():
    if len(sys.argv) == 1:
        usage()
    conf.OUTPUT_DIR = sys.argv[1]
    init()
    update_all_course(set(sys.argv[2:]))
    additional_output()

