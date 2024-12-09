#
# Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
#

PYTHON = python
PIP = pip
PYLINT = pylint
TWINE = twine

NAME = "itu_appendix42"
NAME_ = "itu_appendix42"

all:
	${FORCE}

lint:
	${PYLINT} --unsafe-load-any-extension=y ${NAME}/*.py callsign-regex.py example1.py

clean:
	rm -rf build dist
	mkdir build dist
	$(PYTHON) setup.py clean
	rm -rf ${NAME_}.egg-info

test: all
	${FORCE}

sdist: all
	# make clean
	# make test
	$(PYTHON) setup.py sdist
	@ v=`ls -t dist/${NAME}-*.tar.gz | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ rm -rf ${NAME_}.egg-info build

bdist: all
	${PIP} wheel . -w dist --no-deps
	@ v=`ls -t dist/${NAME_}-*-py2.py3-none-any.whl | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ rm -rf ${NAME_}.egg-info build

showtag: sdist
	@ v=`ls -t dist/${NAME}-*.tar.gz | head -1 | sed -e "s/dist\/${NAME}-//" -e 's/.tar.gz//'` ; echo "\tDIST VERSION =" $$v ; (git tag | fgrep -q "$$v") && echo "\tGIT TAG EXISTS"

tag: sdist
	@ v=`ls -t dist/${NAME}-*.tar.gz | head -1 | sed -e "s/dist\/${NAME}-//" -e 's/.tar.gz//'` ; echo "\tDIST VERSION =" $$v ; (git tag | fgrep -q "$$v") || git tag "$$v"

upload: clean all tag upload-github upload-pypi

upload-github:
	git push
	git push origin --tags

upload-pypi: sdist bdist
	@ v=`ls -t dist/${NAME}-*.tar.gz | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ v=`ls -t dist/${NAME_}-*-py2.py3-none-any.whl | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	${TWINE} upload --repository ${NAME} `ls -t dist/${NAME}-*.tar.gz|head -1` `ls -t dist/${NAME_}-*-py2.py3-none-any.whl|head -1`


docs: all
	sphinx-apidoc -Mfe -o docs . setup.py
	sphinx-build -j auto -b html docs docs/_build/html

clean-docs: all
	rm -rf docs/*.rst docs/_build/

