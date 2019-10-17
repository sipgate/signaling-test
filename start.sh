#!/bin/bash

PATHPREFIX=`dirname $0`

case $1 in
production)
  export ENV=$1
  export LB_URI=production.server
  ;;
dev)
  export ENV=$1
  export LB_URI=dev.server
  ;;
*)
 echo -e "environment must be specified:\n\nsyntax: $0 <dev|live>\n"
  exit 1
  ;;
esac

INCOMINGPORT=$(shuf -i10001-65000 -n1)
OUTGOINGPORT=$(( $INCOMINGPORT - 1 ))

sipp $LB_URI -sf $PATHPREFIX/incoming/sipp_register.xml -inf "$PATHPREFIX/incoming/$ENV/sip-credentials.csv" -m 1 -p $INCOMINGPORT -timeout 10s &
wait $!
if [ $? -gt 0 ]; then
	echo "Unable to register Client"
	exit 1
fi

sleep 1

sipp $LB_URI -sf $PATHPREFIX/incoming/sipp_accept.xml -inf "$PATHPREFIX/incoming/$ENV/sip-credentials.csv" -m 1 -p $INCOMINGPORT -timeout 60s &
incomingPid=$!

sipp $LB_URI -sf "$PATHPREFIX/outgoing/sipp_outgoing.xml" -inf "$PATHPREFIX/outgoing/$ENV/sip-credentials.csv" -m 1 -p $OUTGOINGPORT -timeout 60s &
outgoingPid=$!

wait $incomingPid
incomingResult=$?
wait $outgoingPid
outgoingResult=$?

echo "Return Code of Incoming was $incomingResult"
echo "Return Code of Outgoing was $outgoingResult"

if [ $incomingResult -gt $outgoingResult ]; then
    exit $incomingResult
else
    exit $outgoingResult
fi
