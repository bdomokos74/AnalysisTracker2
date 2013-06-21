import sys
import re
import os
import smtplib
import json
from email.mime.text import MIMEText

def main():
    cred = json.loads(open("%s/.maildetails"%(os.environ["HOME"]), "r").read())

    from_addr = cred["from"]
    to_addr = sys.argv[1]
    message = sys.argv[2]
    msg = MIMEText(message)
    msg['Subject'] = "SCRIPTNOTIF"
    msg['From'] = from_addr
    msg['To'] = to_addr

    s = smtplib.SMTP("smtp.gmail.com:587")
    s.starttls()
    s.login(cred["user"], cred["pw"])
    s.sendmail(from_addr, [to_addr], msg.as_string())
    s.quit()

if __name__ == "__main__":
    main()
