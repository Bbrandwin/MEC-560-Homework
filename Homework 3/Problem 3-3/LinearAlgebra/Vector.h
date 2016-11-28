#ifndef VECTOR_H
#define VECTOR_H

#include "Matrix.h"

class vec : public mat {
	public:
		vec(int n); // Constructor
		
		// vec specific Operations
		float dot(vec v);		// Dot product
		vec cross(vec v);		// Cross product
		
		// Vector access
		float& operator()(int m);
		
		// Vector Initializers
		static vec zeros(int n);
		static vec ones(int n);
};

#endif
