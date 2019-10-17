# Purpose
this script is a sample one shot script to test correct signaling on a VoIP server.

# Preps


* you need to have SIPp installed. Depending on what you are doing with SIPp, super user rights are needed
* adapt credentials accoring your PBX in sip-credentials.csv file
* depending on your setup you need to adapt the SIPp XML files as well.


# execution

The script will register a client for incoming calls. There is no registration for an outgoing call. since it is not needed by SIP RFC to have in registration. There is a handling for DA on the outgoing call, so credentials ar needed.
If registration failes, the sctipt will stop and return a failure. If registration and Both calls are going well, the script will exit with return code "0" otherwise > 0.

execute start.sh file with "dev" or "production" in order to give correct sip-credentials.
The Script will register a client "incoming" and watch for incoming calls on this port. After incoming client is started, another client is started which performs the outgoing call.


# SIPp specials

the incoming call will be checks for a specific Header. If you do not want SIPp to check anything within the SIP, you have to delete the regex tag in the incoming call XML file.
