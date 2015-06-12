###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#       Copyright (C) 2009 Hubert Frauensohn <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################
#!/usr/local/sage-4.0.1/local/bin/python2.5
# -*- coding: cp1252 -*-
# compilation: /usr/local/sage-4.0.1/local/bin/python2.5 setup.py build_ext --inplace
# or ./makemodule
from distutils.core import setup
from distutils.core import Extension
setup(name = 'vecteurs',
#version = '1.0',
ext_modules = [Extension('vecteurs', ['vecteurs.c']) ],
#url='localhost',
#author='Hub',
#author_email='@',
)

 
