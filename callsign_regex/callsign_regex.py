""" callsign_regex.py """

import sys
import argparse

# sys.path.insert(0, os.path.abspath('..'))

from itu_appendix42 import ItuAppendix42, __version__

def callsign_regex():
    """ callsign_regex """

    parser = argparse.ArgumentParser(
                    prog='callsign-regex',
                    description='Produce a valid optimized regex from the ITU Table of International Call Sign Series (Appendix 42 to the RR). Based on https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx',
                    epilog='For more information, see github repository - https://github.com/mahtin/callsign-regex')

    parser.add_argument('-V', '--version', action='store_true', default=False,  help='dump version number')
    parser.add_argument('-v', '--verbose', action='store_true',  default=False, help='verbose output')
    parser.add_argument('-F', '--force', action='store_true',  default=False, help='force rebuild of cached regex')
    parser.add_argument('-R', '--regex', action='store_true',  default=False, help='dump regex (to be used in code)')
    parser.add_argument('-f', '--forward', action='store_true',  default=False, help='dump table (showing callsign to country table)')
    parser.add_argument('-r', '--reverse', action='store_true',  default=False, help='dump reverse table (showing country to callsign table)')

    args = parser.parse_args()

    if args.version:
        print('Version: %s' % (__version__))
        sys.exit(0)

    if not args.regex and not args.forward and not args.reverse:
        # at least one is required
        parser.print_help(sys.stderr)
        sys.exit(1)

    ituappendix42 = ItuAppendix42(force=args.force, verbose=args.verbose)

    if args.regex:
        print(ituappendix42.regex())
    if args.forward:
        print(ituappendix42.dump())
    if args.reverse:
        print(ituappendix42.rdump())

    sys.exit(0)
