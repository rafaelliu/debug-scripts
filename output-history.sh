#!/bin/bash
#
# This scripts checks for the output of CMD command and, whenever it changes,
# it records the output to a out.<SEQ NUMBER> file so we can see series of
# snapshots over time.
#
# This script resets previous results before each run.
#
# Rafael Liu <rafaelliu@gmail.com>
#

# watch for changes in files' FDs (we cut some stuff off which we don't want to monitor)
#CMD="lsof /tmp/test.log | sed 's/\s\+/ /g' | cut -n -d ' ' -f 1-4,9"

CMD="ls /tmp"
HISTORY_DIR="/tmp/output-history"

#
# don't touch below
#

cd $HISTORY_DIR
rm out.* 2> /dev/null

LS=$( ls -rt out.* 2> /dev/null )

COUNT=0
while (true); do

	eval $CMD > now

	LAST_OUT="out.$COUNT"

	if [ ! -f "$LAST_OUT" ]; then
		mv now $LAST_OUT
		continue
	fi
	
	diff $LAST_OUT now > /dev/null
	if [ $? != 0 ]; then
		COUNT=$((COUNT + 1))
		mv now out.$COUNT
	fi

	sleep 3s

done
