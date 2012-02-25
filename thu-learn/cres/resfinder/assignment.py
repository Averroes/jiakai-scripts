# -*- coding: utf-8 -*-
# $File: assignment.py
# $Date: Sat Feb 25 17:55:30 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['AssignmentFinder']

import logging
from datetime import date

from bs4 import BeautifulSoup

from cres.resfinder._base import ResfinderBase


def mkdate(s):
    return date(*[int(i) for i in s.split('-')])

class AssignmentFinder(ResfinderBase):
    _NAME = u'课程作业'

    def update(self, course, sumwrt):
        sumwrt = sumwrt.indent(u'未提交作业：')
        logging.info('retrieving assignment list ...')

        today = date.today()

        # F**KING THE AUTHOR OF THIS PAGE!!!
        table = BeautifulSoup(self._br.open(self._url).read().
                    replace('";', '"')).find_all(id = 'table_box')[1]

        for row in table.find_all('tr')[:-1]:
            cols = row.find_all('td')
            stime = mkdate(cols[1].string.strip())
            ttime = mkdate(cols[2].string.strip())
            if today >= stime and today <= ttime and \
                    cols[3].string.strip() == u'尚未提交':
                sumwrt(cols[0].string + u'  （剩余{0}天）'.format(
                    (ttime - today).days))
