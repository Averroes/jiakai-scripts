#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# $File: syllabus.py
# $Date: Sun Feb 23 21:17:18 2014 +0800
# $Author: jiakai <jia.kai66@gmail.com>
#
# Copyright (C) 2012, 2013 Kai Jia <jia.kai66@gmail.com>
#
# you can do ANYTHING you want with this program

import sys
import re
import textwrap
from hashlib import sha256
from datetime import datetime, timedelta, date
from collections import namedtuple

from icalendar import Calendar, Event

def fix_icalendar():
    """fix some icalendar misbehaviour"""
    from icalendar import parser, prop
    def _foldline(text, lenght=75, newline='\r\n'):
        return newline.join(
                i.encode('utf-8') for i in 
                textwrap.wrap(text.decode('utf-8'), lenght,
                    subsequent_indent=' ',
                    drop_whitespace = True,
                    break_long_words = True
                    )
                )
    parser.foldline = _foldline
    # a quick hack for utf-8 support

    def vdddt___init__(self, dt):
        from icalendar import Parameters
        assert isinstance(dt, datetime)
        self.params = Parameters({'TZID': 'Asia/Shanghai'})
        self.dt = dt

    def vdddt_to_ical(self):
        return self.dt.strftime("%Y%m%dT%H%M%S")
    prop.vDDDTypes.__init__ = vdddt___init__
    prop.vDDDTypes.to_ical = vdddt_to_ical

CourseTimeRule = namedtuple('CourseTimeRule', ['first_week', 'step', 'count'])

class CourseTime(object):
    time_start = None
    """absolute start time of first class of this course"""

    time_end = None
    """absolute end time of first class of this course"""

    step = None
    """week step"""
    count = None
    """week count"""

    week_start = None
    """week of first class of this course, starting from 0"""

    _TIME2RRULE = {
            u'全周': CourseTimeRule(0, 1, 16),
            u'前八周': CourseTimeRule(0, 1, 8),
            u'后八周': CourseTimeRule(8, 1, 8),
            u'单周': CourseTimeRule(0, 2, 8),
            u'双周': CourseTimeRule(1, 2, 8),
        }
    def __init__(self, **kargs):
        for i, j in kargs.iteritems():
            self.__setattr__(i, j)

    _special_week_re = re.compile(u'(第)?([0-9,-]*)(周)+$')
    @classmethod
    def from_str(cls, val, course_start, course_end):
        """try to recognize course time from string *val* and return a list of
        :class:`CourseTime` instances, or return *None* on parse failure"""

        def mkcoursetime(rule):
            td = timedelta(weeks = rule.first_week)
            return CourseTime(
                    time_start = course_start + td,
                    time_end = course_end + td,
                    step = rule.step,
                    count = rule.count,
                    week_start = rule.first_week)

        def mkrule(desc):
            """generate a rule from descriptions like a-b or c"""
            v = desc.strip().split('-')
            if len(v) == 1:
                return CourseTimeRule(int(v[0]) - 1, 1, 1)
            else:
                assert len(v) == 2
                return CourseTimeRule(
                    int(v[0]) - 1, 1, int(v[1]) - int(v[0]) + 1)

        rule = cls._TIME2RRULE.get(val)

        if rule is not None:
            return [mkcoursetime(rule)]

        m = cls._special_week_re.match(val)
        if m is None:
            return None

        ret = list()
        for i in m.group(2).split(','):
            ret.append(mkcoursetime(mkrule(i)))

        return ret

    def update_event(self, event):
        event.add('dtstart', self.time_start)
        event.add('dtend', self.time_end)
        event.add('rrule', self._mkrrule())

    def _mkrrule(self):
        d = dict()
        d['count'] = self.count
        d['freq'] = 'WEEKLY'
        d['interval'] = self.step
        return d


    def __str__(self):
        return u'CourseTime dump:\n' + u'\n'.join('{0}={1}'.format(i,
            str(self.__getattribute__(i)))
            for i in ('time_start', 'time_end', 'step', 'count',
            'week_start'))

    __repr__ = __str__


