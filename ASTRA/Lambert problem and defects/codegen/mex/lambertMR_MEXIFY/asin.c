/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * asin.c
 *
 * Code generation for function 'asin'
 *
 */

/* Include files */
#include "asin.h"
#include "lambertMR_MEXIFY_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void b_asin(const emlrtStack *sp, real_T x[2])
{
  real_T d;
  boolean_T p;
  p = false;
  d = x[0];
  if ((d < -1.0) || (d > 1.0)) {
    p = true;
  } else {
    d = x[1];
    if ((d < -1.0) || (d > 1.0)) {
      p = true;
    }
  }
  if (p) {
    emlrtErrorWithMessageIdR2018a(
        sp, &emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
  }
  x[0] = muDoubleScalarAsin(x[0]);
  x[1] = muDoubleScalarAsin(x[1]);
}

/* End of code generation (asin.c) */
