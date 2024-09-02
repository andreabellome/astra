/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * findDV_terminate.c
 *
 * Code generation for function 'findDV_terminate'
 *
 */

/* Include files */
#include "findDV_terminate.h"
#include "_coder_findDV_mex.h"
#include "findDV_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void findDV_atexit(void)
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

void findDV_terminate(void)
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (findDV_terminate.c) */