class Course(object):
    name = None
    desc = None
    location = 'unknown'

    time = None
    """a list of :class:`CourseTime` instances"""

    _COURSE_TIME = (
            ((8,  00), (9,  35)),
            ((9,  50), (12, 15)),
            ((13, 30), (15, 05)),
            ((15, 20), (16, 55)),
            ((17, 10), (18, 45)),
            ((19, 20), (21, 45)),
            )

    _data_re = re.compile(r'(.*)\(([^)]*)\)$')
    def __init__(self, desc, first_day, num_in_day):
        """initialize a course object from description and date information
        :param desc: str, the description
        :param first_day: datetime, the first day of the corresponding weekday
            of this course in the semester
        :param num_in_day: the number of this course in the day (range(6))"""
        start_time, end_time = self._COURSE_TIME[num_in_day]
        match = self._data_re.match(desc)
        self.name = match.group(1)
        self.desc = desc
        items = match.group(2).split(u'；')

        items.reverse()
        # usually time and location appear last

        for i in items:
            if self._is_location(i):
                self.location = i
                break

        for i in items:
            if i.startswith(u'时间'):
                s, t = i[2:].split('-')
                start_time = map(int, s.split(':'))
                end_time = map(int, t.split(':'))

        start_time = first_day + timedelta(
                hours = start_time[0], minutes = start_time[1])
        end_time = first_day + timedelta(
                hours = end_time[0], minutes = end_time[1])
        for i in items:
            t = CourseTime.from_str(i, start_time, end_time)
            if t is not None:
                self.time = t
                break

        if self.time is None:
            raise ValueError(u'无法解析课程时间：{0}'.format(
                desc).encode('utf-8'))



    _LOCATION_LIST = (u'楼', u'教', u'中心', u'馆', u'院', u'伟伦',
            u'阶', u'厅', u'房', u'堂', u'基地', u'操场', u'FIT')
    @classmethod
    def _is_location(cls, val):
        for i in cls._LOCATION_LIST:
            if i in val:
                return True
        return False

    def mkevent(self):
        """return a list of :class:`icalendar.Event` objects"""
        ret = list()
        for i in self.time:
            event = Event()
            event.add('summary', self.name)
            event.add('dtstamp', datetime.today())
            event.add('created', datetime.today())
            event.add('last-modified', datetime.today())
            event.add('uid', sha256(self.name.encode('utf-8') +
                str(i.time_start)).hexdigest())
            event.add('location', self.location)
            event.add('description', self.desc)
            event.add('transp', 'opaque')
            i.update_event(event)
            ret.append(event)
        return ret

    def __str__(self):
        return u'\n  '.join(['Course dump:'] +
                [u'{0}={1}'.format(i, getattr(self, i)) for i in
                    'name', 'desc', 'location'] + 
                ['time:\n    ' + u'\n    '.join(
                    str(i).replace('\n', '\n      ') for i in self.time)])

    __repr__ = __str__


class FileParser(object):

    course = None
    """a list of :class:`Course` instances"""

    def __init__(self, fpath, first_day):
        """*first_day* is a :class:`datetime` instance indicating the first day
        of this semester, which must be Monday"""
        import xlrd

        work_book = xlrd.open_workbook(fpath)
        sheet = work_book.sheet_by_index(0)


        self.course = list()
        for row in range(2, 8):
            for col in range(1, 8):
                for desc in sheet.cell_value(row, col).split('\n'):
                    ds = desc.strip()
                    if ds:
                        self.course.append(Course(ds, first_day +
                            timedelta(days = col - 1), row - 2))


    def mkical(self):
        cal = Calendar()
        cal.add('prodid', '-//thu syllabus to iCal//by jk//CST14')
        cal.add('version', '2.0')
        for i in self.course:
            map(cal.add_component, i.mkevent())
        return cal


def main():
    if len(sys.argv) != 6:
        sys.exit('usage: {0} <year> <month> <day> <XLS input file> ' \
                '<iCal output file>'.format(sys.argv[0]))

    [year, month, day] = [int(i) for i in sys.argv[1:4]]
    assert date(year, month, day).weekday() == 0

    fix_icalendar()
    fp = FileParser(sys.argv[4], datetime(year, month, day))
    for i in fp.course:
        print unicode(i)

    with open(sys.argv[5], 'w') as fout:
        fout.write(fp.mkical().to_ical())

if __name__ == '__main__':
    main()
