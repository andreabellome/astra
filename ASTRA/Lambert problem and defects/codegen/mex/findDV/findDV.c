/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * findDV.c
 *
 * Code generation for function 'findDV'
 *
 */

/* Include files */
#include "findDV.h"
#include "rt_nonfinite.h"
#include "wrapToPi.h"
#include "blas.h"
#include "mwmathutil.h"
#include <stddef.h>

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = {
    19,       /* lineNo */
    "findDV", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\findDV.m" /* pathName */
};

static emlrtRSInfo c_emlrtRSI = {
    21,       /* lineNo */
    "findDV", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\findDV.m" /* pathName */
};

static emlrtRSInfo d_emlrtRSI = {
    23,       /* lineNo */
    "findDV", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\findDV.m" /* pathName */
};

static emlrtRSInfo e_emlrtRSI = {
    24,       /* lineNo */
    "findDV", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\findDV.m" /* pathName */
};

static emlrtRSInfo f_emlrtRSI = {
    30,       /* lineNo */
    "findDV", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\findDV.m" /* pathName */
};

static emlrtRTEInfo emlrtRTEI = {
    13,     /* lineNo */
    9,      /* colNo */
    "sqrt", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\elfun\\sqrt.m" /* pName
                                                                       */
};

static emlrtRTEInfo b_emlrtRTEI = {
    14,     /* lineNo */
    9,      /* colNo */
    "asin", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\elfun\\asin.m" /* pName
                                                                       */
};

static emlrtRTEInfo c_emlrtRTEI = {
    14,     /* lineNo */
    9,      /* colNo */
    "acos", /* fName */
    "C:\\Program "
    "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\elfun\\acos.m" /* pName
                                                                       */
};

/* Function Definitions */
void findDV(const emlrtStack *sp, const real_T vvrel_A[3],
            const real_T vvrel_D[3], real_T muPL, real_T rpmin, real_T *dv,
            real_T *alpha, real_T *alpha_A)
{
  ptrdiff_t incx_t;
  ptrdiff_t incy_t;
  ptrdiff_t n_t;
  emlrtStack st;
  real_T a_data[3];
  real_T b_data[3];
  real_T absxk;
  real_T alpha_tmp;
  real_T b_alpha_tmp;
  real_T b_scale;
  real_T c;
  real_T scale;
  real_T t;
  st.prev = sp;
  st.tls = sp->tls;
  /*  DESCRIPTION */
  /*  This function computes DV defects. */
  /*  */
  /*  INPUT */
  /*  - vvrel_A : 1x3 vector with incoming relative velocity [km/s] */
  /*  - vvrel_D : 1x3 vector with outgoing relative velocity [km/s] */
  /*  - muPL    : gravitational parameter of the flyby body [km3/s2] */
  /*  - rpmin   : minimum flyby periapsis [km] */
  /*   */
  /*  OUTPUT */
  /*  - dv      : DV defect manoeuvre [km/s] */
  /*  - alpha   : deflection required for the flyby [rad] */
  /*  - alpha_A : max. deflection for the minimum periapsis flyby [rad] */
  /*  */
  /*  -------------------------------------------------------------------------
   */
  a_data[0] = vvrel_A[0];
  b_data[0] = vvrel_D[0];
  a_data[1] = vvrel_A[1];
  b_data[1] = vvrel_D[1];
  a_data[2] = vvrel_A[2];
  b_data[2] = vvrel_D[2];
  n_t = (ptrdiff_t)3;
  incx_t = (ptrdiff_t)1;
  incy_t = (ptrdiff_t)1;
  c = ddot(&n_t, &a_data[0], &incx_t, &b_data[0], &incy_t);
  st.site = &emlrtRSI;
  scale = 3.3121686421112381E-170;
  b_scale = 3.3121686421112381E-170;
  absxk = muDoubleScalarAbs(vvrel_A[0]);
  if (absxk > 3.3121686421112381E-170) {
    alpha_tmp = 1.0;
    scale = absxk;
  } else {
    t = absxk / 3.3121686421112381E-170;
    alpha_tmp = t * t;
  }
  absxk = muDoubleScalarAbs(vvrel_D[0]);
  if (absxk > 3.3121686421112381E-170) {
    b_alpha_tmp = 1.0;
    b_scale = absxk;
  } else {
    t = absxk / 3.3121686421112381E-170;
    b_alpha_tmp = t * t;
  }
  absxk = muDoubleScalarAbs(vvrel_A[1]);
  if (absxk > scale) {
    t = scale / absxk;
    alpha_tmp = alpha_tmp * t * t + 1.0;
    scale = absxk;
  } else {
    t = absxk / scale;
    alpha_tmp += t * t;
  }
  absxk = muDoubleScalarAbs(vvrel_D[1]);
  if (absxk > b_scale) {
    t = b_scale / absxk;
    b_alpha_tmp = b_alpha_tmp * t * t + 1.0;
    b_scale = absxk;
  } else {
    t = absxk / b_scale;
    b_alpha_tmp += t * t;
  }
  absxk = muDoubleScalarAbs(vvrel_A[2]);
  if (absxk > scale) {
    t = scale / absxk;
    alpha_tmp = alpha_tmp * t * t + 1.0;
    scale = absxk;
  } else {
    t = absxk / scale;
    alpha_tmp += t * t;
  }
  absxk = muDoubleScalarAbs(vvrel_D[2]);
  if (absxk > b_scale) {
    t = b_scale / absxk;
    b_alpha_tmp = b_alpha_tmp * t * t + 1.0;
    b_scale = absxk;
  } else {
    t = absxk / b_scale;
    b_alpha_tmp += t * t;
  }
  alpha_tmp = scale * muDoubleScalarSqrt(alpha_tmp);
  b_alpha_tmp = b_scale * muDoubleScalarSqrt(b_alpha_tmp);
  *alpha = c / (alpha_tmp * b_alpha_tmp);
  if ((*alpha < -1.0) || (*alpha > 1.0)) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "acos");
  }
  *alpha = muDoubleScalarAcos(*alpha);
  /*  turning angle */
  /*  max. deflection hyperbola eccentricity */
  st.site = &c_emlrtRSI;
  scale = alpha_tmp * alpha_tmp;
  c = 1.0 / (rpmin * scale / muPL + 1.0);
  if ((c < -1.0) || (c > 1.0)) {
    emlrtErrorWithMessageIdR2018a(
        &st, &b_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
  }
  c = muDoubleScalarAsin(c);
  /*  max. deflection turning angle */
  st.site = &d_emlrtRSI;
  wrapToPi(&st, alpha);
  *alpha_A = 2.0 * c;
  st.site = &e_emlrtRSI;
  wrapToPi(&st, alpha_A);
  /*  --> compute the DV */
  if (*alpha <= *alpha_A) {
    *dv = muDoubleScalarAbs(b_alpha_tmp - alpha_tmp);
  } else {
    st.site = &f_emlrtRSI;
    *dv = (scale + b_alpha_tmp * b_alpha_tmp) -
          2.0 * alpha_tmp * b_alpha_tmp * muDoubleScalarCos(*alpha_A - *alpha);
    if (*dv < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    *dv = muDoubleScalarSqrt(*dv);
  }
}

/* End of code generation (findDV.c) */
