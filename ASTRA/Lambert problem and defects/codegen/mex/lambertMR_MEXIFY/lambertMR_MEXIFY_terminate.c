/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lambertMR_MEXIFY_terminate.c
 *
 * Code generation for function 'lambertMR_MEXIFY_terminate'
 *
 */

/* Include files */
#include "lambertMR_MEXIFY_terminate.h"
#include "_coder_lambertMR_MEXIFY_mex.h"
#include "lambertMR_MEXIFY_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void lambertMR_MEXIFY_atexit(void)
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void lambertMR_MEXIFY_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (lambertMR_MEXIFY_terminate.c) */
