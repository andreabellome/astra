/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * asinh.c
 *
 * Code generation for function 'asinh'
 *
 */

/* Include files */
#include "asinh.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void b_asinh(real_T *x)
{
  if (*x >= 2.68435456E+8) {
    *x = muDoubleScalarLog(*x) + 0.69314718055994529;
  } else if (*x > 2.0) {
    *x = muDoubleScalarLog(2.0 * *x +
                           1.0 / (muDoubleScalarSqrt(*x * *x + 1.0) + *x));
  } else {
    real_T t;
    t = *x * *x;
    *x += t / (muDoubleScalarSqrt(t + 1.0) + 1.0);
    t = muDoubleScalarAbs(*x);
    if ((t > 4.503599627370496E+15) ||
        (muDoubleScalarIsInf(*x) || muDoubleScalarIsNaN(*x))) {
      (*x)++;
      *x = muDoubleScalarLog(*x);
    } else if (!(t < 2.2204460492503131E-16)) {
      *x = muDoubleScalarLog(*x + 1.0) * (*x / ((*x + 1.0) - 1.0));
    }
  }
}

/* End of code generation (asinh.c) */
