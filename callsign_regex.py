""" callsign-regex.py """

import sys
from itu_appendix42 import ItuAppendix42

def main(args=None):
    """ main """
    if args is None:
        args = sys.argv[1:]

    ituappendix42 = ItuAppendix42()
    if len(args) > 0 and args[0] == '-R':
        print(ItuAppendix42._regex)
    elif len(args) > 0 and args[0] == '-r':
        ituappendix42.rdump()
    else:
        ituappendix42.dump()

if __name__ == '__main__':
    main()
