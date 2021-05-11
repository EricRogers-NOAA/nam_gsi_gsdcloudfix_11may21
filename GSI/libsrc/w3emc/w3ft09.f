       SUBROUTINE W3FT09(VLN,GN,PLN,EPS,FL,WORK,TRIGS,RCOS)
C$$$   SUBPROGRAM  DOCUMENTATION  BLOCK
C
C SUBPROGRAM: W3FT09         COMPUTES 2.5X2.5 N. HEMI. GRID-VECTOR
C   AUTHOR: SELA,JOE         ORG: W323       DATE: 84-06-27
C
C ABSTRACT: COMPUTES 2.5 X 2.5 N. HEMI. GRID OF 145 X 37 POINTS
C   FROM SPECTRAL COEFFICIENTS IN A RHOMBOIDAL 30 RESOLUTION
C   REPRESENTING A VECTOR FIELD.
C
C PROGRAM HISTORY LOG:
C   80-10-21  JOE SELA
C   81-06-15  R.E.JONES   ADD DOC BLOCK, CLEAN UP SOURCE
C   89-01-25  R.E.JONES   CHANGE TO MICROSOFT FORTRAN 4.10
C   90-06-12  R.E.JONES   CHANGE TO SUN FORTRAN 1.3
C   91-03-30  R.E.JONES   CONVERT TO SiliconGraphics FORTRAN
C   93-03-29  R.E.JONES   ADD SAVE STATEMENT
C   93-07-22  R.E.JONES   CHANGE DOUBLE PRECISION TO REAL FOR CRAY
C
C USAGE:  CALL W3FT09(VLN,GN,PLN,EPS,FL,WORK,TRIGS,RCOS)
C
C   INPUT VARIABLES:
C     NAMES  INTERFACE DESCRIPTION OF VARIABLES AND TYPES
C     ------ --------- -----------------------------------------------
C     VLN    ARG LIST  992 COMPLEX COEFF.
C     PLN    ARG LIST  992 SPACE FOR LEGENDRE POLYNOMIALS.
C     EPS    ARG LIST  992 REAL SPACE FOR
C                      COEFFS. USED IN COMPUTING PLN.
C     FL     ARG LIST  31 COMPLEX SPACE FOR FOURIER COEFF.
C     WORK   ARG LIST  144 WORK SPACE FOR SUBR. W3FT12
C     TRIGS  ARG LIST  216 PRECOMPUTED TRIG FUNCS. USED
C                      IN W3FT12, COMPUTED BY W3FA13
C     RCOS   ARG LIST  37 RECIPROCAL COSINE LATITUDES OF
C                      2.5 X 2.5 GRID MUST BE COMPUTED BEFORE
C                      FIRST CALL TO W3FT11 USING SR W3FA13.
C
C   OUTPUT VARIABLES:
C     NAMES  INTERFACE DESCRIPTION OF VARIABLES AND TYPES
C     ------ --------- -----------------------------------------------
C     GN     ARG LIST  (145,37) GRID VALUES.
C                      5365 POINT GRID IS TYPE 29 OR 1D O.N. 84
C
C   SUBPROGRAMS CALLED:
C     NAMES                                                   LIBRARY
C     ------------------------------------------------------- --------
C     AIMAG  CMPLX  REAL                                      SYSTEM
C     W3FA12 W3FT12                                           W3LIB
C
C WARNING: THIS SUBROUTINE WAS OPTIMIZED TO RUN IN A SMALL AMOUNT OF
C   MEMORY, IT IS NOT OPTIMIZED FOR SPEED, 70 PERCENT OF THE TIME IS
C   USED BY SUBROUTINE W3FA12 COMPUTING THE LEGENDRE POLYNOMIALS. SINCE
C   THE LEGENDRE POLYNOMIALS ARE CONSTANT THEY NEED TO BE COMPUTED
C   ONLY ONCE IN A PROGRAM. BY MOVING W3FA12 TO THE MAIN PROGRAM AND
C   COMPUTING PLN AS A (32,31,37) ARRAY AND CHANGING THIS SUBROUTINE
C   TO USE PLN AS A THREE DIMENSION ARRAY YOU CAN CUT THE RUNNING TIME
C   70 PERCENT.
C
C ATTRIBUTES:
C   LANGUAGE: CRAY CFT77 FORTRAN
C   MACHINE:  CRAY Y-MP8/864, CRAY Y-MP EL2/128
C
C$$$
C
       COMPLEX          FL( 31 )
       COMPLEX          VLN( 32 , 31 )
C
       REAL             COLRA
       REAL             EPS(992)
       REAL             GN(145,37)
       REAL             PLN( 32 , 31 )
       REAL             RCOS(37)
       REAL             TRIGS(216)
       REAL             WORK(144)
C
       SAVE
C
       DATA  PI    /3.14159265/
C
         DRAD = 2.5 * PI / 180.0
C
         DO 400 LAT = 2,37
           LATN  = 38 - LAT
           COLRA = (LAT - 1) * DRAD
           CALL W3FA12(PLN,COLRA, 30 ,EPS)
C
           DO 100 L = 1, 31
             FL(L) = (0.,0.)
 100       CONTINUE
C
             DO 300 L = 1, 31
C
               DO 200 I = 1, 32
                 FL(L) = FL(L) + CMPLX(PLN(I,L) * REAL(VLN(I,L)),
     &           PLN(I,L) * AIMAG(VLN(I,L)) )
 200           CONTINUE
C
             FL(L)=CMPLX(REAL(FL(L))*RCOS(LAT),AIMAG(FL(L))*RCOS(LAT))
 300         CONTINUE
C
         CALL W3FT12(FL,WORK,GN(1,LATN),TRIGS)
C
 400     CONTINUE
C
C***   POLE ROW=CLOSEST LATITUDE ROW
C
         DO 500 I = 1,145
           GN(I,37) = GN(I,36)
 500     CONTINUE
C
         RETURN
       END
