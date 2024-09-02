/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * sqrt.c
 *
 * Code generation for function 'sqrt'
 *
 */

/* Include files */
#include "sqrt.h"
#include "lambertMR_MEXIFY_data.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Function Definitions */
void b_sqrt(const emlrtStack *sp, real_T x[2])
{
  boolean_T p;
  p = false;
  if ((x[0] < 0.0) || (x[1] < 0.0)) {
    p = true;
  }
  if (p) {
    emlrtErrorWithMessageIdR2018a(
        sp, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  x[0] = muDoubleScalarSqrt(x[0]);
  x[1] = muDoubleScalarSqrt(x[1]);
}

/* End of code generation (sqrt.c) */
