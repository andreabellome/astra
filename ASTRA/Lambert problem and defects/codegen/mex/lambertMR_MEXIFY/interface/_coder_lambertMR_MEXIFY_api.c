/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_lambertMR_MEXIFY_api.c
 *
 * Code generation for function '_coder_lambertMR_MEXIFY_api'
 *
 */

/* Include files */
#include "_coder_lambertMR_MEXIFY_api.h"
#include "lambertMR_MEXIFY.h"
#include "lambertMR_MEXIFY_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[3];

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *TOF,
                                 const char_T *identifier);

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[3];

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *RI,
                                 const char_T *identifier))[3];

static const mxArray *emlrt_marshallOut(const real_T u[3]);

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[3]
{
  real_T(*y)[3];
  y = e_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *TOF,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(TOF), &thisId);
  emlrtDestroyArray(&TOF);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[3]
{
  static const int32_T dims[2] = {1, 3};
  real_T(*ret)[3];
  emlrtCheckBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 2U,
                          (const void *)&dims[0]);
  ret = (real_T(*)[3])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *RI,
                                 const char_T *identifier))[3]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[3];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(RI), &thisId);
  emlrtDestroyArray(&RI);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[3])
{
  static const int32_T b_iv[2] = {0, 0};
  static const int32_T iv1[2] = {1, 3};
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateNumericArray(2, (const void *)&b_iv[0], mxDOUBLE_CLASS,
                              mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims = 0;
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void lambertMR_MEXIFY_api(const mxArray *const prhs[6], int32_T nlhs,
                          const mxArray *plhs[2])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T(*RF)[3];
  real_T(*RI)[3];
  real_T(*VF)[3];
  real_T(*VI)[3];
  real_T MU;
  real_T Ncase;
  real_T Nrev;
  real_T TOF;
  st.tls = emlrtRootTLSGlobal;
  VI = (real_T(*)[3])mxMalloc(sizeof(real_T[3]));
  VF = (real_T(*)[3])mxMalloc(sizeof(real_T[3]));
  /* Marshall function inputs */
  RI = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "RI");
  RF = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "RF");
  TOF = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "TOF");
  MU = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "MU");
  Nrev = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "Nrev");
  Ncase = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[5]), "Ncase");
  /* Invoke the target function */
  lambertMR_MEXIFY(&st, *RI, *RF, TOF, MU, Nrev, Ncase, *VI, *VF);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*VI);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(*VF);
  }
}

/* End of code generation (_coder_lambertMR_MEXIFY_api.c) */
