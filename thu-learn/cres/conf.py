# -*- coding: utf-8 -*-
# $File: conf.py
# $Date: Sun Sep 16 21:01:00 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

import re
OUTPUT_DIR = None

SITE_URL = 'https://learn.tsinghua.edu.cn/'
LOGIN_URL = '/index.jsp'
COURSE_LIST_URL = '/MultiLanguage/lesson/student/MyCourse.jsp?language=cn'
COURSE_URL_REGEX = re.compile(r'^.*MultiLanguage/lesson/student/' \
        'course_locate.jsp\?course_id=(.*)$')

COURSE_NAME_REGEX = re.compile(r'^(.*)\([0-9]*\)\([^)]*\)$')

DOWNLOAD_URL_REGEX = re.compile(r'^/uploadFile/downloadFile_student.jsp\?.*$')

FILE_CHUNK_SIZE = 1024000

FILE_PROMPT_SIZE = 1024 * 1024 * 100
# ask user whether to download if bigger than this

del re
