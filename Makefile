DATE		= $(shell date)
PYTHON		= $(shell which python)

TOPDIR = $(shell pwd)
DIRS	= test bin locale src
PYDIRS	= games

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

install-dev:
	pip install -e.

test:
	$(PYTHON) games/manage.py test -v 2 games/

test-coverage:
	coverage run --source=games/,qpc/ games/manage.py test -v 2 games/ qpc/
	coverage report -m --omit $(OMIT_PATTERNS)

lint-flake8:
	flake8 . --ignore D203 --exclude games/api/migrations

format:
	black games

lint: lint-flake8

server-makemigrations:
	$(PYTHON) games/manage.py makemigrations --settings games.settings

server-migrate:
	$(PYTHON) games/manage.py migrate --settings games.settings -v 3

server-set-superuser:
	echo "from django.contrib.auth.models import User; admin_not_present = User.objects.filter(email='admin@example.com').count() == 0;User.objects.create_superuser('admin', 'admin@example.com', 'pass') if admin_not_present else print('admin present');print(User.objects.filter(email='admin@example.com'))" | $(PYTHON) games/manage.py shell --settings games.settings -v 3

server-init: server-makemigrations server-migrate server-set-superuser

clean:
	rm -rf games.egg-info
	PYCLEAN_PLACES=${PYCLEAN_PLACES:-'.'}
	find ${PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
	find ${PYCLEAN_PLACES} -type d -name "__pycache__" -delete

serve:
	$(PYTHON) games/manage.py runserver

.PHONY: clean lint format lint-flak8 lint-pylint serve server-init all install test test-coverage
