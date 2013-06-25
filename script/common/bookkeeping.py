import sys
import re
import os
import httplib2
import urllib
import json

def main():
    server_url = sys.argv[1]
    run_id = sys.argv[2]
    err = sys.argv[3]
    duration = sys.argv[4]

    client = httplib2.Http(".cache")
    params = urllib.urlencode({
        'analysis_result[task_id]': run_id,
        'analysis_result[status]': err,
        'analysis_result[duration]': duration
    })
    resp, content = client.request(server_url+"/analysis_results.json", "POST", params)
    print resp['status']

if __name__ == "__main__":
    main()
