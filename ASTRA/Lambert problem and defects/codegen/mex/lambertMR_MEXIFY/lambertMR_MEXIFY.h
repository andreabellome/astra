/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lambertMR_MEXIFY.h
 *
 * Code generation for function 'lambertMR_MEXIFY'
 *
 */

#pragma once

/* Include files */
#include "rtwtypes.h"
#include "emlrt.h"
#include "mex.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function Declarations */
void lambertMR_MEXIFY(const emlrtStack *sp, const real_T RI[3],
                      const real_T RF[3], real_T TOF, real_T MU, real_T Nrev,
                      real_T Ncase, real_T VI[3], real_T VF[3]);

void sigmax_init(void);

/* End of code generation (lambertMR_MEXIFY.h) */
