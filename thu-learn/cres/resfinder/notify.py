# -*- coding: utf-8 -*-
# $File: notify.py
# $Date: Fri Feb 24 20:37:38 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

import logging

from bs4 import BeautifulSoup

from cres.resfinder._base import ResfinderBase
from cres.model import getsession
from cres.model.notify import Notify
from cres.model.course import Course
from cres.model._base import desc

class NotifyFinder(ResfinderBase):
    _NAME = u'课程公告'

    def _do_update(self, course):
        updated = False
        ses = getsession()
        br = self._br
        page_soup = BeautifulSoup(br.open(self._url).read())
        for row in page_soup.find(id = 'table_box').find_all('tr')[1:]:
            rct = row.find_all('td')
            obj = Notify(id = int(rct[0].string))
            if not ses.query(Notify).filter(Notify.cid == course.model.id). \
                    filter(Notify.id == obj.id).count():
                import datetime
                obj.cid = course.model.id
                obj.title = u''.join(unicode(i).strip() for i in rct[1].strings)
                obj.author = unicode(rct[2].string.strip())

                t = datetime.date(*[int(i) for i in rct[3].string.split('-')])
                obj.time = t.toordinal()

                logging.info(u'retrieving notify: {0}'.format(obj.title))
                url = row.find('a').get('href').encode('utf-8')
                soup = BeautifulSoup(br.open(url).read())
                data = soup.find(id = 'table_box').find_all('td')[3].children
                obj.content = u''.join(unicode(i) for i in data)

                ses.add(obj)
                updated = True

        ses.commit()
        return updated



    def update(self, course, sumwrt):
        logging.info('retrieving notify list ...')
        if self._do_update(course):
            sumwrt(u'课程公告已更新')


    @staticmethod
    def all2html():
        from cres.lib import mksouptable
        logging.info('generating output html ...')
        soup = BeautifulSoup(_PAGE_TEMPLATE)
        body = soup.body

        ses = getsession()
        courses = ses.query(Course).order_by(Course.id).all()
        
        def _mklink(href, content, name = None):
            a = soup.new_tag('a')
            if href:
                a['href'] = href
            if name:
                a['name'] = name
            a.append(content)
            return a

        body.append(_mklink(None, ' ', 'top'))
        body.append(mksouptable(soup, [u'索引', u'公告数量'],
            [[_mklink('#all', 'all in one'), str(ses.query(Notify).count())]] +
            [[_mklink('#' + str(i.id), i.name), str(len(i.notifies))] for i in courses]))


        back_to_top = '<div class="back"><a href="#top">back to top</a></div>'

        def time2str(time):
            from datetime import date
            d = date.fromordinal(time)
            return '-'.join((str(i) for i in (d.year, d.month, d.day)))

        body.append(_mklink(None, ' ', 'all'))
        body.append(mksouptable(soup,
            [u'课程', u'标题', u'发布者', u'时间', u'内容'],
            [[i.course.name, i.title, i.author, time2str(i.time), i.content] for i in
                ses.query(Notify).order_by(desc(Notify.time)).all()],
            True, True, 'all in one'))
        body.append(BeautifulSoup(back_to_top))


        for i in courses:
            body.append(_mklink(None, ' ', str(i.id)))
            body.append(mksouptable(soup,
                [u'标题', u'发布者', u'时间', u'内容'],
                [[j.title, j.author, time2str(j.time), j.content] for j in i.notifies],
                True, True, i.name))
            body.append(BeautifulSoup(back_to_top))

        return unicode(soup).encode('utf-8')



_PAGE_TEMPLATE = u"""
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <title>课程公告列表</title>
    <style>
        table
        {
            clear: both;
            border-collapse: collapse;
            margin: auto;
            margin-top: 4em;
        }
        table th
        {
            text-align: center;
        }
        table tr, table th, table td
        {
            border: 1px solid #C3C3C3;
            padding: 3px;
        }
        table th
        {
            background-color: #E5EECC;
        }
        table tr:hover
        {
            background-color: #E5EEFF;
        }
        div.back
        {
            clear: both;
            float: right;
        }
    </style>
</head>
<body>
</body>
</html>"""

