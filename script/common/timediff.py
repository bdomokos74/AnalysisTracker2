from datetime import datetime
import sys

d1_str = sys.argv[1]
d2_str = sys.argv[2]
fmt = "%Y-%m-%d %H:%M:%S"
d1 = datetime.strptime(d1_str, fmt)
d2 = datetime.strptime(d2_str, fmt)

td = d2-d1
print "%ssec (=%.02fmin or %.02fh)"%(int(td.total_seconds()), td.total_seconds()/60, td.total_seconds()/60/60)

