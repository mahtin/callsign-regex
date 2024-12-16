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
((2[A-Z]{1,2}|[BFGIKMNRW][A-Z]{0,2}|3[A-CE-Z][A-Z]{0,1}|4[A-MO-Z][A-Z]{0,1}|[5-9OUX][A-Z][A-Z]{0,1})([0-9][0-9A-Z]{0,3}[A-Z])|([ACDLP][2-9A-Z][A-Z]{0,1}|E[2-7A-Z][A-Z]{0,1}|H[2-46-9A-Z][A-Z]{0,1}|[JTV][2-8A-Z][A-Z]{0,1}|S[2-35-9A-RT-Z][A-Z]{0,1}|Y[2-9A-Y][A-Z]{0,1}|Z[238A-Z][A-Z]{0,1})([0-9A-Z]{0,3}[A-Z]))
$
```

If you expand the regex string to make it human readable, you'll see some of the optimized matching. Note that most regex libaries will optimize this much further when compiled.

```
    (
        (
            2               [A-Z]{1,2}         |
            [BFGIKMNRW]     [A-Z]{0,2}         |
            3[A-CE-Z]       [A-Z]{0,1}         |
            4[A-MO-Z]       [A-Z]{0,1}         |
            [5-9OUX][A-Z]   [A-Z]{0,1}
        )
        (
            [0-9][0-9A-Z]{0,3}[A-Z]
        )
    |
        (
            [ACDLP]         [2-9A-Z][A-Z]{0,1} |
            E[2-7A-Z]       [A-Z]{0,1}         |
            H[2-46-9A-Z]    [A-Z]{0,1}         |
            [JTV][2-8A-Z]   [A-Z]{0,1}         |
            S[2-35-9A-RT-Z] [A-Z]{0,1}         |
            Y[2-9A-Y]       [A-Z]{0,1}         |
            Z[238A-Z]       [A-Z]{0,1}
        )
        (
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
print(ItuAppendix42.regex())
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

The file `examples/python_example.py` is on github (and is based on this code).

## Example code (in C)

```c
    char *callsign_regex;
    regex_t re;
    regmatch_t rm[1];

    callsign_regex = "<<INSERT FROM ABOVE OR READ IN FROM FILE>>";

    if (regcomp(&re, callsign_regex, REG_EXTENDED) != 0) {
        // bail!
    }

    char line[1024+1];
    while ((fgets(line, 1024, stdin)) != NULL) {
    if (regexec(&re, line, N_RM, rm, 0) != 0) {
        // bail!
    }
```

The file `examples/clang-example.c` is on github and contains fully working code with full error checking ability.

## Notes on ITU callsign Appendix 42

According to the [ITU](https://en.wikipedia.org/wiki/ITU_prefix) Wikipedia page, the following is a key issue when building a regex.

> With regard to the second and/or third letters in the prefixes in the list below,
> if the country in question is allocated all callsigns with A to Z in that position,
> then that country can also use call signs with the digits 0 to 9 in that position.
> For example, the United States is assigned KA–KZ, and therefore can also use prefixes like K1 or K9.

To clarify, the US is allocated the series `KAA - KAZ` `KBA - KBZ` ... `KZA - KZZ` and in that situation the normal regex would be `K[A-Z][A-Z]`; however, this text above allows `K[A-Z]{0-2}`.

This means that when parsing the ITU information you can drop the trailing letters from the search in this situation.
So far, I've not found this exact description of this rule within an ITU document; however, it's obvious that it is correct.

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

