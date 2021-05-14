.PHONY: help release requirements clean install

#==========================================
VENV_NAME?=venv
ENV=.env
VENV_ACTIVATE=. ${VENV_NAME}/bin/activate
PYTHON=${VENV_NAME}/bin/python3
PIP=${VENV_NAME}/bin/pip3
PYCODESTYLE=${VENV_NAME}/bin/pycodestyle
TWINE=${VENV_NAME}/bin/twine
PWD=$(shell pwd)
RELEASE=release
SETUP=setup.py
DEPENDENCES=requirements.txt
DEPENDENCESDEV=requirements-dev.txt
include ${ENV}
SOURCE=rethinkdbcm
#==========================================

.DEFAULT: help

help:
	@echo "make release	- Build a release"
	@echo "make requirements	- Installing dependencies"
	@echo "make install	- Installing the assembled package"
	@echo "make uninstall	- Deleting a virtual environment, dependencies, and a built package"
	@echo "make check	- Checking the correctness of the code writing"
	@echo "make clean	- Cleaning up garbage"
	@echo "make clean-release - Deleting an old release"
	@echo "make upload	- Uploading a release to PyPi"              

#=============================================
# Установка зависимостей для разработки приложения
requirements:
	[ -d $(VENV_NAME) ] || python3 -m $(VENV_NAME) $(VENV_NAME)
	${PIP} install pip wheel -U
	${PIP} install -r ${DEPENDENCES}
	${PIP} install -r ${DEPENDENCESDEV}

#=============================================
# Активация виртуального окружения для работы приложений
venv: ${VENV_NAME}/bin/activate
$(VENV_NAME)/bin/activate: ${SETUP}
	[ -d $(VENV_NAME) ] || python3 -m $(VENV_NAME) $(VENV_NAME)
	${PIP} install pip wheel -U
	${PIP} install -e .
	${VENV_ACTIVATE}

#=============================================
# Очистка мусора
clean:
	rm -fr build
	rm -fr .eggs
	rm -fr *.egg-info
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-release: clean
	rm -fr dist
	rm -fr ${RELEASE}

#=============================================
# Установка зависимостей для работы приложений
install: venv dist
	${PIP} install dist/${SOURCE}-*.tar.gz

# Удаление виртуального окружения для работы приложений
uninstall:
	make clean
	rm -fr venv

# Проверка корректности написания кода Python
check: ${PYCODESTYLE} ${SOURCE}
	@echo "==================================="
	${PYCODESTYLE} ${SOURCE} ${SETUP}
	@echo "=============== OK! ==============="

# Upload кода Python на PyPi
upload: ${TWINE} dist
	@echo "==================================="
	${TWINE} upload dist/*
	@echo "=============== OK! ==============="

#=============================================
# Создание релиза приложения
release: clean-release ${SOURCE}
	mkdir ${RELEASE}
	${PYTHON} ${SETUP} sdist bdist_wheel
	make clean
	zip -r ${RELEASE}/${SOURCE}-$(shell date '+%Y-%m-%d').zip \
	${SOURCE} ${ENV} Makefile *.md *.in *.txt *.py LICENSE .gitignore
#=============================================
