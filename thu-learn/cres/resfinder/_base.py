# -*- coding: utf-8 -*-
# $File: _base.py
# $Date: Fri Feb 24 20:37:42 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

class ResfinderBase(object):
    """the abstract base class representing a resource in a course"""

    _NAME = None
    """name of this resource; the link text used by the default constructor"""

    _url = None
    _br = None

    def __init__(self, br):
        """*br* is a :class:`mechanize.Browser` instance, located at the main
        page of the course. *br* should not be modified."""
        if self._NAME is None:
            raise NotImplementedError()
        link = br.find_link(text = self._NAME)
        self._url = link.url
        self._br = br


    def update(self, course, sumwrt):
        """Note that *br* passed to :attr:`__init__` should still be
        available. *course* is a :class:`cres.__init__.Course` instance.
        *sumwrt* is an SummaryWriter instance."""
        raise NotImplementedError()
