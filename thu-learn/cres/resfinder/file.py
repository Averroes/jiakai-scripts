# -*- coding: utf-8 -*-
# $File: file.py
# $Date: Sat Feb 25 07:49:16 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['FileFinder']

import logging
import re

from cres.resfinder._base import ResfinderBase
from cres import conf

FNAME_REGEX = re.compile(r'^.*filename="(.*)"$')
def get_filename(resp):
    info = resp.info()
    fname = info.getheader('Content-Disposition')
    if fname is None:
        raise ValueError('can not determine filename')
    fname = FNAME_REGEX.match(fname).group(1)
    for enc in ['gb2312', 'utf-8']:
        try:
            return fname.decode(enc)
        except UnicodeDecodeError:
            pass
    raise ValueError('can not decode filename')


def normalize_filename(f):
    pat = u'  <>/\|:"*?'
    rep = u"--()___：'__"
    assert len(pat) == len(rep)

    for i in range(len(pat)):
        f = f.replace(pat[i], rep[i])
    pos = f.rfind('.')
    if pos != -1:
        f = f[:pos] + f[pos:].lower()
    return f


class FileFinder(ResfinderBase):
    _NAME = u'课程文件'

    _course = None
    _sumwrt = None

    def update(self, course, sumwrt):
        self._course = course
        self._sumwrt = sumwrt.indent(u'新课程文件：')

        logging.info('retrieving file list ...')

        br = self._br
        br.open(self._url)

        links = list()
        for i in br.links(url_regex = conf.DOWNLOAD_URL_REGEX):
            links.append(i)

        for i in links:
            resp = br.open(i.url)
            self._download_file(resp, normalize_filename(i.text.strip() + '-' +
                get_filename(resp)))

    def _download_file(self, resp, fname):
        import os
        import os.path

        flen = int(resp.info().getheader('Content-Length'))
        fdir = os.path.join(conf.OUTPUT_DIR,
                normalize_filename(u'{c.id}-{c.name}'.format(c = self._course)))

        if not os.path.isdir(fdir):
            os.makedirs(fdir)

        fpath = os.path.join(fdir, fname)
        if os.path.isfile(fpath):
            return
        logging.info(u'downloading file {0} ...'.format(fname))

        data = resp.read()
        if flen != len(data):
            raise ValueError(u'error while downloading {0}'.format(fname))

        with open(fpath, 'w') as f:
            f.write(data)
        self._sumwrt(fname)

