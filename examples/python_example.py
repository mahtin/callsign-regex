""" python-example.py
Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
"""

import sys
from itu_appendix42 import ItuAppendix42

def main(args=None):
    """ main """

    ituappendix42 = ItuAppendix42()

    for line in sys.stdin:
        line = line.rstrip()
        v = ituappendix42.fullmatch(line)
        if v:
            print('%-10s' % (line))
        else:
            print('%-10s INVALID' % (line))

if __name__ == '__main__':
    main()
