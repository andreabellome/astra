/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * findDV_initialize.c
 *
 * Code generation for function 'findDV_initialize'
 *
 */

/* Include files */
#include "findDV_initialize.h"
#include "_coder_findDV_mex.h"
#include "findDV_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void findDV_once(void);

/* Function Definitions */
static void findDV_once(void)
{
  mex_InitInfAndNan();
}

void findDV_initialize(void)
{
  static const volatile char_T *emlrtBreakCheckR2012bFlagVar = NULL;
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2022b(&st);
  emlrtClearAllocCountR2012b(&st, false, 0U, NULL);
  emlrtEnterRtStackR2012b(&st);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    findDV_once();
  }
}

/* End of code generation (findDV_initialize.c) */
