###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

# Functions to compute gradient and Hessian using maxima... or not so that it does not crash (!)
# All explicit references to maxima have been removed at the expense of some substitutions
# It seems that maxima works in the background. This may be removed in future sage
# I wonder if this is faster

def superdiff(f,x,n=1):
#	return sageobj(maxima.diff(f,x,n))
	var("simpfderivee")
	return diff(f.subs_expr(x==simpfderivee),simpfderivee,n).subs_expr(simpfderivee==x)

def grad(f,v):
	return vector(list(superdiff(f,x) for x in v))
	
	
def hessian(f,v):
#	return sageobj(maxima.hessian(f,list(v)))
	l=len(v)
	hess=matrix(SR,l)
	for i in range(l):
		hess[i,i]=superdiff(f,v[i],2)
		for j in range(i):
			hess[i,j]=superdiff(superdiff(f,v[i]),v[j])
			hess[j,i]=hess[i,j]
	return hess

def diaghessian(f,v):
	return (diagonal_matrix(list(1/superdiff(f,x,2) for x in v)))

# A few function to help discretize a continuous differential problem
# Arguments :
# f is a function
# x is the variable with respect to wchich the differenciation is done
# dx is the discretization step

#Centered derivative
def ndc(f,x,dx):
	return((f.subs_expr(x==x+1)-f.subs_expr(x==x-1))/(2*dx))
#Left derviative
def ndl(f,x,dx):
	return((f-f.subs_expr(x==x-1))/(dx))

#Right derivative
def ndr(f,x,dx):
	return((f.subs_expr(x==x+1)-f)/(2*dx))

#Centered second derivative
def nd2(f,x,dx):
	return((f.subs_expr(x==x+1)+f.subs_expr(x==x-1)-2*f)/(dx**2))


