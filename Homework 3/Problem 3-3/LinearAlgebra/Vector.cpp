#include "Vector.h"

vec::vec(int n) {
	rows = n;
	cols = 1;
}

// Dot product
float vec::dot(vec v) {
	float val;
	for(int i=0; i<rows; i++) {
		val += data[i][0]*v.data[i][0];
	}
	return val;
}

// Cross product
vec vec::cross(vec v) {
	vec b(3);
	b.data[0][0] = data[1][0]*v.data[2][0] - data[2][0]*v.data[1][0];
	b.data[1][0] = data[2][0]*v.data[0][0] - data[0][0]*v.data[2][0];
	b.data[2][0] = data[0][0]*v.data[1][0] - data[1][0]*v.data[0][0];
	return b;
}

// Vector access
float& vec::operator()(int m) {
    return data[m][0];
}


// Vector Initializers
vec vec::zeros(int n) {
	vec b(n);
	for(int i=0; i<b.rows; i++) {
		b.data[i][0] = 0;
	}
	return b;
}

vec vec::ones(int n) {
	vec b(n);
	for(int i=0; i<b.rows; i++) {
		b.data[i][0] = 1;
	}
	return b;
}
