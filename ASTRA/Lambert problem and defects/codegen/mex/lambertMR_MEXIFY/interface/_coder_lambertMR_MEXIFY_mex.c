/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_lambertMR_MEXIFY_mex.c
 *
 * Code generation for function '_coder_lambertMR_MEXIFY_mex'
 *
 */

/* Include files */
#include "_coder_lambertMR_MEXIFY_mex.h"
#include "_coder_lambertMR_MEXIFY_api.h"
#include "lambertMR_MEXIFY_data.h"
#include "lambertMR_MEXIFY_initialize.h"
#include "lambertMR_MEXIFY_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void lambertMR_MEXIFY_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
                                  const mxArray *prhs[6])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[2];
  int32_T i;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 6) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 6, 4,
                        16, "lambertMR_MEXIFY");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 16,
                        "lambertMR_MEXIFY");
  }
  /* Call the function. */
  lambertMR_MEXIFY_api(prhs, nlhs, outputs);
  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    i = 1;
  } else {
    i = nlhs;
  }
  emlrtReturnArrays(i, &plhs[0], &outputs[0]);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&lambertMR_MEXIFY_atexit);
  /* Module initialization. */
  lambertMR_MEXIFY_initialize();
  /* Dispatch the entry-point. */
  lambertMR_MEXIFY_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  lambertMR_MEXIFY_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_lambertMR_MEXIFY_mex.c) */
