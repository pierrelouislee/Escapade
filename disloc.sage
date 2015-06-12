###############################################################################
#   ESCAPADE
# Ergonomic Solver using Cellular Automata for PArtial Differential Equation
#       Copyright (C) 2009 Nicolas Fressengeas <nicolas@fressengeas.net>
#  Distributed under the terms of the GNU General Public License (GPL),
#  version 2 or any later version.  The full text of the GPL is available at:
#                  http://www.gnu.org/licenses/
###############################################################################

#Vector differential operators in 3D

#curls
def NROTC(v,r,dr):
	return[	ndc(v[2],r[1],dr[1])-ndc(v[1],r[2],dr[2]),
		ndc(v[0],r[2],dr[2])-ndc(v[2],r[0],dr[0]),
		ndc(v[1],r[0],dr[0])-ndc(v[0],r[1],dr[1])
		]
def NROTD2C(m,r,dr):
	return matrix(list(NROTC(l,r,dr) for l in m.rows()))
def NROTG2C(m,r,dr):
	return matrix(list(NROTC(l,r,dr) for l in m.columns()))

#matrix cross products
def MatrixCrossD(m,v):
	return(matrix(list(l.cross_product(v) for l in m.rows())))
def MatrixCrossG(m,v):
	return(matrix(list(l.cross_product(v) for l in m.columns())))
	

#Divergence
def NDIVC(v,r,dr):
	return sum(list(ndc(v[i],r[i],dr[i]) for i in range(3)))

def NDIVD2C(m,r,dr):
	return matrix(list(NDIVC(l,r,dr) for l in m.rows()))
def NDIVG2C(m,r,dr):
	return matrix(list(NDIVC(l,r,dr) for l in m.columns()))


#Les dislocs
a=function("a")
var("v x y z t dx dy dz dt")
r=[x,y,z]
dr=[dx,dy,dz]
A=matrix([ [0,a(x,t),0], [0,0,0], [0,0,0]])
V=vector([v,0,0])

equ=((A-A.subs(t=t-1))/dt+NROTD2C(MatrixCrossD(A,V),r,dr))
equreal=equ[0,1]
equlx=equreal.subs_expr(x-1==x,dx==dx/2)
equhx=equreal.subs_expr(x+1==x,dx==dx/2)

Sys=[[equreal(x=0,t=0)],[equlx(x=0,t=0)],[equhx(x=0,t=0)],[0]]

N=100
mesh=numpy.zeros([N,N],dtype=int)
mesh[0,:]=1
mesh[N-1,:]=2
mesh[:,0]=3

disloc=Escapade(Sys,mesh,[a])
disloc.method=1
disloc.params=[[dx,n(1/N)],[dt,1/N],[v,1]]

#disloc.write_simpffiles()

#Now the Init
zerofunction=lambda x:0
reducedcos=lambda x:cos(x*pi/2)
dislocfunction=piecewise([[(-Infinity,-1),zerofunction],[(-1,1),reducedcos],[(1,Infinity),zerofunction]])
a_init=numpy.zeros([N,N],dtype=float)
relativewidth=1/4
a_init[:,0]=list(dislocfunction(((i/N)-(1/2))*2/relativewidth) for i in range(N))
disloc.simpfinit([a_init])
