###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

#This file implements the FiniteDifferenceSystemList class
# It basically is a list of FiniteDifferenceSystem
# It thus inherits from the list class

# The FiniteDifferenceSystemList object is the list of all differential systems to be solved over the different areas

load(os.path.join(os.path.expanduser(EscapadeInstallDir),'FiniteDifferenceSystem.sage'))

class FiniteDifferenceSystemList(list):

	#It constructs as a list
	#Each item will be constructed itself with the FiniteDifferenceSystem constructor
	def __init__(self,l):
		list.__init__(self,map(FiniteDifferenceSystem,l))
	#The representation __repr__ of class list will do the printing job

	def neighborhood(self,vlist):
		"""Neighborhhod(v) parses self to compute its neighborhood in terms of the function list argument.
		This neighborhood is the union of all neighborhoods
		"""
		n=Pattern([])
		for p in self:
			n.extend(p.neighborhood(vlist))
		return(n.set_ify())

	
	def dependency(self,v):
		"""The dependency is the convolution of a neighborhood by its opposite.
		This is purely numerical array manipulation and could be compiled using spyx files.
		We will not do it because it belongs to the FiniteDifference class which is not compiled.
		Unless there is a solution to do it nonetheless.	
		"""
		dep=Pattern([])
		n=self.neighborhood(v)	
		for i in n:
			for j in n:
				dep.append(vecteurs.diffv(i,j))
		return (dep.set_ify())

	def simplify(self):
		systemlist=[]
		for system in self:
			systemlist.append(system.simplify())
		return(systemlist)


