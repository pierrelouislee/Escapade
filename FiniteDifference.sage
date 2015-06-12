###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

#This file implements the finite_difference class
#The FiniteDifference class is
## based on the SymbolicArithmetic class
## useful to find neighborhood or dependency
#An instance of this class is the description of the equation te be solved
#I do not believe it can be either compiled or parallelized
#
#File FiniteDifference.sage
#Author : Nicolas Fressengeas
#
# Each FiniteDifference object is one equation


def neighborhood_two(expr,v):
	"""neighorood_two(expr,v) parses espr to compute its neigborhood in terms of v.
	The neighborhhod in terms of v is a matrix of all the arguments of v appearing in self.
	Does the same as neigborhood_one though with sage rather that maxima.
	"""
	if expr.operator()==None:
		return []
	elif expr.operator()==v:
		return vector(expr.operands())
	else:
		return list(neighborhood_two(i,v) for i in expr.operands())




class FiniteDifference(Expression):
	#__init__ instances the class as SymbolicArithmetic, sustracting rhs to lhs of equation if necessary
	def __init__(self,eq):
		eq=SR(eq)
		if eq.is_relational():
			Expression.__init__(self,SR,eq.left()-eq.right())
		else:
			Expression.__init__(self,SR,eq)
		#start maxima and define a function used for the neighborhood
		#To my opinion, the following should work. Howeverer recursivity does not work
		#self.get_neighbors=maxima.function('f,v','( local_neighbors(x):=get_neighbors(x,v), if atom(f) then [] elseif op(f)=v then args(f) else map(local_neighbors,args(f)) )')
		#However, we can do it in Maxima directly
		#maxima('get_neighbors_f(f,v):=(local_neighbors(x):=get_neighbors_f(x,v), if atom(f) then [] elseif op(f)=v then (f) else map(local_neighbors,args(f)))')
		#maxima('get_neighbors(f,v):=map(args,flatten(get_neighbors_f(f,v)))')
		#Another maxima function is need to translate the arguments of a given list of functions
		#The commented ont is written recursively
		#The other one is done using pattern matching
		#It is hopefully faster
		#maxima('translate(expr,flist,v):=(translation(x):=translate(x,flist,v), if atom(expr) then expr elseif member(op(expr),flist) then apply(op(expr),args(expr)+v) else apply(op(expr),map(translation,args(expr))) )')
		#maxima('translate(expr,listf,v):=(matchdeclare(ff,lambda([x],if atom(x) then false else member(op(x),listf)),gg,lambda([x],if atom(x) then false else op(x)=booz)),defrule(r1,ff,booz[op(ff),args(ff)+v]),defrule(r2,gg,apply(args(gg)[1],args(gg)[2])),apply1(expr,r1,r2))')
		# a cform function to apply a set of rules to comply with the requirements of booz and C
		#maxima('cform(expr,maxlength):=(matchdeclare(ffc,true,eec,lambda([x],(x#1 and x#0)),fftmp,lambda([x],if  atom(x) then false else (member(op(x),["+","*"]) and length(args(x))>maxlength))),defrule(rc,ffc^eec,pow(ffc,eec)),defrule(rtmp,fftmp,simpftmpiter(op(fftmp),args(fftmp))),apply1(expr,rc,rtmp))')
		maxima('cform(expr,maxargs):=(matchdeclare(ffc,true,eec,lambda([x],(x#1 and x#0)),fcplx,lambda([f],if atom(f) then false else (length(args(f))>maxargs))),defrule(rc,ffc^eec,pow(ffc,eec)),defrule(rcplx,fcplx,simpfarobas(fcplx)),applyb1(expr,rc,rcplx))')
		#maxima('localize(expr,flist,args):=(matchdeclare(ff,lambda([x],(member(x,flist)))),defrule(r,ff,apply(ff,args)),apply1(expr,r))')
	
#	def __repr__(self):
#		return SymbolicArithmetic.__repr__(self)
	
			
	
	def neighborhood_one(self,v):
		"""Neighorood_one(v) parses self to compute its neigborhood in terms of v.
		The neighborhhod in terms of v is a matrix of all the arguments of v appearing in self.
		This is done using maxima since sage cannot (yet?) do it.
		"""
		#n=Pattern(sageobj(maxima('get_neighbors('+self.__repr__()+','+v.__repr__()+')')))
		#This should work but maxima hangs
		#The follwong works but is supposedly slower and maxima.eval is supposedly less stable
		n=Pattern(sage_eval(maxima.eval('get_neighbors('+self.__repr__()+','+v.__repr__()+')')))
		#This matrix can contain several identical lines
		#This makes ne sense in terms of patterns and has to be removed
		#return(n.set_ify())
		return (n)
		
	def neighborhood(self,vlist):
		"""Neighborhhod(v) parses self to compute its neighborhood in terms of the function list argument.
		This neighborhood is the union of all neighborhoods
		"""
		var("simpfvariable")
		n=Pattern([])
		for v in vlist:
			n.extend(neighborhood_two(self,v))
#			n.extend(self.neighborhood_one(v))
		n=Pattern(flatten(n))
		return(n.set_ify().tuple_ify())


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
		
	def translate_one(self,expr,v,fifi):
		"""The translate_one(v,f) method translates by the amount of v the arguments of f in self.
		"""
		def trfunc(*extra):
			return apply(fifi,vecteurs.sumv(v,extra))
#		dico={}
#		dico[fifi]=trfunc
		return expr.substitute_function(fifi,trfunc)

	def translation(self,v,flist):
		"""The translation(v,flist) method translates by the amount of v the arguments of all the function appearing both in self and in flist in self.
		"""
		res=self
		for f in flist:
			res=self.translate_one(res,v,f)
		return res
		#return FiniteDifference(sageobj(maxima('translate('+self.__repr__()+','+flist.__repr__()+','+list(v).__repr__()+')')))
		#Could also be (though does not work if unknown functions are used in self) :
		#t=sage_eval(("map(function,flist)","maxima.eval('translate('+self.__repr__()+','+flist.__repr__()+','+list(v).__repr__()+')')"),locals={'flist':flist,'self':self,'v':v})
		#return (FiniteDifference(sage_eval(t)))
		#But using maxima is way too slow.... is sage better ?
		
	def cform(self,maxargs):
		"""Applies a set of rules to comply with booz and C.
		"""
		return FiniteDifference(sageobj(maxima('cform('+self.__repr__()+','+maxargs.__repr__()+')')))
		
#	def localize(self,args,flist):
#		"""In Self, applies all functions of flist to args.
#		"""
#		return FiniteDifference(sageobj(maxima('localize('+self.__repr__()+','+flist.__repr__()+','+list(args).__repr__()+')')))
		
	def save(self,filename,compress=True):
		f=open(filename,"r")
		f.write(self.__repr__())
		f.close()
		Expression.save(self,filename,compress)
		
	def simplify(self):
		self=self.full_simplify()
		return self

