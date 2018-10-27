#!/usr/bin/env python
# coding=utf-8
"""A setuptools-based script for installing hotdice."""
import os
import sys
from setuptools import setup, find_packages

BASE_QPC_DIR = os.path.abspath(
    os.path.normpath(os.path.join(os.path.dirname(sys.argv[0]), "."))
)
sys.path.insert(0, os.path.join(BASE_QPC_DIR, "hotdice"))
# pylint: disable=wrong-import-position

setup(
    name="hotdice",
    python_requires=">=3.5",
    version="0.0.1",
    author="HotDice Team",
    author_email="deleeke@gmail.com",
    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=["License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
    include_package_data=True,
    license="GPLv3",
    packages=find_packages(exclude=["test*.py"]),
    package_data={"": ["LICENSE"]},
    url="https://github.com/deleeke/hotdice",
    zip_safe=False,
    install_requires=["django", "coverage", "pylint-django", "flake8", "black"],
)
