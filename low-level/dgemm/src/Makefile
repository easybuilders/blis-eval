BLAS_LIB  := $(EBROOTBLIS)/lib/libblis.a
BLAS_INC  := $(EBROOTBLIS)/include/

CC         := gcc
LINKER     := $(CC)

# ---------------------

BLIS: CFLAGS     := -g -O0 -I$(BLAS_INC) -m64 -mavx2 -march=native -fopenmp
BLIS: FFLAGS     := $(CFLAGS) 
BLIS: LDFLAGS    := -lpthread -m64 -lm
BLIS: BLIS_LIB := $(BLAS_LIB)
BLIS: SRC_dgemm := dgemm.c $(BLAS_LIB)
BLIS: dgemm.x

# ---------------------

imkl: CFLAGS     := -g -O0 -m64 -I${MKLROOT}/include -m64 -mavx2 -march=native -fopenmp
imkl: FFLAGS     := $(CFLAGS) 
imkl: LDFLAGS    := -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_intel_lp64 -lmkl_gnu_thread -lmkl_core -lgomp -lpthread -lm -ldl
imkl: BLIS_LIB := 
imkl: SRC_dgemm := dgemm.c
imkl: dgemm.x

# ---------------------

OpenBLAS: CFLAGS     := -g -O0 -lopenblas -m64 -mavx2 -march=native -fopenmp
OpenBLAS: FFLAGS     := $(CFLAGS) 
OpenBLAS: LDFLAGS    := -m64 -lm
OpenBLAS: BLIS_LIB := 
OpenBLAS: SRC_dgemm := dgemm.c
OpenBLAS: dgemm.x

# ---------------------



%.x: %.c Makefile
	$(LINKER) $(CFLAGS) $< $(BLIS_LIB) -o $@ $(LDFLAGS)



# ---------------------

clean:
	rm -f *.o *~ core *.x *.pdf
