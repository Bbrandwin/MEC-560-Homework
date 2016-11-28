#include "Matrix.h"

using namespace std;

mat::mat() {
	rows = 0;
	cols = 0;
}

mat::mat(int m, int n) {
	rows = m;
	cols = n;
}

// mat Addition
mat mat::operator+(mat m) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// b.set(i, j, at(i, j) + m.at(i, j));
			b.data[i][j] = data[i][j] + m.data[i][j];
		}
	}
	return b;
}

void mat::operator+=(mat m) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// set(i, j, at(i, j) + m.at(i, j));
			data[i][j] += m.data[i][j];
		}
	}
}

// mat Subtraction
mat mat::operator-(mat m) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// b.set(i, j, at(i, j) - m.at(i, j));
			b.data[i][j] = data[i][j] - m.data[i][j];
		}
	}
	return b;
}

void mat::operator-=(mat m) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// set(i, j, at(i, j) - m.at(i, j));
			data[i][j] -= m.data[i][j];
		}
	}
}

// Element-by-element multiplication
mat mat::operator^(mat m) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// b.set(i, j, at(i, j) * m.at(i, j));
			b.data[i][j] = data[i][j] * m.data[i][j];
		}
	}
	return b;
}

void mat::operator^=(mat m) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// set(i, j, at(i, j) * m.at(i, j));
			data[i][j] *= m.data[i][j];
		}
	}
}

// Element-by-element division
mat mat::operator/(mat m) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// b.set(i, j, at(i, j) / m.at(i, j));
			b.data[i][j] = data[i][j] / m.data[i][j];
		}
	}
	return b;
}

void mat::operator/=(mat m) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			// set(i, j, at(i, j) / m.at(i, j));
			data[i][j] /= m.data[i][j];
		}
	}
}

// mat multiplication
mat mat::operator*(mat m) {
	mat b(rows, m.cols);
	for(int i=0; i<b.rows; i++) {
		for(int j=0; j<b.cols; j++) {
			float val = 0;
			for(int k=0; k<cols; k++) {
				val += data[i][k]*m.data[k][j];
			}
			// set(i, j, val);
			b.data[i][j] = val;
		}
	}
	return b;
}

void mat::operator*=(mat m) {
	mat b(rows, m.cols);
	for(int i=0; i<b.rows; i++) {
		for(int j=0; j<b.cols; j++) {
			float val = 0;
			for(int k=0; k<cols; k++) {
				// val += at(i,k)*m.at(k,j);
				val += data[i][k]*m.data[k][j];
			}
			// b.set(i, j, val);
			b.data[i][j] = val;
		}
	}
	copy(b);
}

// scalar multiplication
mat mat::operator*(float k) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			b.data[i][j] = data[i][j] * k;
		}
	}
	return b;
}

void mat::operator*=(float k) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			data[i][j] *= k;
		}
	}
}

// scalar division
mat mat::operator/(float k) {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			b.data[i][j] = data[i][j] / k;
		}
	}
	return b;
}

void mat::operator/=(float k) {
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			data[i][j] /= k;
		}
	}
}

// Matrix Initializers
mat mat::zeros(int m, int n) {
	mat b(m,n);
	for(int i=0; i<b.rows; i++) {
		for(int j=0; j<b.cols; j++) {
			b.data[i][j] = 0;
		}
	}
	return b;
}

mat mat::ones(int m, int n) {
	mat b(m,n);
	for(int i=0; i<b.rows; i++) {
		for(int j=0; j<b.cols; j++) {
			b.data[i][j] = 1;
		}
	}
	return b;
}

mat mat::identity(int n) {
	mat b(n,n);
	for(int i=0; i<b.rows; i++) {
		for(int j=0; j<b.cols; j++) {
			if (i == j) {
				b.data[i][j] = 1;
			} else {
				b.data[i][j] = 0;
			}
		}
	}
	return b;
}

// Copy matrix
void mat::copy(mat m) {
	rows = m.rows;
	cols = m.cols;
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			data[i][j] = m.data[i][j];
		}
	}
}

void mat::resize(int m, int n) {
    rows = m;
    cols = n;
}

// Compute determinant - FIXME: Needs work!
float mat::det() {
    if(rows == 1) {
        return data[0][0];
    } else {
        float d = 0;
        for(int j=0; j<cols; j++) {
            if (j%2 == 0) {
                d += cofactor(0,j).det()*data[0][j];
            } else {
                d -= cofactor(0,j).det()*data[0][j];
            }
        }
        return d;
    }
}

// Compute transpose
mat mat::t() {
	mat b(cols, rows);
	for(int i=0; i<cols; i++) {
		for(int j=0; j<rows; j++) {
			b.data[i][j] = data[j][i];
		}
	}
	return b;
}

