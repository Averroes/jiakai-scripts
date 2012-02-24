# -*- coding: utf-8 -*-
# $File: lib.py
# $Date: Fri Feb 24 23:52:53 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

class SummaryWriter(object):
    _indent = None
    _lines = None
    _title = None
    _first_write = None
    _par = None

    def __init__(self, indent = u'', lines = list()):
        self._indent = indent
        self._lines = lines
        self._first_write = True

    def __call__(self, val):
        self._write_title()
        self._lines.append(self._indent + unicode(val))

    def _write_title(self):
        if self._first_write:
            self._first_write = False
            if self._par:
                self._par._write_title()
            if self._title:
                self._lines.append(self._title)

    def indent(self, name):
        ret = SummaryWriter(self._indent + ' ' * 4, self._lines)
        ret._title = self._indent + name
        ret._par = self
        return ret

    def output(self, f, encoding = None):
        for i in self._lines:
            if encoding is not None:
                i = i.encode(encoding)
            f.write(i)
            f.write('\n')



def mksouptable(soup, header, content,
        bsfy_content = False, convert_unicode = False, caption = None):
    from bs4 import BeautifulSoup

    tb = soup.new_tag('table')
    if caption:
        cap = soup.new_tag('caption')
        cap.append(caption)
        tb.append(cap)
    def addrow(cols, tag = 'td'):
        tr = soup.new_tag('tr')
        for i in cols:
            td = soup.new_tag(tag)
            if convert_unicode:
                i = unicode(i)
            if bsfy_content:
                i = BeautifulSoup(i)
            td.append(i)
            tr.append(td)
        tb.append(tr)

    addrow(header, 'th')
    for i in content:
        addrow(i)

    return tb



