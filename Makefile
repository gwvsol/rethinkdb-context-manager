.PHONY: help release requirements clean install

#==========================================
VENV_NAME?=venv
ENV=.env
VENV_ACTIVATE=. ${VENV_NAME}/bin/activate
PYTHON=${VENV_NAME}/bin/python3
PIP=${VENV_NAME}/bin/pip3
PWD=$(shell pwd)
RELEASE=release
SETUP=setup.py
DEPENDENCES=requirements.txt
include ${ENV}
SOURCE=rethinkdbcm
#==========================================

.DEFAULT: help

help:
	@echo "make release	- Start Redis in Docker"
	@echo "make requirements	- Stopping Redis in Docker"
	@echo "make install	- Output of logs for Redis in Docker"
	@echo "make clean	- Deleting a Redis in Docker"

#=============================================
# Установка зависимостей для разработки приложения
requirements:
	[ -d $(VENV_NAME) ] || python3 -m $(VENV_NAME) $(VENV_NAME)
	${PIP} install pip wheel -U
	${PIP} install -r ${DEPENDENCES}

#=============================================
# Активация виртуального окружения для работы приложений
venv: ${VENV_NAME}/bin/activate
$(VENV_NAME)/bin/activate: ${SETUP}
	[ -d $(VENV_NAME) ] || python3 -m $(VENV_NAME) $(VENV_NAME)
	${PIP} install -U pip
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
install: ${RELEASE}
	${PIP} install ${RELEASE}/${SOURCE}-*.tar.gz
# Удаление виртуального окружения для работы приложений
uninstall:
	make clean
	rm -fr venv

#=============================================
# Создание релиза приложения
release: clean-release ${SOURCE} venv
	mkdir ${RELEASE}
	${PYTHON} ${SETUP} sdist bdist_wheel
	zip -r ${RELEASE}/${SOURCE}-$(shell date '+%Y-%m-%d').zip \
	${SOURCE} ${ENV} Makefile *.md *.in *.txt *.py LICENSE .gitignore
	make clean
#=============================================
