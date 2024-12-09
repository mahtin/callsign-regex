# callsign-regex
Python code to build a current regex for all ham radio callsigns

## Install

```bash
$ pip install callsign-regex
```

## Fetch the data files from the ITU (very important)

Based on the page 
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx)
visit this page in a browser on your system
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx)
and download via the somewhat small `.xlsx` button. This produces a file like this in your Download directory/folder:
```
    CallSignSeriesRanges-959674f2-22a8-4eb5-aa67-9df4fd606158.xlsx
```
Your UUID part will be different.

This package looks for the newest file of that name pattern in your `Downloads` directory/folder, so don't worry about more than one file is downloaded.
Under windows that's `C:\Users\YourUsername\Downloads\` and under Linux or MacOS it's `~/Downloads`.

## Producing a regex

```bash
$ callsign-regex -R
```

The resulting output is the regex to match all ham radio callsigns:
```
([2BFGIKMNRW][A-Z]{0,2}|3[A-CE-Z][A-Z]{0,1}|4[A-MO-Z][A-Z]{0,1}|5[A-Z][A-Z]{0,1}|6[A-Z][A-Z]{0,1}|7[A-Z][A-Z]{0,1}|8[A-Z][A-Z]{0,1}|9[A-Z][A-Z]{0,1}|A[2-9A-Z][A-Z]{0,1}|C[2-9A-Z][A-Z]{0,1}|D[2-9A-Z][A-Z]{0,1}|E[2-7A-Z][A-Z]{0,1}|H[2-46-9A-Z][A-Z]{0,1}|J[2-8A-Z][A-Z]{0,1}|L[2-9A-Z][A-Z]{0,1}|O[A-Z][A-Z]{0,1}|P[2-9A-Z][A-Z]{0,1}|S[2-35-9A-RT-Z][A-Z]{0,1}|T[2-8A-Z][A-Z]{0,1}|U[A-Z][A-Z]{0,1}|V[2-8A-Z][A-Z]{0,1}|X[A-Z][A-Z]{0,1}|Y[2-9A-Y][A-Z]{0,1}|Z[238A-Z][A-Z]{0,1})([0-9][0-9A-Z]{0,3}[A-Z])
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

