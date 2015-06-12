###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

# This file implements the FiniteDifferenceSystem class
# It basically is a list of FiniteDifference
# It thus inherits from the list class

# Each FiniteDifferenceSystem object is one differential system to be solved on one point or one area


load(os.path.join(os.path.expanduser(EscapadeInstallDir),'FiniteDifference.sage'))

class FiniteDifferenceSystem(list):

	#It constructs as a list
	#Each item will be constructed itself with the FiniteDifference constructor
	def __init__(self,l):
		list.__init__(self,map(FiniteDifference,l))
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
		
	def squared_norm(self):
		"""Returns the squared norm of the system: i.e. the sum of all squared components
		"""
		norm=0
		for equ in self:
			norm+=equ**2
		return norm
		
	def translation(self,v,flist):
		"""The translation(v,flist) method translates by the amount of v the arguments of all the function appearing both in the elements of self and in flist.
		"""
		system=[]
		for equ in self:
			system.append(equ.translation(v,flist))
		return FiniteDifferenceSystem(system)
		
	def diff(self,x):
		"""Differentiation of the elements of the list.
		"""
		diff=[]
		for eq in self:
			diff.append(eq.diff(x))
		return diff
	
	def cform(self):
		"""Applies a set of rules to comply with booz and C.
		"""
		return FiniteDifferenceSystem(sageobj(maxima('cform('+self.__repr__()+')')))
		
	def localize(self,args,flist):
		"""In Self, applies all functions of flist to args.
		"""
		return FiniteDifferenceSystem(sageobj(maxima('localize('+self.__repr__()+','+flist.__repr__()+','+list(args).__repr__()+')')))
	def simplify(self):
		system=[]
		for equ in self:
			system.append(equ.simplify())
		return(system)

