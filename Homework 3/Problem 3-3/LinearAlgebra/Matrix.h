#ifndef MATRIX_H
#define MATRIX_H

// #include <string>

#define MAX_LEN 6

class mat {
	public:
		// Constructor
		mat();
		mat(int m, int n);

		// mat operations
		mat operator+(mat m);		// Addition
		void operator+=(mat m);

		mat operator-(mat m);		// Subtraction
		void operator-=(mat m);

		mat operator^(mat m);		// Element-by-element multiplication
		void operator^=(mat m);

		mat operator/(mat m);		// Element-by-element division
		void operator/=(mat m);

		mat operator*(mat m);		// mat multiplication
		void operator*=(mat m);

		mat operator*(float k);		// scalar multiplication
		void operator*=(float k);

		mat operator/(float k);		// scalar division
		void operator/=(float k);

		// mat functions
		float det(); 					// Determinant
		mat t();						// Transpose
		mat inv();						// Inverse
		void resize(int m, int n);		// Resize
		void copy(mat m);				// Copy
		mat cols_cat(mat m);			// Horizontal concatenation
		mat rows_cat(mat m);			// Vertical concatenation

		// Access functions
		mat get_row(int m);				// Get row
		mat get_col(int n);				// Get column
		void set_row(int m, mat row);	// Set row
		void set_col(int n, mat col);	// Set col
		mat get_subm(int m1, int m2, int n1, int n2);	// Get matrix subset
		void set_subm(int m, int n, mat subm);	        // Set matrix subset
		mat cofactor(int m, int n);	// Get cofactor matrix
		
		float& operator()(int m, int n);

		// Initializers
		static mat zeros(int m, int n);
		static mat ones(int m, int n);
		static mat identity(int n);

		// Debug stuff
        // std::string sprint();			// Dump matrix to string

		// TO-DO: Add relational operators

		// mat variables
		int rows;
		int cols;
		float data[MAX_LEN][MAX_LEN];

	protected:
		mat get_mat();					// Return self
};

#endif
