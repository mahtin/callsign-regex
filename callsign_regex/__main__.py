"""__main__

Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
"""

import sys
from callsign_regex import callsign_regex

def main(args=None):
    """ callsign-regex command line """
    callsign_regex.callsign_regex()

if __name__ == '__main__':
    main()
