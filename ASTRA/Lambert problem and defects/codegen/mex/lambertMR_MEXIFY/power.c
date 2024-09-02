/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * power.c
 *
 * Code generation for function 'power'
 *
 */

/* Include files */
#include "power.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void power(real_T a, real_T y[25])
{
  int32_T k;
  for (k = 0; k < 25; k++) {
    y[k] = muDoubleScalarPower(a, (((real_T)k + 1.0) - 1.0) + 1.0);
  }
}

/* End of code generation (power.c) */
