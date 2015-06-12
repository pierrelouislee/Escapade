#include <Python.h>

static PyObject* sumv(PyObject* self, PyObject* args)
{
int numElems1,numElems2;       
int i;
long valeur=0;
PyObject* list1=NULL;
PyObject* list2=NULL;
PyObject* tuple;
PyObject* liste;
if(PyArg_ParseTuple(args, "O!O!",&PyTuple_Type,&list1,&PyTuple_Type,&list2))
	{

	numElems1=PyTuple_Size(list1);
	numElems2=PyTuple_Size(list2);
	if(numElems1!=numElems1)
		{
		printf("Error.The dimension of the vectors arguments are not the same\n");
		}
	tuple = PyTuple_New(numElems1);
	for(i=0;i<numElems1;i++)
		{
		valeur=PyInt_AsLong(PyTuple_GetItem(list1,i))+PyInt_AsLong(PyTuple_GetItem(list2,i));
		PyTuple_SetItem(tuple, i, PyInt_FromLong( valeur));
		}
	return tuple;
	}
else if(PyArg_ParseTuple(args, "O!O!",&PyList_Type,&list1,&PyList_Type,&list2))
	{
	numElems1=PyList_Size(list1);
	numElems2=PyList_Size(list2);
	if(numElems1!=numElems1)
		{
		printf("Error.The dimension of the vectors arguments are not the same\n");
		}
	liste = PyList_New(0);
	for(i=0;i<numElems1;i++)
		{
		valeur=PyInt_AsLong(PyList_GetItem(list1,i))+PyInt_AsLong(PyList_GetItem(list2,i));
		PyList_Append(liste, PyInt_FromLong( valeur));
		}
	return liste;
	}
else
	{
	printf("Type error: the arguments must be tuples or lists\n");
	return NULL;
	}
}

static PyObject* diffv(PyObject* self, PyObject* args)
{
int numElems1,numElems2;       
int i;
long valeur=0;
PyObject* list1=NULL;
PyObject* list2=NULL;
PyObject* tuple;
PyObject* liste;

if(PyArg_ParseTuple(args, "O!O!",&PyTuple_Type,&list1,&PyTuple_Type,&list2))
	{

	numElems1=PyTuple_Size(list1);
	numElems2=PyTuple_Size(list2);
	if(numElems1!=numElems1)
		{
		printf("Error.The dimension of the vectors arguments are not the same\n");
		}
	tuple = PyTuple_New(numElems1);
	for(i=0;i<numElems1;i++)
		{
		valeur=PyInt_AsLong(PyTuple_GetItem(list1,i))-PyInt_AsLong(PyTuple_GetItem(list2,i));
		PyTuple_SetItem(tuple, i, PyInt_FromLong( valeur));
		}
	return tuple;
	}
else if(PyArg_ParseTuple(args, "O!O!",&PyList_Type,&list1,&PyList_Type,&list2))
	{
	numElems1=PyList_Size(list1);
	numElems2=PyList_Size(list2);
	if(numElems1!=numElems1)
		{
		printf("Error.The dimension of the vectors arguments are not the same\n");
		}
	liste = PyList_New(0);
	for(i=0;i<numElems1;i++)
		{
		valeur=PyInt_AsLong(PyList_GetItem(list1,i))-PyInt_AsLong(PyList_GetItem(list2,i));
		PyList_Append(liste, PyInt_FromLong( valeur));
		}
	return liste;
	}
else
	{
	printf("Type error: the arguments must be tuples or lists\n");
	return NULL;
	}
}



static PyMethodDef fonctions[]={
{"sumv", sumv, METH_VARARGS,"sum of 2 lists or tuple"},
{"diffv", diffv, METH_VARARGS,"difference of 2 lists or tuple"},
{NULL, NULL,0,NULL}
};

void initvecteurs(void)
{
Py_InitModule("vecteurs", fonctions);
}
