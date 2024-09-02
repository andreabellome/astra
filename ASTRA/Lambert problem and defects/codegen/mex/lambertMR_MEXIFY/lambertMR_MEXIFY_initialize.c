/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lambertMR_MEXIFY_initialize.c
 *
 * Code generation for function 'lambertMR_MEXIFY_initialize'
 *
 */

/* Include files */
#include "lambertMR_MEXIFY_initialize.h"
#include "_coder_lambertMR_MEXIFY_mex.h"
#include "lambertMR_MEXIFY.h"
#include "lambertMR_MEXIFY_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void lambertMR_MEXIFY_once(void);

/* Function Definitions */
static void lambertMR_MEXIFY_once(void)
{
  mex_InitInfAndNan();
  sigmax_init();
}

void lambertMR_MEXIFY_initialize(void)
{
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
    lambertMR_MEXIFY_once();
  }
}

/* End of code generation (lambertMR_MEXIFY_initialize.c) */