// Cofactor matrix
mat mat::cofactor(int m, int n) {
    mat b(rows-1, cols-1);

    int ii=0, jj=0;
    // Top-left square
	for(int i=0; i<m; i++) {
		for(int j=0; j<n; j++) {
            b.data[ii][jj] = data[i][j];
            jj++;
		}
		ii++;
		jj=0;
	}

    ii=m; jj=n;
    // Bottom-right square
    for(int i=m+1; i<rows; i++) {
		for(int j=n+1; j<cols; j++) {
            b.data[ii][jj] = data[i][j];
            jj++;
		}
		ii++;
		jj=n;
	}

    ii=0; jj=n;
    // Top-right rectangle
    for(int i=0; i<m; i++) {
        for(int j=n+1; j<cols; j++) {
            b.data[ii][jj] = data[i][j];
            jj++;
		}
		ii++;
		jj=n;
    }

    ii=m; jj=0;
    // Bottom-left rectangle
    for(int i=m+1; i<rows; i++) {
		for(int j=0; j<n; j++) {
            b.data[ii][jj] = data[i][j];
            jj++;
		}
		ii++;
		jj=0;
	}

    return b;
}

// Compute inverse
mat mat::inv() {
	// Gauss-Jordan Elimination Method - based on my MATLAB implementation
	// NOTE - A and I and made to be separate matrices (not concatenated) to save
	// memory space (so, a lower MAX_LEN can be used)
	mat A = get_mat();
	mat I = identity(rows);

	int i,j;
	float k;

	// STEP 1 - Makes lower triangular zeros
	for(i=1; i<rows; i++) {
		for(j=0; j<i; j++) {
			k = A.data[i][j]/A.data[j][j];
			A.set_row(i, A.get_row(i) - A.get_row(j)*k);
			I.set_row(i, I.get_row(i) - I.get_row(j)*k);
		}
	}

	// STEP 2 - Makes upper triangular zeros
	for(i=rows-2; i>=0; i--) {
		for(j=rows-1; j>=i+1; j--) {
			k = A.data[i][j]/A.data[j][j];
			A.set_row(i, A.get_row(i) - A.get_row(j)*k);
			I.set_row(i, I.get_row(i) - I.get_row(j)*k);
		}
	}

	// STEP 3 - Make the left side an identity matrix
	for(i=0; i<rows; i++) {
		// A.set_row(i, A.get_row(i)/A.data[i][i]);
		I.set_row(i, I.get_row(i)/A.data[i][i]);
	}

	return I; // The identity matrix transforms into the inverse
}

// Matrix concatenation
mat mat::cols_cat(mat m) {
	mat b(rows, cols + m.cols);
	int j;
	for(int i=0; i<rows; i++) {
		for(j=0; j<cols; j++) {
			b.data[i][j] = data[i][j];
		}
		for(j=cols; j<cols+m.cols; j++) {
			b.data[i][j] = m.data[i][j-cols];
		}
	}
	return b;
}

mat mat::rows_cat(mat m) {
	mat b(rows + m.rows, cols);
	int i;
	for(int j=0; i<cols; j++) {
		for(i=0; i<rows; i++) {
			b.data[i][j] = data[i][j];
		}
		for(i=rows; i<rows+m.rows; i++) {
			b.data[i][j] = m.data[i-rows][j];
		}
	}
	return b;
}

// Matrix access functions
mat mat::get_subm(int m1, int m2, int n1, int n2) {
	mat b(m2-m1+1, n2-n1+1);
	for (int i=0; i<=m2-m1; i++) {
		for (int j=0; j<=n2-n1; j++) {
			b.data[i][j] = data[m1+i][n1+j];
		}
	}
	return b;
}

mat mat::get_row(int m) {
	return get_subm(m, m, 0, cols-1);
}

mat mat::get_col(int n) {
	return get_subm(0, rows-1, n, n);
}

void mat::set_subm(int m, int n, mat subm) {
	for (int i=0; i<subm.rows; i++) {
		for (int j=0; j<subm.cols; j++) {
			data[m+i][n+j] = subm.data[i][j];
		}
	}
}

void mat::set_row(int m, mat row) {
	set_subm(m, 0, row);
}

void mat::set_col(int n, mat col) {
	set_subm(0, n, col);
}

mat mat::get_mat() {
	mat b(rows, cols);
	for(int i=0; i<rows; i++) {
		for(int j=0; j<cols; j++) {
			b.data[i][j] = data[i][j];
		}
	}
	return b;
}

float& mat::operator()(int m, int n) {
    return data[m][n];
}
