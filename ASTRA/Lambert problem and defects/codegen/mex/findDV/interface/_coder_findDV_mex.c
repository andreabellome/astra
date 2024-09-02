/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_findDV_mex.c
 *
 * Code generation for function '_coder_findDV_mex'
 *
 */

/* Include files */
#include "_coder_findDV_mex.h"
#include "_coder_findDV_api.h"
#include "findDV_data.h"
#include "findDV_initialize.h"
#include "findDV_terminate.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void findDV_mexFunction(int32_T nlhs, mxArray *plhs[3], int32_T nrhs,
                        const mxArray *prhs[4])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  const mxArray *outputs[3];
  int32_T i;
  st.tls = emlrtRootTLSGlobal;
  /* Check for proper number of arguments. */
  if (nrhs != 4) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 4, 4,
                        6, "findDV");
  }
  if (nlhs > 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 6,
                        "findDV");
  }
  /* Call the function. */
  findDV_api(prhs, nlhs, outputs);
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
  mexAtExit(&findDV_atexit);
  /* Module initialization. */
  findDV_initialize();
  /* Dispatch the entry-point. */
  findDV_mexFunction(nlhs, plhs, nrhs, prhs);
  /* Module termination. */
  findDV_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1,
                           NULL, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_findDV_mex.c) */
