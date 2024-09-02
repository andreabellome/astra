/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * wrapToPi.c
 *
 * Code generation for function 'wrapToPi'
 *
 */

/* Include files */
#include "wrapToPi.h"
#include "rt_nonfinite.h"
#include "mwmathutil.h"

/* Variable Definitions */
static emlrtRSInfo i_emlrtRSI =
    {
        16,         /* lineNo */
        "wrapToPi", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\shared\\maputils\\wrapToPi.m" /* pathName
                                                                        */
};

static emlrtECInfo emlrtECI =
    {
        -1,         /* nDims */
        16,         /* lineNo */
        1,          /* colNo */
        "wrapToPi", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\shared\\maputils\\wrapToPi.m" /* pName
                                                                        */
};

static emlrtBCInfo emlrtBCI =
    {
        -1,          /* iFirst */
        -1,          /* iLast */
        17,          /* lineNo */
        8,           /* colNo */
        "",          /* aName */
        "wrapTo2Pi", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\shared\\maputils\\wrapTo2Pi.m", /* pName
                                                                          */
        0 /* checkKind */
};

/* Function Definitions */
void wrapToPi(const emlrtStack *sp, real_T *lambda)
{
  emlrtStack st;
  real_T tmp_data;
  int32_T i;
  int32_T loop_ub;
  int32_T trueCount;
  boolean_T q;
  boolean_T rEQ0;
  st.prev = sp;
  st.tls = sp->tls;
  q = ((*lambda < -3.1415926535897931) || (*lambda > 3.1415926535897931));
  trueCount = 0;
  if (q) {
    trueCount = 1;
  }
  st.site = &i_emlrtRSI;
  if (trueCount - 1 >= 0) {
    real_T varargin_1;
    varargin_1 = *lambda + 3.1415926535897931;
    if (muDoubleScalarIsNaN(varargin_1) || muDoubleScalarIsInf(varargin_1)) {
      tmp_data = rtNaN;
    } else if (varargin_1 == 0.0) {
      tmp_data = 0.0;
    } else {
      tmp_data = muDoubleScalarRem(varargin_1, 6.2831853071795862);
      rEQ0 = (tmp_data == 0.0);
      if (!rEQ0) {
        real_T b_q;
        b_q = muDoubleScalarAbs(varargin_1 / 6.2831853071795862);
        rEQ0 = !(muDoubleScalarAbs(b_q - muDoubleScalarFloor(b_q + 0.5)) >
                 2.2204460492503131E-16 * b_q);
      }
      if (rEQ0) {
        tmp_data = 0.0;
      } else if (varargin_1 < 0.0) {
        tmp_data += 6.2831853071795862;
      }
    }
  }
  for (i = 0; i < trueCount; i++) {
    rEQ0 = (tmp_data == 0.0);
  }
  loop_ub = trueCount - 1;
  for (i = 0; i <= loop_ub; i++) {
    rEQ0 = (rEQ0 && (*lambda + 3.1415926535897931 > 0.0));
  }
  if ((trueCount - 1 >= 0) && rEQ0) {
    if (trueCount < 1) {
      emlrtDynamicBoundsCheckR2012b(1, 1, 0, &emlrtBCI, &st);
    }
    tmp_data = 6.2831853071795862;
  }
  loop_ub = 0;
  if (q) {
    loop_ub = 1;
  }
  if (loop_ub != trueCount) {
    emlrtSubAssignSizeCheck1dR2017a(loop_ub, trueCount, &emlrtECI,
                                    (emlrtConstCTX)sp);
  }
  if (q) {
    *lambda = tmp_data - 3.1415926535897931;
  }
}

/* End of code generation (wrapToPi.c) */
