""" callsign_regex.py """

import sys
from itu_appendix42 import ItuAppendix42

usage = """callsign-regex [-R] [-d] [-r]
    -R - dump regex (to be used in code)
    -d - dump table (showing callsign to country table)
    -r - dump reverse table (showing country to callsign table)
"""

def callsign_regex(args=None):
    """ main """
    if args is None:
        args = sys.argv[1:]

    ituappendix42 = ItuAppendix42()
    if len(args) > 0 and args[0] == '-R':
        print(ItuAppendix42._regex)
    elif len(args) > 0 and args[0] == '-d':
        ituappendix42.dump()
    elif len(args) > 0 and args[0] == '-r':
        ituappendix42.rdump()
    else:
        sys.exit(usage)

if __name__ == '__main__':
    main()
