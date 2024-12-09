""" example1.py """

import sys
from itu_appendix42 import ItuAppendix42

ituappendix42 = ItuAppendix42()

for line in sys.stdin:
    line = line.rstrip()
    v = ituappendix42.fullmatch(line)
    if v:
        print('%-10s' % (line))
    else:
        print('%-10s INVALID' % (line))

