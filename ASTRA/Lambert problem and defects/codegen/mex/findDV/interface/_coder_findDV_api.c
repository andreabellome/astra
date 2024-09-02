/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_findDV_api.c
 *
 * Code generation for function '_coder_findDV_api'
 *
 */

/* Include files */
#include "_coder_findDV_api.h"
#include "findDV.h"
#include "findDV_data.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                   const emlrtMsgIdentifier *parentId))[3];

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *muPL,
                                 const char_T *identifier);

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[3];

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *vvrel_A,
                                 const char_T *identifier))[3];

static const mxArray *emlrt_marshallOut(const real_T u);

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

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *muPL,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(muPL), &thisId);
  emlrtDestroyArray(&muPL);
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

static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *vvrel_A,
                                 const char_T *identifier))[3]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[3];
  thisId.fIdentifier = (const char_T *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(vvrel_A), &thisId);
  emlrtDestroyArray(&vvrel_A);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *m;
  const mxArray *y;
  y = NULL;
  m = emlrtCreateDoubleScalar(u);
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

void findDV_api(const mxArray *const prhs[4], int32_T nlhs,
                const mxArray *plhs[3])
{
  emlrtStack st = {
      NULL, /* site */
      NULL, /* tls */
      NULL  /* prev */
  };
  real_T(*vvrel_A)[3];
  real_T(*vvrel_D)[3];
  real_T alpha;
  real_T alpha_A;
  real_T dv;
  real_T muPL;
  real_T rpmin;
  st.tls = emlrtRootTLSGlobal;
  /* Marshall function inputs */
  vvrel_A = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "vvrel_A");
  vvrel_D = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "vvrel_D");
  muPL = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "muPL");
  rpmin = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "rpmin");
  /* Invoke the target function */
  findDV(&st, *vvrel_A, *vvrel_D, muPL, rpmin, &dv, &alpha, &alpha_A);
  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(dv);
  if (nlhs > 1) {
    plhs[1] = emlrt_marshallOut(alpha);
  }
  if (nlhs > 2) {
    plhs[2] = emlrt_marshallOut(alpha_A);
  }
}

/* End of code generation (_coder_findDV_api.c) */
