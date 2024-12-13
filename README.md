# callsign-regex
Python code to build a current regex to match all (legal) ham radio callsigns globally.
Based on the ITU Table of International Call Sign Series (Appendix 42 to the RR).

## Install

```bash
$ pip install callsign-regex
...
$
```

## Producing a regex

Use the `-R` command line argument. The resulting output is the regex to match all ham radio callsigns: This regex string can be used in many programming languages (including Python).

```bash
$ callsign-regex -R
(([2BFGIKMNRW][A-Z]{0,2}|3[A-CE-Z][A-Z]{0,1}|4[A-MO-Z][A-Z]{0,1}|[5-9OUX][A-Z][A-Z]{0,1})([0-9][0-9A-Z]{0,3}[A-Z])|([ACDLP][2-9A-Z][A-Z]{0,1}|E[2-7A-Z][A-Z]{0,1}|H[2-46-9A-Z][A-Z]{0,1}|[JTV][2-8A-Z][A-Z]{0,1}|S[2-35-9A-RT-Z][A-Z]{0,1}|Y[2-9A-Y][A-Z]{0,1}|Z[238A-Z][A-Z]{0,1})([0-9A-Z]{0,3}[A-Z]))
$
```

If you expand the regex string to make it human readable, you'll see some of the optimized matching. Note that most regex libaries will optimize this much further when compiled.

```
    (
        (
            [2BFGIKMNRW][A-Z]{0,2}|
            3[A-CE-Z][A-Z]{0,1}|
            4[A-MO-Z][A-Z]{0,1}|
            [5-9OUX][A-Z][A-Z]{0,1}
        )
        (
            [0-9][0-9A-Z]{0,3}[A-Z]
        )
    |
        (
            [ACDLP][2-9A-Z][A-Z]{0,1}|
            E[2-7A-Z][A-Z]{0,1}|
            H[2-46-9A-Z][A-Z]{0,1}|
            [JTV][2-8A-Z][A-Z]{0,1}|
            S[2-35-9A-RT-Z][A-Z]{0,1}|
            Y[2-9A-Y][A-Z]{0,1}|
            Z[238A-Z][A-Z]{0,1}
        )(
            [0-9A-Z]{0,3}[A-Z]
        )
    )

```

## Usage

```bash
$ callsign-regex --help
callsign-regex [-h] [-V] [-v] [-F] [-R] [-f] [-r]

Produce a valid optimized regex from the ITU Table of International Call Sign Series (Appendix 42 to the RR). Based on https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx

options:
  -h, --help     show this help message and exit
  -V, --version  dump version number
  -v, --verbose  verbose output
  -F, --force    force rebuild of cached regex
  -R, --regex    dump regex (to be used in code)
  -f, --forward  dump table (showing callsign to country table)
  -r, --reverse  dump reverse table (showing country to callsign table)
$
```

## Producing tables

To show the mapping of callsign to country:

```bash
$ callsign-regex -d
2          : GB/United Kingdom of Great Britain and Northern Ireland (the)
3A         : MC/Monaco
3B         : MU/Mauritius
3C         : GQ/Equatorial Guinea
3D[A-M]    : SZ/Eswatini
3D[N-Z]    : FJ/Fiji
...
$

```

To show the mapping of country to callsign:

```bash
$ callsign-regex -r
AD/Andorra                                                             : C3
AE/United Arab Emirates (the)                                          : A6
AF/Afghanistan                                                         : T6,YA
AG/Antigua and Barbuda                                                 : V2
AL/Albania                                                             : ZA
AM/Armenia                                                             : EK
...
$
```

The same output can be produced in code:
```python
from itu_appendix42 import ItuAppendix42

ituappendix42 = ItuAppendix42()
print(ItuAppendix42._regex)
```

The resulting regex can be used via many languages to pattern match a ham radio callsign correctly.

## Example code (in Python)

```python
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
```

The file `example1.py` on github is this code.

## Fetch new data files from the ITU (to freshen the version kept in the code)

The official database is kept by the ITU. It is called the Table of International Call Sign Series (Appendix 42 to the RR).

Hence, based on the page 
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx)
visit this specific page in a browser on your system
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx)
and download via the somewhat small `.xlsx` button. This produces a file like this in your Download directory/folder:
```
    CallSignSeriesRanges-959674f2-22a8-4eb5-aa67-9df4fd606158.xlsx
```
Your downloaded filename will be different (a different set of numbers - but the same filename format - that's fine.

This package looks for the newest file of that name pattern in your `Downloads` directory/folder, so don't worry if you have  more than one file downloaded there.
Under windows the download is placed at `C:\Users\YourUsername\Downloads\` and under Linux or MacOS it's in `~/Downloads`.

A quick run of the program will read in the downloaded file and update the caches values for the regex.

