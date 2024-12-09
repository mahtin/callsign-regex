# callsign-regex
Python code to build a current regex for all ham radio callsigns

## Fetch the data files

Based on the page 
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/glad.aspx)
visit this page
[https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx](https://www.itu.int/en/ITU-R/terrestrial/fmd/Pages/call_sign_series.aspx)
and download via the `.xlsx` button and produce a file like this:
```
    CallSignSeriesRanges-959674f2-22a8-4eb5-aa67-9df4fd606158.xlsx
```
Your UUID part will be different.  This code looks for the newest file of that name pattern in your `Downloads` directory/folder, so don't worry about more than one file is downloaded.
Under windows that's `C:\Users\YourUsername\Downloads\` and under Linux or MacOS it's `~/Downloads`.

## Producing a rexex

```bash
$ python callsign_regex.py -R
```

The resulting output is the regex to match all ham radio callsigns:
```
([2BFGIKMNRW][A-Z]{0,2}|3[A-CE-Z][A-Z]{0,1}|4[A-MO-Z][A-Z]{0,1}|5[A-Z][A-Z]{0,1}|6[A-Z][A-Z]{0,1}|7[A-Z][A-Z]{0,1}|8[A-Z][A-Z]{0,1}|9[A-Z][A-Z]{0,1}|A[2-9A-Z][A-Z]{0,1}|C[2-9A-Z][A-Z]{0,1}|D[2-9A-Z][A-Z]{0,1}|E[2-7A-Z][A-Z]{0,1}|H[2-46-9A-Z][A-Z]{0,1}|J[2-8A-Z][A-Z]{0,1}|L[2-9A-Z][A-Z]{0,1}|O[A-Z][A-Z]{0,1}|P[2-9A-Z][A-Z]{0,1}|S[2-35-9A-RT-Z][A-Z]{0,1}|T[2-8A-Z][A-Z]{0,1}|U[A-Z][A-Z]{0,1}|V[2-8A-Z][A-Z]{0,1}|X[A-Z][A-Z]{0,1}|Y[2-9A-Y][A-Z]{0,1}|Z[238A-Z][A-Z]{0,1})([0-9][0-9A-Z]{0,3}[A-Z])
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

