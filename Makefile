#
# Copyright (C) 2024 Martin J Levy - W6LHI/G8LHI - @mahtin - https://github.com/mahtin
#

PYTHON = python
PIP = pip
PYLINT = pylint
TWINE = twine

NAME = "callsign-regex"
NAME_ = "callsign_regex"

PACKAGE1 = "itu-appendix42"
PACKAGE2 = "callsign_regex"

all: CHANGELOG.md examples
	${FORCE}

CHANGELOG.md: FORCE
	@tmp=/tmp/_$$$$.md ; \
	( \
		cp /dev/null $$tmp ; \
		echo '# Change Log' ; \
		echo '' ; \
		git log --date=iso-local --pretty=format:' - %ci [%h](../../commit/%H) %s' ; \
		echo '' ; \
	)  >> $$tmp ; \
	diff $$tmp CHANGELOG.md || ( cp $$tmp CHANGELOG.md ; echo "CHANGELOG.md - updated" ) ; \
	rm $$tmp
FORCE:

build: setup.py
	$(PYTHON) setup.py -q build
lint:
	${PYLINT} --unsafe-load-any-extension=y ${PACKAGE1}/*.py ${PACKAGE2}/*.py example1.py

clean:
	rm -rf build dist
	mkdir build dist
	$(PYTHON) setup.py clean
	rm -rf build dist
	rm -rf ${NAME_}.egg-info

test: all
	${FORCE}

sdist: all
	# make clean
	# make test
	$(PYTHON) setup.py sdist
	@ v=`ls -t dist/${NAME}-*.tar.gz | head -1` ; w=`echo $$v | sed -e 's/-/_/'` ; echo mv $$v $$w ; mv $$v $$w 
	@ v=`ls -t dist/${NAME_}-*.tar.gz | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ rm -rf ${NAME_}.egg-info

bdist: all
	# make clean
	# make test
	${PIP} wheel . -w dist --no-deps
	@ v=`ls -t dist/${NAME_}-*-py2.py3-none-any.whl | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ rm -rf ${NAME_}.egg-info

showtag: sdist
	@ v=`ls -t dist/${NAME_}-*.tar.gz | head -1 | sed -e "s/dist\/${NAME_}-//" -e 's/.tar.gz//'` ; echo "\tDIST VERSION =" $$v ; (git tag | fgrep -q "$$v") && echo "\tGIT TAG EXISTS"

tag: sdist
	@ v=`ls -t dist/${NAME_}-*.tar.gz | head -1 | sed -e "s/dist\/${NAME_}-//" -e 's/.tar.gz//'` ; echo "\tDIST VERSION =" $$v ; (git tag | fgrep -q "$$v") || git tag "$$v"

upload: clean all tag upload-github upload-pypi

upload-github:
	git push
	git push origin --tags

upload-pypi: sdist bdist
	@ v=`ls -t dist/${NAME_}-*.tar.gz | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	@ v=`ls -t dist/${NAME_}-*-py2.py3-none-any.whl | head -1` ; echo $(TWINE) check $$v ; $(TWINE) check $$v
	${TWINE} upload --repository ${NAME} `ls -t dist/${NAME_}-*.tar.gz|head -1` `ls -t dist/${NAME_}-*-py2.py3-none-any.whl|head -1`

docs: all
	sphinx-apidoc -Mfe -o docs . setup.py
	sphinx-build -j auto -b html docs docs/_build/html

#
# Examples
#
examples: examples/clang-example examples/python_example.py

clean-docs: all
	rm -rf docs/*.rst docs/_build/

