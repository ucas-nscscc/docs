#!/usr/bin/bash
# get-diff.sh
CMT_SIGN=`git log | grep '^commit [a-z|0-9]' | awk '{print $2}'`
CMT_SIGN=(${CMT_SIGN})
echo ${CMT_SIGN}
