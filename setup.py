""" callsign-regex

Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
"""

import re
from distutils.core import setup

with open('itu_appendix42/__init__.py', 'r') as f:
    _version_re = re.compile(r"__version__\s=\s'(.*)'")
    version = _version_re.search(f.read()).group(1)

with open('README.md') as f:
    long_description = f.read()

setup(
    name = 'callsign-regex',
    packages = ['itu_appendix42', 'callsign_regex'],
    #package_dir = {'itu_appendix42': 'itu_appendix42'},
    package_data = {'itu_appendix42': ['resources/*.xlsx']},
    version = version,
    license = 'OSI Approved :: MIT License',
    description = 'Match ham radio callsigns based on ITU appendix42',
    long_description = long_description,
    long_description_content_type = 'text/markdown',
    author = 'Martin J Levy',
    author_email = 'mahtin@mahtin.com',
    url = 'https://github.com/mahtin/callsign-regex',
    download_url = 'https://github.com/mahtin/callsign-regex/archive/refs/tags/%s.tar.gz' % version,
    keywords = ['Ham Radio', 'Callsign', 'ITU', 'Appendix42'],
    install_requires = ['openpyxl'],
    options = {'bdist_wheel': {'universal': True}},
    include_package_data = True,
    entry_points = {'console_scripts': ['callsign-regex=callsign_regex.__main__:main']},
    python_requires='>=3.7',

    classifiers = [
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Topic :: Communications :: Ham Radio',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
    ],
)
