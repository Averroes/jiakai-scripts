# -*- coding: utf-8 -*-
# $File: conf.py
# $Date: Sat Feb 25 00:07:57 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

import re
OUTPUT_DIR = None

SITE_URL = 'https://learn.tsinghua.edu.cn/'
LOGIN_URL = '/index.jsp'
COURSE_LIST_URL = '/MultiLanguage/lesson/student/MyCourse.jsp?language=cn'
COURSE_URL_REGEX = re.compile(r'^.*MultiLanguage/lesson/student/' \
        'course_locate.jsp\?course_id=(.*)$')

COURSE_NAME_REGEX = re.compile(r'^([^(]*)\(.*\)$')

DOWNLOAD_URL_REGEX = re.compile(r'^/uploadFile/downloadFile_student.jsp\?.*$')

del re
