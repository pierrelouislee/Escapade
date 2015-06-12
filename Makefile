###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009-2010 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

#!/bin/bash

VERSION = 1.2

DIST_NAME = escabooz.sage

PYTHON = sage
SETUP = setup.py
SETUPOPTIONS = build_ext --inplace
#DISTDIR = /home/fresseng/Documents/HTML/Escapade
RELEASEDIR= ../releases
INSTALLDIR= ~/.escapade
SAGEDIR=~/.sage

#SUFFIXES ?= .so
#.SUFFIXES: $(SUFFIXES)

FILES = \
	dd.sage \
	disloc.sage \
	Escapade.sage \
	FiniteDifference.sage \
	FiniteDifferenceSystemList.sage \
	FiniteDifferenceSystem.sage \
	escapade_utils.spyx \
	Mesh.spyx \
	Pattern.spyx \
	tobooz.spyx \
	tosimpf.spyx \
	vecteurs.c \
	setup.py \
	Makefile \
	EscapadeSageInit.sage

OBJ_FILES = vecteurs.so


help : 
	@echo "  "
	@echo "  "
	@echo "Available commands :"
	@echo "  "
	@echo "dist	:	creates the tar.gz distribution"
	@echo "install	:	builds and install in your .sage"
	@echo "uninstall:	removes files from your .sage"
	@echo "clean	:	remove objects files"
	@echo "  "
	@echo "  "

dist :
	@mkdir $(DIST_NAME).$(VERSION)
	@cp $(FILES) $(DIST_NAME).$(VERSION)
	@tar zcvf $(DIST_NAME).$(VERSION).tar.gz $(DIST_NAME).$(VERSION)
	@rm -rf $(DIST_NAME).$(VERSION)
	#@cp $(DIST_NAME).$(VERSION).tar.gz $(DISTDIR)/
	@mv $(DIST_NAME).$(VERSION).tar.gz $(RELEASEDIR)/
	

module : 
	@make vecteurs.so

vecteurs.so : vecteurs.c $(SETUP)
	$(PYTHON) $(SETUP) $(SETUPOPTIONS) 

install : 
	@make module
	@if [ ! -d $(INSTALLDIR) ]; then \
		mkdir $(INSTALLDIR); \
	fi	
	@cp *.sage $(INSTALLDIR)/
	@cp *.spyx $(INSTALLDIR)/
	@cp *.so $(INSTALLDIR)/
	@cat EscapadeSageInit.sage > $(SAGEDIR)/init.sage

uninstall :
	@if [ ! -d $(INSTALLDIR) ]; then \
		echo "Escapade not installed"; \
	else \
		rm -r $(INSTALLDIR)/*; \
		touch $(INSTALLDIR)/Escapade.sage; \
	fi

clean :
	@rm *.so
	
