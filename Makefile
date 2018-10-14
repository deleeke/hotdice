DATE		= $(shell date)
PYTHON		= $(shell which python)

TOPDIR = $(shell pwd)
DIRS	= test bin locale src
PYDIRS	= hotdice

BINDIR  = bin

OMIT_PATTERNS = */test*.py,*/manage.py,*/apps.py,*/wsgi.py,*/settings.py,*/migrations/*,*/docs/*,*/client/*,*/deploy/*

help:
	@echo "Please use \`make <target>' where <target> is one of:"
	@echo "  help           to show this message"
	@echo "  all            to to execute all following targets (except test)"
	@echo "  lint           to run all linters"
	@echo "  lint-flake8    to run the flake8 linter"
	@echo "  lint-pylint    to run the pylint linter"
	@echo "  test           to run unit tests"
	@echo "  test-coverage  to run unit tests and measure test coverage"
	@echo "  swagger-valid  to run swagger-cli validation"
	@echo "  server-init    to run server initializion steps"
	@echo "  serve          to run the server"
	@echo "  manpage        to build the manpage"
	@echo "  html           to build the docs"

all: lint test-coverage

install: build
	$(PYTHON) setup.py install -f

test:
	$(PYTHON) hotdice/manage.py test -v 2 hotdice/

test-coverage:
	coverage run --source=hotdice/,qpc/ hotdice/manage.py test -v 2 hotdice/ qpc/
	coverage report -m --omit $(OMIT_PATTERNS)

lint-flake8:
	flake8 . --ignore D203 --exclude hotdice/api/migrations,docs,build,.vscode,client,venv,deploy

lint-pylint:
	find . -name "*.py" -not -name "*0*.py" -not -path "./build/*" -not -path "./docs/*" -not -path "./.vscode/*" -not -path "./client/*" -not -path "./venv/*" -not -path "./deploy/*" | xargs $(PYTHON) -m pylint --load-plugins=pylint_django --disable=duplicate-code

format:
	black hotdice

lint: format lint-flake8 lint-pylint

server-makemigrations:
	$(PYTHON) hotdice/manage.py makemigrations --settings hotdice.settings

server-migrate:
	$(PYTHON) hotdice/manage.py migrate --settings hotdice.settings -v 3

server-set-superuser:
	echo "from django.contrib.auth.models import User; admin_not_present = User.objects.filter(email='admin@example.com').count() == 0;User.objects.create_superuser('admin', 'admin@example.com', 'pass') if admin_not_present else print('admin present');print(User.objects.filter(email='admin@example.com'))" | $(PYTHON) hotdice/manage.py shell --settings hotdice.settings -v 3

server-init: server-makemigrations server-migrate server-set-superuser

clean:
	rm -rf hotdice.egg-info
	PYCLEAN_PLACES=${PYCLEAN_PLACES:-'.'}
	find ${PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
	find ${PYCLEAN_PLACES} -type d -name "__pycache__" -delete

serve:
	$(PYTHON) hotdice/manage.py runserver

.PHONY: clean lint format lint-flak8 lint-pylint serve server-init all install test test-coverage
