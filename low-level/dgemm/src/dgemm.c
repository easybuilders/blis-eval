#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "omp.h"

#define A( i,j ) *( ap + (j)*lda + (i) )          // map A( i,j )    to array ap    in column-major order

void RandomMatrix( int m, int n, double *ap, int lda )
/* 
   RandomMatrix overwrite A with random values.
*/
{
  int  i, j;
  
  #pragma omp parallel for private(i,j)
  for ( i=0; i<m; i++ ) {
    for ( j=0; j<n; j++ ) {
      A( i,j ) = drand48();
    }
  }
}

/* Prototype for BLAS matrix-matrix multiplication routine (which we will 
   use for the reference implementation */
void dgemm_( char *, char *,                 // transA, transB
	     int *, int *, int *,            // m, n, k
	     double *, double *, int *,      // alpha, A, ldA
	               double *, int *,      //        B, ldB
	     double *, double *, int * );    // beta,  C, ldC

int main(int argc, char *argv[])
{
  int
    x, y,
    m, n, k,
    ldA, ldB, ldC,
    size, first, last, inc,
    i, irep,
    nrepeats;

  double
    d_one = 1.0,
    dtime, dtime_best, 
    diff, maxdiff = 0.0, gflops;

  double
    *A, *B, *C;

  /* Print the number of threads available */
  printf( "%% Number of threads = %d\n\n", omp_get_max_threads() );
  /* Every time trial is repeated "repeat" times and the fastest run in recorded */
  printf( "%% number of repeats:" );
  scanf( "%d", &nrepeats );
  printf( "%% %d\n", nrepeats );

  /* Timing trials for matrix sizes m=n=k=first to last in increments
     of inc will be performed.  (Actually, we are going to go from
     largest to smallest since this seems to give more reliable 
     timings.  */
  printf( "%% enter first, last, inc:" );
  scanf( "%d%d%d", &first, &last, &inc );

  /* Adjust first and last so that they are multiples of inc */
  last = ( last / inc ) * inc;
  first = ( first / inc ) * inc;
  first = ( first == 0 ? inc : first );
  
  printf( "%% %d %d %d \n", first, last, inc );

  printf( "data = [\n" );
  printf( "%%  n     time       GFLOPS  GFLOPS/core\n" );
  
  for ( size=last; size>= first; size-=inc ){
    /* we will only time cases where all three matrices are square */
    m = n = k = size;
    ldA = ldB = ldC = size;

    /* Gflops performed */
    gflops = 2.0 * m * n * k * 1e-09;

    /* Allocate space for the matrices. */

    A = ( double * ) malloc( ldA * k * sizeof( double ) );
    B = ( double * ) malloc( ldB * n * sizeof( double ) );
    C = ( double * ) malloc( ldC * n * sizeof( double ) );

    /* Generate random matrix A */
    RandomMatrix( m, k, A, ldA );

    /* Generate random matrix B */
    RandomMatrix( k, n, B, ldB );

    /* Generate random matrix C */
    RandomMatrix( m, n, C, ldC );
    
    /* Time dgemm (double precision general matrix-matrix
       multiplicationn */
    for ( irep=0; irep<nrepeats; irep++ ){
    
      /* start clock */
      dtime = omp_get_wtime();
    
      /* Compute C = A B + C */
      dgemm_( "No transpose", "No transpose",
	      &m, &n, &k,
	      &d_one, A, &ldA,
	              B, &ldB,
	      &d_one, C, &ldC );

      /* stop clock */
      dtime = omp_get_wtime() - dtime;

      /* record the best time so far */
      if ( irep == 0 ) 
        dtime_best = dtime;
      else
        dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }
  
//     printf( " %5d %8.4le %8.4le %8.4le\n", n, dtime_best, gflops/dtime_best, gflops/dtime_best/omp_get_max_threads() );
    printf( " %5d %8.4le %8.4f %8.4f\n", n, dtime_best, gflops/dtime_best, gflops/dtime_best/omp_get_max_threads() );
    fflush( stdout );  // We flush the output buffer because otherwise
		       // it may throw the timings of a next
		       // experiment.

    /* Free the buffers */
    free( A );
    free( B );
    free( C );

  }
  printf( "];\n\n" );
  
  exit( 0 );
}
