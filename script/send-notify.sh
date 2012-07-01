#!/bin/bash -e
# $File: send-notify.sh
# $Date: Sat Jun 30 09:12:40 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>
eval $(grep '^PIPE_PATH=' ~/script/setup-x.sh)
cat > "$PIPE_PATH"
