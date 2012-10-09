# -*- coding: utf-8 -*-
# $File: file.py
# $Date: Mon Sep 17 23:17:40 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

__all__ = ['FileFinder']

from cres.resfinder._base import ResfinderBase
from cres.model import getsession
from cres.model.files import Ignored
from cres import conf

import logging
import re

import os
import os.path

FNAME_REGEX = re.compile(r'^.*filename="(.*)"$')
def get_filename(resp):
    info = resp.info()
    fname = info.getheader('Content-Disposition')
    if fname is None:
        raise ValueError('can not determine filename')
    fname = FNAME_REGEX.match(fname).group(1)
    for enc in ['gb18030', 'utf-8']:
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

def size2str(s):
    unit = ['', 'Ki', 'Mi', 'Gi']
    p = 0
    while s >= 1024 and p + 1 < len(unit):
        s /= 1024.0
        p += 1
    return '{0:.2f}{1}b'.format(s, unit[p])

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
            fname = normalize_filename(i.text.strip() + '-' +
                    get_filename(resp))
            logging.info(u'checking file {0} ...'.format(fname))
            self._download_file(resp, fname)

    def _download_file(self, resp, fname):
        ses = getsession()
        if ses.query(Ignored).filter(Ignored.name == fname).count():
            logging.info('canceled by user')
            return

        flen = int(resp.info().getheader('Content-Length'))
        fdir = os.path.join(conf.OUTPUT_DIR,
                normalize_filename(u'{c.id}-{c.name}'.format(c = self._course)))

        if not os.path.isdir(fdir):
            os.makedirs(fdir)

        fpath = os.path.join(fdir, fname)
        if os.path.isfile(fpath) and os.stat(fpath).st_size == flen:
            return
        logging.info(u'downloading file {0} ...'.format(fname))

        if flen > conf.FILE_PROMPT_SIZE:
            print u'***\nsize of "{0}" is {1}, still download? (y/n)'.\
                    format(fname, size2str(flen))
            while True:
                r = raw_input()
                if r not in ['y', 'n']:
                    print 'Please enter y or n'
                    continue
                if r == 'y':
                    break
                ses.add(Ignored(name = fname))
                ses.commit()
                return
        if flen > conf.FILE_CHUNK_SIZE:
            fread = 0
            with open(fpath, 'wb') as f:
                while fread < flen:
                    data = resp.read(conf.FILE_CHUNK_SIZE)
                    logging.info(u"{fname}: {0}/{1} {2:.2%}".format(
                        size2str(fread), size2str(flen),
                        float(fread) / flen, fname = fname))
                    fread += len(data)
                    f.write(data)
                    del data
        else:
            data = resp.read()
            if flen != len(data):
                raise ValueError(u'error while downloading {0}'.format(fname))
            with open(fpath, 'wb') as f:
                f.write(data)

        self._sumwrt(fname)

