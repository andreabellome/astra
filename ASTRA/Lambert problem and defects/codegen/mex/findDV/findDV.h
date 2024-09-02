/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * findDV.h
 *
 * Code generation for function 'findDV'
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
void findDV(const emlrtStack *sp, const real_T vvrel_A[3],
            const real_T vvrel_D[3], real_T muPL, real_T rpmin, real_T *dv,
            real_T *alpha, real_T *alpha_A);

/* End of code generation (findDV.h) */
