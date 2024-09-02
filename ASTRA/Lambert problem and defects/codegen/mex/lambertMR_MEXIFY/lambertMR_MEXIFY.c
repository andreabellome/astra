/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * lambertMR_MEXIFY.c
 *
 * Code generation for function 'lambertMR_MEXIFY'
 *
 */

/* Include files */
#include "lambertMR_MEXIFY.h"
#include "acos.h"
#include "acosh.h"
#include "asin.h"
#include "asinh.h"
#include "dot.h"
#include "lambertMR_MEXIFY_data.h"
#include "mod.h"
#include "norm.h"
#include "power.h"
#include "rt_nonfinite.h"
#include "sqrt.h"
#include "mwmathutil.h"
#include <math.h>
#include <string.h>

/* Variable Definitions */
static real_T an[25];

static emlrtRSInfo emlrtRSI = {
    23,                 /* lineNo */
    "lambertMR_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo b_emlrtRSI = {
    35,                 /* lineNo */
    "lambertMR_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo c_emlrtRSI = {
    57,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo d_emlrtRSI = {
    59,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo e_emlrtRSI = {
    80,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo f_emlrtRSI = {
    82,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo g_emlrtRSI = {
    93,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo h_emlrtRSI = {
    94,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo i_emlrtRSI = {
    95,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo j_emlrtRSI = {
    98,                        /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo k_emlrtRSI = {
    101,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo l_emlrtRSI = {
    102,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo m_emlrtRSI = {
    128,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo n_emlrtRSI = {
    143,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo o_emlrtRSI = {
    149,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo p_emlrtRSI = {
    155,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo q_emlrtRSI = {
    158,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo r_emlrtRSI = {
    159,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo s_emlrtRSI = {
    163,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo t_emlrtRSI = {
    164,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo u_emlrtRSI = {
    197,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo v_emlrtRSI = {
    198,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo w_emlrtRSI = {
    200,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo x_emlrtRSI = {
    216,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo y_emlrtRSI = {
    218,                       /* lineNo */
    "lambert_ZeroRevs_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ab_emlrtRSI = {
    44,       /* lineNo */
    "mpower", /* fcnName */
    "C:\\Program "
    "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\matfun\\mpower.m" /* pathName
                                                                          */
};

static emlrtRSInfo bb_emlrtRSI =
    {
        71,      /* lineNo */
        "power", /* fcnName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\ops\\power.m" /* pathName
                                                                          */
};

static emlrtRSInfo cb_emlrtRSI = {
    294,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo db_emlrtRSI = {
    298,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo eb_emlrtRSI = {
    300,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo fb_emlrtRSI = {
    312,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo gb_emlrtRSI = {
    315,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo hb_emlrtRSI = {
    317,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ib_emlrtRSI = {
    324,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo jb_emlrtRSI = {
    332,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo kb_emlrtRSI = {
    333,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo lb_emlrtRSI = {
    352,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo mb_emlrtRSI = {
    354,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo nb_emlrtRSI = {
    357,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ob_emlrtRSI = {
    361,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo pb_emlrtRSI = {
    362,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo qb_emlrtRSI = {
    383,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo rb_emlrtRSI = {
    385,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo sb_emlrtRSI = {
    387,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo tb_emlrtRSI = {
    389,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ub_emlrtRSI = {
    390,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo vb_emlrtRSI = {
    394,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo wb_emlrtRSI = {
    396,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo xb_emlrtRSI = {
    399,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo yb_emlrtRSI = {
    414,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ac_emlrtRSI = {
    431,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo bc_emlrtRSI = {
    435,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo cc_emlrtRSI = {
    437,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo dc_emlrtRSI = {
    439,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ec_emlrtRSI = {
    440,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo fc_emlrtRSI = {
    442,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo gc_emlrtRSI = {
    443,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo hc_emlrtRSI = {
    445,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ic_emlrtRSI = {
    446,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo jc_emlrtRSI = {
    466,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo kc_emlrtRSI = {
    467,              /* lineNo */
    "lambert_MEXIFY", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo pc_emlrtRSI = {
    757,                  /* lineNo */
    "LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo tc_emlrtRSI = {
    516,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo uc_emlrtRSI = {
    517,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo vc_emlrtRSI = {
    521,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo wc_emlrtRSI = {
    525,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo xc_emlrtRSI = {
    536,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo yc_emlrtRSI = {
    538,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ad_emlrtRSI = {
    539,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo bd_emlrtRSI = {
    545,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo cd_emlrtRSI = {
    547,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo dd_emlrtRSI = {
    559,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ed_emlrtRSI = {
    560,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo fd_emlrtRSI = {
    564,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo gd_emlrtRSI = {
    566,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo hd_emlrtRSI = {
    579,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo id_emlrtRSI = {
    581,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo jd_emlrtRSI = {
    593,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo kd_emlrtRSI = {
    596,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ld_emlrtRSI = {
    598,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo md_emlrtRSI = {
    608,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo nd_emlrtRSI = {
    618,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo od_emlrtRSI = {
    622,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo pd_emlrtRSI = {
    624,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo qd_emlrtRSI = {
    626,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo rd_emlrtRSI = {
    634,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo sd_emlrtRSI = {
    637,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo td_emlrtRSI = {
    641,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ud_emlrtRSI = {
    645,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo vd_emlrtRSI = {
    664,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo wd_emlrtRSI = {
    670,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo xd_emlrtRSI = {
    672,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo yd_emlrtRSI = {
    681,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo ae_emlrtRSI = {
    687,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo be_emlrtRSI = {
    689,                          /* lineNo */
    "lambert_LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRSInfo me_emlrtRSI = {
    756,                  /* lineNo */
    "LancasterBlanchard", /* fcnName */
    "C:\\Users\\andre\\Documents\\GitHub\\astra_def\\ASTRA\\Lambert problem "
    "and defects\\lambertMR_MEXIFY.m" /* pathName */
};

static emlrtRTEInfo b_emlrtRTEI =
    {
        82,         /* lineNo */
        5,          /* colNo */
        "fltpower", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\ops\\power.m" /* pName
                                                                          */
};

static emlrtRTEInfo e_emlrtRTEI =
    {
        14,    /* lineNo */
        9,     /* colNo */
        "log", /* fName */
        "C:\\Program "
        "Files\\MATLAB\\R2022b\\toolbox\\eml\\lib\\matlab\\elfun\\log.m" /* pName
                                                                          */
};

static const int16_T iv[25] = {0,   2,   6,   12,  20,  30,  42,  56,  72,
                               90,  110, 132, 156, 182, 210, 240, 272, 306,
                               342, 380, 420, 462, 506, 552, 600};

/* Function Declarations */
static real_T LancasterBlanchard(const emlrtStack *sp, real_T q, real_T m);

static void b_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                 real_T m, real_T *T, real_T *Tp, real_T *Tpp);

static void c_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                 real_T m, real_T *T, real_T *Tp, real_T *Tpp,
                                 real_T *Tppp);

static real_T d_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                   real_T m);

static void lambert_LancasterBlanchard(const emlrtStack *sp,
                                       const real_T r1vec[3],
                                       const real_T r2vec[3], real_T tf,
                                       real_T m, real_T muC, real_T V1[3],
                                       real_T V2[3], real_T *exitflag);

static void lambert_ZeroRevs_MEXIFY(const emlrtStack *sp, const real_T RI[3],
                                    const real_T RF[3], real_T TOF, real_T MU,
                                    real_T VI[3], real_T VF[3]);

/* Function Definitions */
static real_T LancasterBlanchard(const emlrtStack *sp, real_T q, real_T m)
{
  emlrtStack st;
  real_T z;
  st.prev = sp;
  st.tls = sp->tls;
  /*  Lancaster & Blanchard's function, and three derivatives thereof */
  /*  protection against idiotic input */
  /*  compute parameter E */
  /*  T(x), T'(x), T''(x) */
  /*  all other cases */
  /*  compute all substitution functions */
  z = q * q;
  st.site = &pc_emlrtRSI;
  if (-z + 1.0 < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  z = muDoubleScalarSqrt(-z + 1.0);
  /*  BUGFIX: (Simon Tardivel) this line is incorrect for E==0 and f+g==0 */
  /*  d  = (E < 0)*(atan2(f, g) + pi*m) + (E > 0)*log( max(0, f + g) ); */
  /*  it should be written out like so: */
  /*  T(x) */
  return -(2.0 *
           ((0.0 - q * z) - (muDoubleScalarAtan2(z - q * 0.0, 0.0 * z - (-q)) +
                             3.1415926535897931 * m)));
  /*   T'(x) */
  /*  T''(x) */
  /*  T'''(x) */
}

static void b_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                 real_T m, real_T *T, real_T *Tp, real_T *Tpp)
{
  emlrtStack st;
  real_T E_tmp;
  int32_T i;
  st.prev = sp;
  st.tls = sp->tls;
  /*  Lancaster & Blanchard's function, and three derivatives thereof */
  /*  protection against idiotic input */
  if (x < -1.0) {
    /*  impossible; negative eccentricity */
    x = muDoubleScalarAbs(x) - 2.0;
  } else if (x == -1.0) {
    /*  impossible; offset x slightly */
    x = -0.99999999999999978;
  }
  /*  compute parameter E */
  E_tmp = x * x;
  /*  T(x), T'(x), T''(x) */
  if (x == 1.0) {
    /*  exactly parabolic; solutions known exactly */
    /*  T(x) */
    *T = 1.3333333333333333 * (1.0 - muDoubleScalarPower(q, 3.0));
    /*  T'(x) */
    *Tp = 0.8 * (muDoubleScalarPower(q, 5.0) - 1.0);
    /*  T''(x) */
    *Tpp = *Tp + 1.7142857142857142 * (1.0 - muDoubleScalarPower(q, 7.0));
    /*  T'''(x) */
  } else if (muDoubleScalarAbs(x - 1.0) < 0.01) {
    real_T b_powers[25];
    real_T dv[25];
    real_T powers[25];
    real_T f;
    real_T g;
    real_T y;
    real_T z_tmp;
    /*  near-parabolic; compute with series */
    /*  evaluate sigma */
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(-(E_tmp - 1.0), powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    y = -(E_tmp - 1.0) * q * q;
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(y, b_powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    /*  T(x) */
    f = 0.0;
    g = 0.0;
    for (i = 0; i < 25; i++) {
      z_tmp = an[i];
      f += powers[i] * z_tmp;
      g += b_powers[i] * z_tmp;
    }
    *T = (f + 1.3333333333333333) -
         muDoubleScalarPower(q, 3.0) * (g + 1.3333333333333333);
    /*  T'(x) */
    dv[0] = 1.0;
    for (i = 0; i < 24; i++) {
      dv[i + 1] = ((real_T)i + 2.0) * b_powers[i];
    }
    z_tmp = 0.0;
    for (i = 0; i < 25; i++) {
      z_tmp += dv[i] * an[i];
    }
    dv[0] = 1.0;
    for (i = 0; i < 24; i++) {
      dv[i + 1] = ((real_T)i + 2.0) * powers[i];
    }
    f = 0.0;
    for (i = 0; i < 25; i++) {
      f += dv[i] * an[i];
    }
    *Tp = 2.0 * x * (muDoubleScalarPower(q, 5.0) * z_tmp - f);
    /*  T''(x) */
    dv[0] = (real_T)iv[0] * (1.0 / -(E_tmp - 1.0));
    dv[1] = iv[1];
    for (i = 0; i < 23; i++) {
      dv[i + 2] = (real_T)iv[i + 2] * powers[i];
    }
    z_tmp = 0.0;
    for (i = 0; i < 25; i++) {
      z_tmp += dv[i] * an[i];
    }
    dv[0] = (real_T)iv[0] * (1.0 / y);
    dv[1] = iv[1];
    for (i = 0; i < 23; i++) {
      dv[i + 2] = (real_T)iv[i + 2] * b_powers[i];
    }
    f = 0.0;
    for (i = 0; i < 25; i++) {
      f += dv[i] * an[i];
    }
    *Tpp = *Tp / x + 4.0 * E_tmp * (z_tmp - muDoubleScalarPower(q, 7.0) * f);
    /*  T'''(x) */
  } else {
    real_T f;
    real_T g;
    real_T y;
    real_T z;
    real_T z_tmp;
    /*  all other cases */
    /*  compute all substitution functions */
    y = muDoubleScalarAbs(E_tmp - 1.0);
    st.site = &me_emlrtRSI;
    if (y < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    y = muDoubleScalarSqrt(y);
    z_tmp = q * q;
    z = z_tmp * (E_tmp - 1.0) + 1.0;
    st.site = &pc_emlrtRSI;
    if (z < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    z = muDoubleScalarSqrt(z);
    f = y * (z - q * x);
    g = x * z - q * (E_tmp - 1.0);
    /*  BUGFIX: (Simon Tardivel) this line is incorrect for E==0 and f+g==0 */
    /*  d  = (E < 0)*(atan2(f, g) + pi*m) + (E > 0)*log( max(0, f + g) ); */
    /*  it should be written out like so: */
    if (E_tmp - 1.0 < 0.0) {
      f = muDoubleScalarAtan2(f, g) + 3.1415926535897931 * m;
    } else if (E_tmp - 1.0 == 0.0) {
      f = 0.0;
    } else {
      f = muDoubleScalarLog(muDoubleScalarMax(0.0, f + g));
    }
    /*  T(x) */
    *T = 2.0 * ((x - q * z) - f / y) / (E_tmp - 1.0);
    /*   T'(x) */
    f = muDoubleScalarPower(q, 3.0);
    *Tp = ((4.0 - 4.0 * f * x / z) - 3.0 * x * *T) / (E_tmp - 1.0);
    /*  T''(x) */
    *Tpp = ((-4.0 * f / z * (1.0 - z_tmp * E_tmp / (z * z)) - 3.0 * *T) -
            3.0 * x * *Tp) /
           (E_tmp - 1.0);
    /*  T'''(x) */
  }
}

static void c_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                 real_T m, real_T *T, real_T *Tp, real_T *Tpp,
                                 real_T *Tppp)
{
  static const int16_T b_iv[25] = {0,    0,     6,     24,   60,   120,  210,
                                   336,  504,   720,   990,  1320, 1716, 2184,
                                   2730, 3360,  4080,  4896, 5814, 6840, 7980,
                                   9240, 10626, 12144, 13800};
  emlrtStack st;
  real_T E_tmp;
  int32_T i;
  st.prev = sp;
  st.tls = sp->tls;
  /*  Lancaster & Blanchard's function, and three derivatives thereof */
  /*  protection against idiotic input */
  if (x < -1.0) {
    /*  impossible; negative eccentricity */
    x = muDoubleScalarAbs(x) - 2.0;
  } else if (x == -1.0) {
    /*  impossible; offset x slightly */
    x = -0.99999999999999978;
  }
  /*  compute parameter E */
  E_tmp = x * x;
  /*  T(x), T'(x), T''(x) */
  if (x == 1.0) {
    /*  exactly parabolic; solutions known exactly */
    /*  T(x) */
    *T = 1.3333333333333333 * (1.0 - muDoubleScalarPower(q, 3.0));
    /*  T'(x) */
    *Tp = 0.8 * (muDoubleScalarPower(q, 5.0) - 1.0);
    /*  T''(x) */
    *Tpp = *Tp + 1.7142857142857142 * (1.0 - muDoubleScalarPower(q, 7.0));
    /*  T'''(x) */
    *Tppp = 3.0 * (*Tpp - *Tp) +
            2.2222222222222223 * (muDoubleScalarPower(q, 9.0) - 1.0);
  } else if (muDoubleScalarAbs(x - 1.0) < 0.01) {
    real_T b_powers[25];
    real_T dv[25];
    real_T powers[25];
    real_T Tpp_tmp;
    real_T b_Tpp_tmp;
    real_T f;
    real_T g;
    real_T y;
    /*  near-parabolic; compute with series */
    /*  evaluate sigma */
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(-(E_tmp - 1.0), powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    y = -(E_tmp - 1.0) * q * q;
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(y, b_powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    /*  T(x) */
    f = 0.0;
    g = 0.0;
    for (i = 0; i < 25; i++) {
      Tpp_tmp = an[i];
      f += powers[i] * Tpp_tmp;
      g += b_powers[i] * Tpp_tmp;
    }
    *T = (f + 1.3333333333333333) -
         muDoubleScalarPower(q, 3.0) * (g + 1.3333333333333333);
    /*  T'(x) */
    dv[0] = 1.0;
    for (i = 0; i < 24; i++) {
      dv[i + 1] = ((real_T)i + 2.0) * b_powers[i];
    }
    Tpp_tmp = 0.0;
    for (i = 0; i < 25; i++) {
      Tpp_tmp += dv[i] * an[i];
    }
    dv[0] = 1.0;
    for (i = 0; i < 24; i++) {
      dv[i + 1] = ((real_T)i + 2.0) * powers[i];
    }
    g = 0.0;
    for (i = 0; i < 25; i++) {
      g += dv[i] * an[i];
    }
    *Tp = 2.0 * x * (muDoubleScalarPower(q, 5.0) * Tpp_tmp - g);
    /*  T''(x) */
    Tpp_tmp = 1.0 / -(E_tmp - 1.0);
    dv[0] = (real_T)iv[0] * Tpp_tmp;
    dv[1] = iv[1];
    for (i = 0; i < 23; i++) {
      dv[i + 2] = (real_T)iv[i + 2] * powers[i];
    }
    g = 0.0;
    for (i = 0; i < 25; i++) {
      g += dv[i] * an[i];
    }
    dv[0] = (real_T)iv[0] * (1.0 / y);
    dv[1] = iv[1];
    for (i = 0; i < 23; i++) {
      dv[i + 2] = (real_T)iv[i + 2] * b_powers[i];
    }
    f = 0.0;
    for (i = 0; i < 25; i++) {
      f += dv[i] * an[i];
    }
    b_Tpp_tmp = *Tp / x;
    *Tpp = b_Tpp_tmp + 4.0 * E_tmp * (g - muDoubleScalarPower(q, 7.0) * f);
    /*  T'''(x) */
    dv[0] = (real_T)b_iv[0] * (1.0 / y / y);
    dv[1] = (real_T)b_iv[1] * (1.0 / y);
    dv[2] = b_iv[2];
    for (i = 0; i < 22; i++) {
      dv[i + 3] = (real_T)b_iv[i + 3] * b_powers[i];
    }
    g = 0.0;
    for (i = 0; i < 25; i++) {
      g += dv[i] * an[i];
    }
    dv[0] = (real_T)b_iv[0] * (Tpp_tmp / -(E_tmp - 1.0));
    dv[1] = (real_T)b_iv[1] * Tpp_tmp;
    dv[2] = b_iv[2];
    for (i = 0; i < 22; i++) {
      dv[i + 3] = (real_T)b_iv[i + 3] * powers[i];
    }
    Tpp_tmp = 0.0;
    for (i = 0; i < 25; i++) {
      Tpp_tmp += dv[i] * an[i];
    }
    *Tppp = 3.0 * (*Tpp - b_Tpp_tmp) / x +
            8.0 * x * x * (muDoubleScalarPower(q, 9.0) * g - Tpp_tmp);
  } else {
    real_T Tpp_tmp;
    real_T b_Tpp_tmp;
    real_T f;
    real_T g;
    real_T y;
    real_T z;
    real_T z_tmp;
    /*  all other cases */
    /*  compute all substitution functions */
    y = muDoubleScalarAbs(E_tmp - 1.0);
    st.site = &me_emlrtRSI;
    if (y < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    y = muDoubleScalarSqrt(y);
    z_tmp = q * q;
    z = z_tmp * (E_tmp - 1.0) + 1.0;
    st.site = &pc_emlrtRSI;
    if (z < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    z = muDoubleScalarSqrt(z);
    f = y * (z - q * x);
    g = x * z - q * (E_tmp - 1.0);
    /*  BUGFIX: (Simon Tardivel) this line is incorrect for E==0 and f+g==0 */
    /*  d  = (E < 0)*(atan2(f, g) + pi*m) + (E > 0)*log( max(0, f + g) ); */
    /*  it should be written out like so: */
    if (E_tmp - 1.0 < 0.0) {
      f = muDoubleScalarAtan2(f, g) + 3.1415926535897931 * m;
    } else if (E_tmp - 1.0 == 0.0) {
      f = 0.0;
    } else {
      f = muDoubleScalarLog(muDoubleScalarMax(0.0, f + g));
    }
    /*  T(x) */
    *T = 2.0 * ((x - q * z) - f / y) / (E_tmp - 1.0);
    /*   T'(x) */
    f = muDoubleScalarPower(q, 3.0);
    g = 4.0 * f;
    *Tp = ((4.0 - g * x / z) - 3.0 * x * *T) / (E_tmp - 1.0);
    /*  T''(x) */
    b_Tpp_tmp = z * z;
    Tpp_tmp = 1.0 - z_tmp * E_tmp / b_Tpp_tmp;
    *Tpp =
        ((-4.0 * f / z * Tpp_tmp - 3.0 * *T) - 3.0 * x * *Tp) / (E_tmp - 1.0);
    /*  T'''(x) */
    *Tppp =
        ((g / b_Tpp_tmp * (Tpp_tmp + 2.0 * z_tmp * x / b_Tpp_tmp * (z - x)) -
          8.0 * *Tp) -
         7.0 * x * *Tpp) /
        (E_tmp - 1.0);
  }
}

static real_T d_LancasterBlanchard(const emlrtStack *sp, real_T x, real_T q,
                                   real_T m)
{
  emlrtStack st;
  real_T E;
  real_T T;
  int32_T i;
  st.prev = sp;
  st.tls = sp->tls;
  /*  Lancaster & Blanchard's function, and three derivatives thereof */
  /*  protection against idiotic input */
  if (x == -1.0) {
    /*  impossible; offset x slightly */
    x = -0.99999999999999978;
  }
  /*  compute parameter E */
  E = x * x - 1.0;
  /*  T(x), T'(x), T''(x) */
  if (x == 1.0) {
    /*  exactly parabolic; solutions known exactly */
    /*  T(x) */
    T = 1.3333333333333333 * (1.0 - muDoubleScalarPower(q, 3.0));
    /*  T'(x) */
    /*  T''(x) */
    /*  T'''(x) */
  } else if (muDoubleScalarAbs(x - 1.0) < 0.01) {
    real_T b_powers[25];
    real_T powers[25];
    real_T d;
    real_T f;
    /*  near-parabolic; compute with series */
    /*  evaluate sigma */
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(-E, powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    /*  series approximation to T(x) and its derivatives */
    /*  (used for near-parabolic cases) */
    /*  preload the factors [an] */
    /*  (25 factors is more than enough for 16-digit accuracy) */
    /*  powers of y */
    power(-E * q * q, b_powers);
    /*  sigma itself */
    /*  dsigma / dx (derivative) */
    /*  d2sigma / dx2 (second derivative) */
    /*  d3sigma / dx3 (third derivative) */
    /*  T(x) */
    d = 0.0;
    f = 0.0;
    for (i = 0; i < 25; i++) {
      real_T g;
      g = an[i];
      d += powers[i] * g;
      f += b_powers[i] * g;
    }
    T = (d + 1.3333333333333333) -
        muDoubleScalarPower(q, 3.0) * (f + 1.3333333333333333);
    /*  T'(x) */
    /*  T''(x) */
    /*  T'''(x) */
  } else {
    real_T d;
    real_T f;
    real_T g;
    real_T y;
    real_T z;
    /*  all other cases */
    /*  compute all substitution functions */
    y = muDoubleScalarAbs(E);
    st.site = &me_emlrtRSI;
    if (y < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    y = muDoubleScalarSqrt(y);
    z = q * q * E + 1.0;
    st.site = &pc_emlrtRSI;
    if (z < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    z = muDoubleScalarSqrt(z);
    f = y * (z - q * x);
    g = x * z - q * E;
    /*  BUGFIX: (Simon Tardivel) this line is incorrect for E==0 and f+g==0 */
    /*  d  = (E < 0)*(atan2(f, g) + pi*m) + (E > 0)*log( max(0, f + g) ); */
    /*  it should be written out like so: */
    if (E < 0.0) {
      d = muDoubleScalarAtan2(f, g) + 3.1415926535897931 * m;
    } else if (E == 0.0) {
      d = 0.0;
    } else {
      d = muDoubleScalarLog(muDoubleScalarMax(0.0, f + g));
    }
    /*  T(x) */
    T = 2.0 * ((x - q * z) - d / y) / E;
    /*   T'(x) */
    /*  T''(x) */
    /*  T'''(x) */
  }
  return T;
}

static void lambert_LancasterBlanchard(const emlrtStack *sp,
                                       const real_T r1vec[3],
                                       const real_T r2vec[3], real_T tf,
                                       real_T m, real_T muC, real_T V1[3],
                                       real_T V2[3], real_T *exitflag)
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T T;
  real_T T0;
  real_T Td;
  real_T Tp;
  real_T a;
  real_T b_gamma;
  real_T c;
  real_T crsprod_idx_0;
  real_T crsprod_idx_1;
  real_T crsprod_idx_2;
  real_T d;
  real_T dth;
  real_T mcrsprd;
  real_T phr;
  real_T phr_tmp;
  real_T q;
  real_T r1;
  real_T r1unit_idx_0;
  real_T r1unit_idx_1;
  real_T r1unit_idx_2;
  real_T r2;
  real_T r2unit_idx_0;
  real_T r2unit_idx_1;
  real_T r2unit_idx_2;
  real_T s;
  real_T th1unit_idx_0;
  real_T th1unit_idx_1;
  real_T th1unit_idx_2;
  real_T th2unit_idx_0;
  real_T th2unit_idx_1;
  real_T th2unit_idx_2;
  real_T xM;
  int32_T iterations;
  boolean_T guard1 = false;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  /*  ----------------------------------------------------------------- */
  /*  Lancaster & Blanchard version, with improvements by Gooding */
  /*  Very reliable, moderately fast for both simple and complicated cases */
  /*  ----------------------------------------------------------------- */
  /* { */
  /* LAMBERT_LANCASTERBLANCHARD       High-Thrust Lambert-targeter */
  /* lambert_LancasterBlanchard() uses the method developed by */
  /* Lancaster & Blancard, as described in their 1969 paper. Initial values, */
  /* and several details of the procedure, are provided by R.H. Gooding, */
  /* as described in his 1990 paper. */
  /* } */
  /*  Please report bugs and inquiries to: */
  /*  */
  /*  Name       : Rody P.S. Oldenhuis */
  /*  E-mail     : oldenhuis@gmail.com */
  /*  Licence    : 2-clause BSD (see License.txt) */
  /*  If you find this work useful, please consider a donation: */
  /*  https://www.paypal.me/RodyO/3.5 */
  /*  ADJUSTED FOR EML-COMPILATION 29/Sep/2009 */
  /*  manipulate input */
  /*  optimum for numerical noise v.s. actual precision */
  r1 = (r1vec[0] * r1vec[0] + r1vec[1] * r1vec[1]) + r1vec[2] * r1vec[2];
  st.site = &tc_emlrtRSI;
  if (r1 < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  r1 = muDoubleScalarSqrt(r1);
  /*  magnitude of r1vec */
  r2 = (r2vec[0] * r2vec[0] + r2vec[1] * r2vec[1]) + r2vec[2] * r2vec[2];
  st.site = &uc_emlrtRSI;
  if (r2 < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  r2 = muDoubleScalarSqrt(r2);
  /*  magnitude of r2vec */
  /*  unit vector of r1vec */
  /*  unit vector of r2vec */
  crsprod_idx_0 = r1vec[1] * r2vec[2] - r2vec[1] * r1vec[2];
  crsprod_idx_1 = r2vec[0] * r1vec[2] - r1vec[0] * r2vec[2];
  crsprod_idx_2 = r1vec[0] * r2vec[1] - r2vec[0] * r1vec[1];
  /*  cross product of r1vec and r2vec */
  r1unit_idx_0 = r1vec[0] / r1;
  r2unit_idx_0 = r2vec[0] / r2;
  r1unit_idx_1 = r1vec[1] / r1;
  r2unit_idx_1 = r2vec[1] / r2;
  r1unit_idx_2 = r1vec[2] / r1;
  r2unit_idx_2 = r2vec[2] / r2;
  mcrsprd = (crsprod_idx_0 * crsprod_idx_0 + crsprod_idx_1 * crsprod_idx_1) +
            crsprod_idx_2 * crsprod_idx_2;
  st.site = &vc_emlrtRSI;
  if (mcrsprd < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  mcrsprd = muDoubleScalarSqrt(mcrsprd);
  /*  magnitude of that cross product */
  crsprod_idx_0 /= mcrsprd;
  crsprod_idx_1 /= mcrsprd;
  crsprod_idx_2 /= mcrsprd;
  th1unit_idx_0 = crsprod_idx_1 * r1unit_idx_2 - r1unit_idx_1 * crsprod_idx_2;
  th1unit_idx_1 = r1unit_idx_0 * crsprod_idx_2 - crsprod_idx_0 * r1unit_idx_2;
  th1unit_idx_2 = crsprod_idx_0 * r1unit_idx_1 - r1unit_idx_0 * crsprod_idx_1;
  /*  unit vectors in the tangential-directions */
  th2unit_idx_0 = crsprod_idx_1 * r2unit_idx_2 - r2unit_idx_1 * crsprod_idx_2;
  th2unit_idx_1 = r2unit_idx_0 * crsprod_idx_2 - crsprod_idx_0 * r2unit_idx_2;
  th2unit_idx_2 = crsprod_idx_0 * r2unit_idx_1 - r2unit_idx_0 * crsprod_idx_1;
  /*  make 100.4% sure it's in (-1 <= x <= +1) */
  dth = muDoubleScalarMax(-1.0, muDoubleScalarMin(1.0, ((r1vec[0] * r2vec[0] +
                                                         r1vec[1] * r2vec[1]) +
                                                        r1vec[2] * r2vec[2]) /
                                                           r1 / r2));
  st.site = &wc_emlrtRSI;
  if (dth > 1.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &d_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "acos");
  }
  dth = muDoubleScalarAcos(dth);
  /*  turn angle */
  /*  if the long way was selected, the turn-angle must be negative */
  /*  to take care of the direction of final velocity */
  mcrsprd = muDoubleScalarSign(tf);
  tf = muDoubleScalarAbs(tf);
  if (mcrsprd < 0.0) {
    dth -= 6.2831853071795862;
  }
  /*  left-branch */
  crsprod_idx_1 = muDoubleScalarSign(m);
  m = muDoubleScalarAbs(m);
  /*  define constants */
  st.site = &xc_emlrtRSI;
  b_st.site = &ab_emlrtRSI;
  st.site = &xc_emlrtRSI;
  b_st.site = &ab_emlrtRSI;
  c = (r1 * r1 + r2 * r2) - 2.0 * r1 * r2 * muDoubleScalarCos(dth);
  st.site = &xc_emlrtRSI;
  if (c < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  c = muDoubleScalarSqrt(c);
  s = ((r1 + r2) + c) / 2.0;
  st.site = &yc_emlrtRSI;
  b_st.site = &ab_emlrtRSI;
  d = 8.0 * muC / muDoubleScalarPower(s, 3.0);
  st.site = &yc_emlrtRSI;
  if (d < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  d = muDoubleScalarSqrt(d);
  T = d * tf;
  d = r1 * r2;
  st.site = &ad_emlrtRSI;
  if (d < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  q = muDoubleScalarSqrt(d) / s * muDoubleScalarCos(dth / 2.0);
  /*  general formulae for the initial values (Gooding) */
  /*  ------------------------------------------------- */
  /*  some initial values */
  st.site = &bd_emlrtRSI;
  T0 = LancasterBlanchard(&st, q, m);
  Td = T0 - T;
  st.site = &cd_emlrtRSI;
  b_st.site = &ab_emlrtRSI;
  phr_tmp = q * q;
  phr = b_mod(2.0 * muDoubleScalarAtan2(1.0 - phr_tmp, 2.0 * q));
  /*  initial output is pessimistic */
  V1[0] = rtNaN;
  V2[0] = rtNaN;
  V1[1] = rtNaN;
  V2[1] = rtNaN;
  V1[2] = rtNaN;
  V2[2] = rtNaN;
  /*  extremal_distances = [NaN, NaN]; */
  /*  single-revolution case */
  guard1 = false;
  if (m == 0.0) {
    if (Td > 0.0) {
      phr = T0 * Td / 4.0 / T;
    } else {
      crsprod_idx_0 = Td / (4.0 - Td);
      crsprod_idx_1 = -Td / (T + T0 / 2.0);
      st.site = &dd_emlrtRSI;
      if (crsprod_idx_1 < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      crsprod_idx_1 = muDoubleScalarSqrt(crsprod_idx_1);
      mcrsprd = 2.0 - phr / 3.1415926535897931;
      st.site = &ed_emlrtRSI;
      if (mcrsprd < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      mcrsprd = muDoubleScalarSqrt(mcrsprd);
      mcrsprd = crsprod_idx_0 + 1.7 * mcrsprd;
      if (mcrsprd >= 0.0) {
        crsprod_idx_2 = crsprod_idx_0;
      } else {
        st.site = &fd_emlrtRSI;
        b_st.site = &bb_emlrtRSI;
        crsprod_idx_2 = crsprod_idx_0 + muDoubleScalarPower(-mcrsprd, 0.0625) *
                                            (-crsprod_idx_1 - crsprod_idx_0);
      }
      st.site = &gd_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      st.site = &gd_emlrtRSI;
      if (crsprod_idx_0 + 1.0 < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      phr = ((crsprod_idx_2 * (crsprod_idx_0 + 1.0) / 2.0 + 1.0) -
             0.03 * (crsprod_idx_2 * crsprod_idx_2) *
                 muDoubleScalarSqrt(crsprod_idx_0 + 1.0)) *
            crsprod_idx_2;
    }
    /*  this estimate might not give a solution */
    if (phr < -1.0) {
      *exitflag = -1.0;
    } else {
      /*  multi-revolution case */
      guard1 = true;
    }
  } else {
    int32_T exitg2;
    /*  determine minimum Tp(x) */
    mcrsprd = 4.0 / (9.42477796076938 * (2.0 * m + 1.0));
    if (phr < 3.1415926535897931) {
      st.site = &hd_emlrtRSI;
      a = phr / 3.1415926535897931;
      b_st.site = &ab_emlrtRSI;
      c_st.site = &bb_emlrtRSI;
      if (a < 0.0) {
        emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
                                      "Coder:toolbox:power_domainError",
                                      "Coder:toolbox:power_domainError", 0);
      }
      xM = mcrsprd * muDoubleScalarPower(a, 0.125);
    } else if (phr > 3.1415926535897931) {
      st.site = &id_emlrtRSI;
      a = 2.0 - phr / 3.1415926535897931;
      b_st.site = &ab_emlrtRSI;
      c_st.site = &bb_emlrtRSI;
      if (a < 0.0) {
        emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
                                      "Coder:toolbox:power_domainError",
                                      "Coder:toolbox:power_domainError", 0);
      }
      xM = mcrsprd * (2.0 - muDoubleScalarPower(a, 0.125));
      /*  EMLMEX requires this one */
    } else {
      xM = 0.0;
    }
    /*  use Halley's method */
    Tp = rtInf;
    iterations = 0;
    do {
      exitg2 = 0;
      if (muDoubleScalarAbs(Tp) > 1.0E-12) {
        /*  iterations */
        iterations++;
        /*  compute first three derivatives */
        st.site = &jd_emlrtRSI;
        c_LancasterBlanchard(&st, xM, q, m, &crsprod_idx_0, &Tp, &b_gamma,
                             &crsprod_idx_2);
        /*  new value of xM */
        mcrsprd = xM;
        st.site = &kd_emlrtRSI;
        b_st.site = &bb_emlrtRSI;
        xM -= 2.0 * Tp * b_gamma /
              (2.0 * (b_gamma * b_gamma) - Tp * crsprod_idx_2);
        /*  escape clause */
        st.site = &ld_emlrtRSI;
        if (muDoubleScalarRem(iterations, 7.0) != 0.0) {
          xM = (mcrsprd + xM) / 2.0;
        }
        /*  the method might fail. Exit in that case */
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b((emlrtConstCTX)sp);
        }
        if (iterations > 25) {
          *exitflag = -2.0;
          exitg2 = 1;
        }
      } else {
        /*  xM should be elliptic (-1 < x < 1) */
        /*  (this should be impossible to go wrong) */
        exitg2 = 2;
      }
    } while (exitg2 == 0);
    if (exitg2 != 1) {
      if ((xM < -1.0) || (xM > 1.0)) {
        *exitflag = -1.0;
      } else {
        /*  corresponding time */
        st.site = &md_emlrtRSI;
        mcrsprd = d_LancasterBlanchard(&st, xM, q, m);
        /*  T should lie above the minimum T */
        if (mcrsprd > T) {
          *exitflag = -1.0;
        } else {
          /*  find two initial values for second solution (again with
           * lambda-type patch) */
          /*  --------------------------------------------------------------------------
           */
          /*  some initial values */
          crsprod_idx_2 = T - mcrsprd;
          st.site = &nd_emlrtRSI;
          b_LancasterBlanchard(&st, xM, q, m, &crsprod_idx_0, &Tp, &b_gamma);
          /*  first estimate (only if m > 0) */
          if (crsprod_idx_1 > 0.0) {
            st.site = &od_emlrtRSI;
            b_st.site = &ab_emlrtRSI;
            phr = crsprod_idx_2 /
                  (b_gamma / 2.0 + crsprod_idx_2 / ((1.0 - xM) * (1.0 - xM)));
            st.site = &od_emlrtRSI;
            if (phr < 0.0) {
              emlrtErrorWithMessageIdR2018a(
                  &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                  "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
            }
            phr = muDoubleScalarSqrt(phr);
            mcrsprd = xM + phr;
            st.site = &pd_emlrtRSI;
            b_st.site = &ab_emlrtRSI;
            mcrsprd = 4.0 * mcrsprd / (crsprod_idx_2 + 4.0) +
                      (1.0 - mcrsprd) * (1.0 - mcrsprd);
            st.site = &qd_emlrtRSI;
            if (mcrsprd < 0.0) {
              emlrtErrorWithMessageIdR2018a(
                  &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                  "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
            }
            phr = phr * (1.0 - ((m + 1.0) + (dth - 0.5)) / (0.15 * m + 1.0) *
                                   phr *
                                   (mcrsprd / 2.0 +
                                    0.03 * phr * muDoubleScalarSqrt(mcrsprd))) +
                  xM;
            /*  first estimate might not be able to yield possible solution */
            if (phr > 1.0) {
              *exitflag = -1.0;
            } else {
              /*  second estimate (only if m > 0) */
              guard1 = true;
            }
          } else {
            if (Td > 0.0) {
              st.site = &rd_emlrtRSI;
              b_st.site = &ab_emlrtRSI;
              crsprod_idx_1 =
                  mcrsprd / (b_gamma / 2.0 -
                             crsprod_idx_2 * (b_gamma / 2.0 / (T0 - mcrsprd) -
                                              1.0 / (xM * xM)));
              st.site = &rd_emlrtRSI;
              if (crsprod_idx_1 < 0.0) {
                emlrtErrorWithMessageIdR2018a(
                    &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                    "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
              }
              crsprod_idx_1 = muDoubleScalarSqrt(crsprod_idx_1);
              phr = xM - crsprod_idx_1;
            } else {
              crsprod_idx_2 = Td / (4.0 - Td);
              crsprod_idx_1 = 2.0 * (1.0 - phr);
              st.site = &sd_emlrtRSI;
              if (crsprod_idx_1 < 0.0) {
                emlrtErrorWithMessageIdR2018a(
                    &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                    "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
              }
              crsprod_idx_1 = muDoubleScalarSqrt(crsprod_idx_1);
              mcrsprd = crsprod_idx_2 + 1.7 * crsprod_idx_1;
              if (!(mcrsprd >= 0.0)) {
                st.site = &td_emlrtRSI;
                b_st.site = &ab_emlrtRSI;
                crsprod_idx_1 = muDoubleScalarPower(-mcrsprd, 0.125);
                st.site = &td_emlrtRSI;
                if (crsprod_idx_1 < 0.0) {
                  emlrtErrorWithMessageIdR2018a(
                      &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                      "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
                }
                crsprod_idx_1 = muDoubleScalarSqrt(crsprod_idx_1);
                mcrsprd = -Td / (1.5 * T0 - Td);
                st.site = &td_emlrtRSI;
                if (mcrsprd < 0.0) {
                  emlrtErrorWithMessageIdR2018a(
                      &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                      "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
                }
                mcrsprd = muDoubleScalarSqrt(mcrsprd);
                crsprod_idx_2 -= crsprod_idx_1 * (crsprod_idx_2 + mcrsprd);
              }
              mcrsprd = 4.0 / (4.0 - Td);
              st.site = &ud_emlrtRSI;
              if (mcrsprd < 0.0) {
                emlrtErrorWithMessageIdR2018a(
                    &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                    "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
              }
              phr = crsprod_idx_2 *
                    (((m + 1.0) + 0.24 * (dth - 0.5)) / (0.15 * m + 1.0) *
                         crsprod_idx_2 *
                         (mcrsprd / 2.0 -
                          0.03 * crsprod_idx_2 * muDoubleScalarSqrt(mcrsprd)) +
                     1.0);
            }
            /*  estimate might not give solutions */
            if (phr < -1.0) {
              *exitflag = -1.0;
            } else {
              guard1 = true;
            }
          }
        }
      }
    }
  }
  if (guard1) {
    /*  find root of Lancaster & Blancard's function */
    /*  -------------------------------------------- */
    /*  (Halley's method) */
    mcrsprd = rtInf;
    iterations = 0;
    int32_T exitg1;
    do {
      exitg1 = 0;
      if (muDoubleScalarAbs(mcrsprd) > 1.0E-12) {
        /*  iterations */
        iterations++;
        /*  compute function value, and first two derivatives */
        st.site = &vd_emlrtRSI;
        b_LancasterBlanchard(&st, phr, q, m, &mcrsprd, &Tp, &b_gamma);
        /*  find the root of the *difference* between the */
        /*  function value [T_x] and the required time [T] */
        mcrsprd -= T;
        /*  new value of x */
        crsprod_idx_2 = phr;
        st.site = &wd_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        phr -= 2.0 * mcrsprd * Tp / (2.0 * (Tp * Tp) - mcrsprd * b_gamma);
        /*  escape clause */
        st.site = &xd_emlrtRSI;
        if (muDoubleScalarRem(iterations, 7.0) != 0.0) {
          phr = (crsprod_idx_2 + phr) / 2.0;
        }
        /*  Halley's method might fail */
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b((emlrtConstCTX)sp);
        }
        if (iterations > 25) {
          *exitflag = -2.0;
          exitg1 = 1;
        }
      } else {
        /*  calculate terminal velocities */
        /*  ----------------------------- */
        /*  constants required for this calculation */
        b_gamma = muC * s / 2.0;
        st.site = &yd_emlrtRSI;
        if (b_gamma < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        b_gamma = muDoubleScalarSqrt(b_gamma);
        if (c == 0.0) {
          Tp = 1.0;
          mcrsprd = 0.0;
          crsprod_idx_0 = muDoubleScalarAbs(phr);
        } else {
          st.site = &ae_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          d /= c * c;
          st.site = &ae_emlrtRSI;
          if (d < 0.0) {
            emlrtErrorWithMessageIdR2018a(
                &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
          }
          d = muDoubleScalarSqrt(d);
          Tp = 2.0 * d * muDoubleScalarSin(dth / 2.0);
          mcrsprd = (r1 - r2) / c;
          st.site = &be_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          st.site = &be_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          crsprod_idx_0 = phr_tmp * (phr * phr - 1.0) + 1.0;
          st.site = &be_emlrtRSI;
          if (crsprod_idx_0 < 0.0) {
            emlrtErrorWithMessageIdR2018a(
                &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
          }
          crsprod_idx_0 = muDoubleScalarSqrt(crsprod_idx_0);
        }
        /*  radial component */
        xM = q * crsprod_idx_0;
        crsprod_idx_2 = xM - phr;
        xM = mcrsprd * (xM + phr);
        a = b_gamma * (crsprod_idx_2 - xM) / r1;
        crsprod_idx_1 = -b_gamma * (crsprod_idx_2 + xM) / r2;
        /*  tangential component */
        xM = Tp * b_gamma * (crsprod_idx_0 + q * phr);
        crsprod_idx_2 = xM / r1;
        mcrsprd = xM / r2;
        /*  Cartesian velocity */
        V1[0] = crsprod_idx_2 * th1unit_idx_0 + a * r1unit_idx_0;
        V2[0] = mcrsprd * th2unit_idx_0 + crsprod_idx_1 * r2unit_idx_0;
        V1[1] = crsprod_idx_2 * th1unit_idx_1 + a * r1unit_idx_1;
        V2[1] = mcrsprd * th2unit_idx_1 + crsprod_idx_1 * r2unit_idx_1;
        V1[2] = crsprod_idx_2 * th1unit_idx_2 + a * r1unit_idx_2;
        V2[2] = mcrsprd * th2unit_idx_2 + crsprod_idx_1 * r2unit_idx_2;
        /*  exitflag */
        *exitflag = 1.0;
        /*  (success) */
        /*  also determine minimum/maximum distance */
        /*      a = s/2/(1 - x^2); % semi-major axis */
        /*      extremal_distances = minmax_distances(r1vec, r1, r1vec, r2, dth,
         * a, V1, V2, m, muC); */
        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }
}

static void lambert_ZeroRevs_MEXIFY(const emlrtStack *sp, const real_T RI[3],
                                    const real_T RF[3], real_T TOF, real_T MU,
                                    real_T VI[3], real_T VF[3])
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T CR[3];
  real_T CTH;
  real_T RFM;
  real_T RFM2;
  real_T RIM;
  real_T RIM2;
  real_T STH;
  real_T THETA;
  int32_T CHECKFEAS;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  /*  Maximum number of iterations for loops */
  /*  Reset */
  /*  ---------------------------------- */
  /*  Compute the vector magnitudes and various cross and dot products */
  RIM2 = dot(RI, RI);
  st.site = &c_emlrtRSI;
  if (RIM2 < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  RIM = muDoubleScalarSqrt(RIM2);
  RFM2 = dot(RF, RF);
  st.site = &d_emlrtRSI;
  if (RFM2 < 0.0) {
    emlrtErrorWithMessageIdR2018a(
        &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
        "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
  }
  RFM = muDoubleScalarSqrt(RFM2);
  STH = RIM * RFM;
  CTH = dot(RI, RF) / STH;
  CR[0] = RI[1] * RF[2] - RF[1] * RI[2];
  CR[1] = RF[0] * RI[2] - RI[0] * RF[2];
  CR[2] = RI[0] * RF[1] - RF[0] * RI[1];
  STH = b_norm(CR) / STH;
  if (CR[2] < 0.0) {
    /*  always direct transfer */
    STH = -STH;
  }
  THETA = muDoubleScalarAtan2(STH, CTH);
  if (muDoubleScalarSign(THETA) < 0.0) {
    CHECKFEAS = -1;
  } else {
    CHECKFEAS = 0;
  }
  THETA -= 6.2831853071795862 *
           (trunc(THETA / 6.2831853071795862) + (real_T)CHECKFEAS);
  if ((THETA == 6.2831853071795862) || (THETA == 0.0)) {
    VI[0] = 0.0;
    VF[0] = 0.0;
    VI[1] = 0.0;
    VF[1] = 0.0;
    VI[2] = 0.0;
    VF[2] = 0.0;
  } else {
    real_T B1;
    real_T LAMBDA;
    real_T S;
    real_T d;
    B1 = muDoubleScalarSign(STH);
    if (STH == 0.0) {
      B1 = 1.0;
    }
    /*  ---------------------------------- */
    /*  Compute the chord and the semi-perimeter */
    STH = (RIM2 + RFM2) - 2.0 * RIM * RFM * CTH;
    st.site = &e_emlrtRSI;
    if (STH < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    STH = muDoubleScalarSqrt(STH);
    S = ((RIM + RFM) + STH) / 2.0;
    RFM2 = S - STH;
    STH = RFM2 / S;
    st.site = &f_emlrtRSI;
    if (STH < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    LAMBDA = B1 * muDoubleScalarSqrt(STH);
    d = 4.0 * TOF * LAMBDA;
    if ((d == 0.0) || (muDoubleScalarAbs(STH) < 1.0E-14)) {
      VI[0] = 0.0;
      VF[0] = 0.0;
      VI[1] = 0.0;
      VF[1] = 0.0;
      VI[2] = 0.0;
      VF[2] = 0.0;
    } else {
      real_T L;
      real_T L1_tmp;
      real_T M;
      real_T X;
      real_T X0;
      int32_T N;
      int32_T N1;
      /*  ---------------------------------- */
      /*  Compute L carefully for transfer angles less than 5 degrees */
      if (THETA * 180.0 / 3.1415926535897931 <= 5.0) {
        st.site = &g_emlrtRSI;
        STH = RFM / RIM;
        b_st.site = &ab_emlrtRSI;
        c_st.site = &bb_emlrtRSI;
        if (STH < 0.0) {
          emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
                                        "Coder:toolbox:power_domainError",
                                        "Coder:toolbox:power_domainError", 0);
        }
        st.site = &h_emlrtRSI;
        RIM2 = muDoubleScalarSin(THETA / 4.0);
        b_st.site = &ab_emlrtRSI;
        st.site = &i_emlrtRSI;
        STH = muDoubleScalarTan(
            2.0 * (muDoubleScalarAtan(muDoubleScalarPower(STH, 0.25)) -
                   0.78539816339744828));
        b_st.site = &ab_emlrtRSI;
        STH = RIM2 * RIM2 + STH * STH;
        L = STH / (STH + muDoubleScalarCos(THETA / 2.0));
      } else {
        st.site = &j_emlrtRSI;
        STH = (1.0 - LAMBDA) / (LAMBDA + 1.0);
        b_st.site = &ab_emlrtRSI;
        L = STH * STH;
      }
      st.site = &k_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      st.site = &k_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      st.site = &k_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      M = 8.0 * MU * (TOF * TOF) /
          (muDoubleScalarPower(S, 3.0) *
           muDoubleScalarPower(LAMBDA + 1.0, 6.0));
      st.site = &l_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      c_st.site = &bb_emlrtRSI;
      if (S < 0.0) {
        emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
                                      "Coder:toolbox:power_domainError",
                                      "Coder:toolbox:power_domainError", 0);
      }
      st.site = &l_emlrtRSI;
      b_st.site = &ab_emlrtRSI;
      c_st.site = &bb_emlrtRSI;
      if (RFM2 < 0.0) {
        emlrtErrorWithMessageIdR2018a(&c_st, &b_emlrtRTEI,
                                      "Coder:toolbox:power_domainError",
                                      "Coder:toolbox:power_domainError", 0);
      }
      STH = 2.0 / MU;
      st.site = &l_emlrtRSI;
      if (STH < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      STH = muDoubleScalarSqrt(STH);
      L1_tmp = (1.0 - L) / 2.0;
      CHECKFEAS = 0;
      /*  ---------------------------------- */
      /*  Initialize values of y, n, and x */
      THETA = 1.0;
      N = 0;
      N1 = 0;
      if (TOF - STH / 3.0 *
                    (muDoubleScalarPower(S, 1.5) -
                     B1 * muDoubleScalarPower(RFM2, 1.5)) <=
          0.001) {
        X0 = 0.0;
      } else {
        X0 = L;
      }
      X = -1.0E+8;
      /*  ---------------------------------- */
      /*  Begin iteration */
      while ((muDoubleScalarAbs(X0 - X) >=
              muDoubleScalarAbs(X) * 1.0E-14 + 1.0E-14) &&
             (N <= 2000)) {
        int32_T GAMMA_tmp;
        N++;
        X = X0;
        st.site = &m_emlrtRSI;
        b_st.site = &m_emlrtRSI;
        if (X0 + 1.0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        STH = muDoubleScalarSqrt(X0 + 1.0);
        b_st.site = &ab_emlrtRSI;
        STH = X0 / ((STH + 1.0) * (STH + 1.0));
        CHECKFEAS = 1;
        /*  ---------------------------------- */
        /*  Compute x by means of an algorithm devised by */
        /*  Gauticci for evaluating continued fractions by the */
        /*  'Top Down' method */
        RFM2 = 1.0;
        B1 = 1.0;
        CTH = 1.0;
        N1 = 3;
        while ((muDoubleScalarAbs(B1) > 1.0E-14) && (N1 - 3 <= 2000)) {
          N1++;
          st.site = &n_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          st.site = &n_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          GAMMA_tmp = N1 * N1;
          RFM2 = 1.0 / ((real_T)GAMMA_tmp / (4.0 * (real_T)GAMMA_tmp - 1.0) *
                            STH * RFM2 +
                        1.0);
          B1 *= RFM2 - 1.0;
          CTH += B1;
          if (*emlrtBreakCheckR2012bFlagVar != 0) {
            emlrtBreakCheckR2012b((emlrtConstCTX)sp);
          }
        }
        st.site = &o_emlrtRSI;
        if (X0 + 1.0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        RIM2 = 8.0 * (muDoubleScalarSqrt(X0 + 1.0) + 1.0) /
               (1.0 / ((STH + 5.0) + 9.0 * STH / 7.0 * CTH) + 3.0);
        /*  ---------------------------------- */
        /*  Compute H1 and H2 */
        if (N == 1) {
          st.site = &p_emlrtRSI;
          RFM2 = L + X0;
          b_st.site = &ab_emlrtRSI;
          STH = ((2.0 * X0 + 1.0) + L) * ((3.0 * RIM2 + X0 * RIM2) + 4.0 * X0);
          THETA = RFM2 * RFM2 * ((RIM2 + 1.0) + 3.0 * X0) / STH;
          STH = M * ((RIM2 + X0) - L) / STH;
        } else {
          st.site = &q_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          st.site = &q_emlrtRSI;
          b_st.site = &ab_emlrtRSI;
          STH = L1_tmp * L1_tmp + M / (THETA * THETA);
          st.site = &q_emlrtRSI;
          if (STH < 0.0) {
            emlrtErrorWithMessageIdR2018a(
                &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
                "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
          }
          STH = muDoubleScalarSqrt(STH);
          st.site = &r_emlrtRSI;
          RFM2 = STH - L1_tmp;
          b_st.site = &ab_emlrtRSI;
          STH = 2.0 * STH * ((3.0 * RIM2 + X0 * RIM2) + 4.0 * X0);
          THETA = RFM2 * RFM2 * ((RIM2 + 1.0) + 3.0 * X0) / STH;
          STH = M * ((RIM2 + X0) - L) / STH;
        }
        st.site = &s_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        RIM2 = 27.0 * STH / (4.0 * muDoubleScalarPower(THETA + 1.0, 3.0));
        st.site = &t_emlrtRSI;
        if (RIM2 + 1.0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        B1 = -RIM2 / (2.0 * (muDoubleScalarSqrt(RIM2 + 1.0) + 1.0));
        /*  ---------------------------------- */
        /*  Compute the continued fraction expansion K(u) */
        /*  by means of the 'Top Down' method */
        RFM2 = 1.0;
        STH = 1.0;
        CTH = 1.0;
        N1 = 0;
        while ((N1 < 2000) && (muDoubleScalarAbs(STH) >= 1.0E-14)) {
          if (N1 == 0) {
            RFM2 = 1.0 / (1.0 - 0.14814814814814814 * B1 * RFM2);
            STH *= RFM2 - 1.0;
            CTH += STH;
          } else {
            GAMMA_tmp = N1 << 2;
            RFM2 = 1.0 /
                   (1.0 - (real_T)(((3 * N1 + 1) << 1) * (6 * N1 - 1)) /
                              (real_T)(9 * (GAMMA_tmp - 1) * (GAMMA_tmp + 1)) *
                              B1 * RFM2);
            STH *= RFM2 - 1.0;
            CTH += STH;
            if (*emlrtBreakCheckR2012bFlagVar != 0) {
              emlrtBreakCheckR2012b((emlrtConstCTX)sp);
            }
            RFM2 = 1.0 /
                   (1.0 - (real_T)(((3 * N1 + 2) << 1) * (6 * N1 + 1)) /
                              (real_T)(9 * (GAMMA_tmp + 1) * (GAMMA_tmp + 3)) *
                              B1 * RFM2);
            STH *= RFM2 - 1.0;
            CTH += STH;
            if (*emlrtBreakCheckR2012bFlagVar != 0) {
              emlrtBreakCheckR2012b((emlrtConstCTX)sp);
            }
          }
          N1++;
          if (*emlrtBreakCheckR2012bFlagVar != 0) {
            emlrtBreakCheckR2012b((emlrtConstCTX)sp);
          }
        }
        st.site = &u_emlrtRSI;
        RFM2 = CTH / 3.0;
        b_st.site = &ab_emlrtRSI;
        st.site = &v_emlrtRSI;
        if (RIM2 + 1.0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        THETA =
            (THETA + 1.0) / 3.0 *
            (muDoubleScalarSqrt(RIM2 + 1.0) / (1.0 - 2.0 * B1 * (RFM2 * RFM2)) +
             2.0);
        /*  Y = Ycami */
        st.site = &w_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        st.site = &w_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        STH = L1_tmp * L1_tmp + M / (THETA * THETA);
        st.site = &w_emlrtRSI;
        if (STH < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        STH = muDoubleScalarSqrt(STH);
        X0 = STH - (L + 1.0) / 2.0;
        if (*emlrtBreakCheckR2012bFlagVar != 0) {
          emlrtBreakCheckR2012b((emlrtConstCTX)sp);
        }
      }
      /*  ---------------------------------- */
      /*  Compute the velocity vectors */
      if (CHECKFEAS == 0) {
        VI[0] = 0.0;
        VF[0] = 0.0;
        VI[1] = 0.0;
        VF[1] = 0.0;
        VI[2] = 0.0;
        VF[2] = 0.0;
      } else if ((N1 >= 2000) || (N >= 2000)) {
        VI[0] = 0.0;
        VF[0] = 0.0;
        VI[1] = 0.0;
        VF[1] = 0.0;
        VI[2] = 0.0;
        VF[2] = 0.0;
      } else {
        st.site = &x_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        STH = (LAMBDA + 1.0) * (LAMBDA + 1.0);
        B1 = STH / d;
        THETA *= X0 + 1.0;
        st.site = &y_emlrtRSI;
        b_st.site = &ab_emlrtRSI;
        RIM2 = M * S * STH / THETA;
        RFM2 = THETA * (RI[0] - RF[0]);
        VI[0] = -B1 * (RFM2 - RIM2 * RI[0] / RIM);
        CTH = THETA * (RI[1] - RF[1]);
        VI[1] = -B1 * (CTH - RIM2 * RI[1] / RIM);
        STH = THETA * (RI[2] - RF[2]);
        VI[2] = -B1 * (STH - RIM2 * RI[2] / RIM);
        VF[0] = -B1 * (RFM2 + RIM2 * RF[0] / RFM);
        VF[1] = -B1 * (CTH + RIM2 * RF[1] / RFM);
        VF[2] = -B1 * (STH + RIM2 * RF[2] / RFM);
      }
    }
  }
}

void lambertMR_MEXIFY(const emlrtStack *sp, const real_T RI[3],
                      const real_T RF[3], real_T TOF, real_T MU, real_T Nrev,
                      real_T Ncase, real_T VI[3], real_T VF[3])
{
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack st;
  real_T aa_idx_0;
  real_T d1;
  real_T inn2;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  /*  DESCRIPTION */
  /*  Lambert problem solution for Keplerian dynamics and for prograde orbits */
  /*  only. */
  /*  */
  /*  INPUT */
  /*  - RI    : 1x3 vector with initial position [km] */
  /*  - RF    : 1x3 vector with final position [km] */
  /*  - TOF   : time of flight [sec] */
  /*  - MU    : gravitational parameter of the central body [km3/s2] */
  /*  - Nrev  : integer number of revolutions */
  /*  - Ncase : if 0, then low-energy is selected, if 1, then high energy */
  /*   */
  /*  OUTPUT */
  /*  - VI : 1x3 vector with initial velocity [km/s] */
  /*  - VF : 1x3 vector with final velocity [km/s] */
  /*  */
  /*  -------------------------------------------------------------------------
   */
  if (Nrev == 0.0) {
    /*  --> ZERO REVOLUTIONS */
    st.site = &emlrtRSI;
    lambert_ZeroRevs_MEXIFY(&st, RI, RF, TOF, MU, VI, VF);
  } else {
    real_T crossprd[3];
    real_T aalfa[2];
    real_T bbeta[2];
    real_T dv[2];
    real_T Lambda;
    real_T T;
    real_T V;
    real_T a;
    real_T a_min;
    real_T c;
    real_T d;
    real_T dth;
    real_T inn1;
    real_T leftbranch;
    real_T logt;
    real_T longway;
    real_T longway_tmp;
    real_T m;
    real_T mcr;
    real_T mr2vec;
    real_T r1;
    real_T s;
    real_T tf;
    real_T x1;
    real_T x2;
    real_T x_tmp;
    real_T x_tmp_tmp;
    real_T xnew;
    real_T xx_idx_0;
    real_T y2;
    int32_T iterations;
    boolean_T bad;
    boolean_T exitg1;
    /*  --> MULTIREVOLUTIONS */
    if (Ncase == 0.0) {
      m = -Nrev;
    } else {
      m = Nrev;
    }
    /*  --> check if MR are available (...) */
    st.site = &b_emlrtRSI;
    /*  ----------------------------------------------------------------- */
    /*  Izzo's version: */
    /*  Very fast, but not very robust for more complicated cases */
    /*  ----------------------------------------------------------------- */
    /*  original documentation: */
    /* { */
    /*  This routine implements a new algorithm that solves Lambert's problem.
     * The */
    /*  algorithm has two major characteristics that makes it favorable to other
     */
    /*  existing ones. */
    /*  1) It describes the generic orbit solution of the boundary condition */
    /*  problem through the variable X=log(1+cos(alpha/2)). By doing so the */
    /*  graph of the time of flight become defined in the entire real axis and
     */
    /*  resembles a straight line. Convergence is granted within few iterations
     */
    /*  for all the possible geometries (except, of course, when the transfer */
    /*  angle is zero). When multiple revolutions are considered the variable is
     */
    /*  X=tan(cos(alpha/2)*pi/2). */
    /*  2) Once the orbit has been determined in the plane, this routine */
    /*  evaluates the velocity vectors at the two points in a way that is not */
    /*  singular for the transfer angle approaching to pi (Lagrange coefficient
     */
    /*  based methods are numerically not well suited for this purpose). */
    /*  As a result Lambert's problem is solved (with multiple revolutions */
    /*  being accounted for) with the same computational effort for all */
    /*  possible geometries. The case of near 180 transfers is also solved */
    /*  efficiently. */
    /*   We note here that even when the transfer angle is exactly equal to pi
     */
    /*  the algorithm does solve the problem in the plane (it finds X), but it
     */
    /*  is not able to evaluate the plane in which the orbit lies. A solution */
    /*  to this would be to provide the direction of the plane containing the */
    /*  transfer orbit from outside. This has not been implemented in this */
    /*  routine since such a direction would depend on which application the */
    /*  transfer is going to be used in. */
    /*  please report bugs to dario.izzo@esa.int */
    /* } */
    /*  adjusted documentation: */
    /* { */
    /*  For problems with |m| > 0, there are generally two solutions. By */
    /*  default, the right branch solution will be returned. The left branch */
    /*  may be requested by giving a negative value to the corresponding */
    /*  number of complete revolutions [m]. */
    /* } */
    /*  Authors */
    /*  .-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-. */
    /*  Name       : Dr. Dario Izzo */
    /*  E-mail     : dario.izzo@esa.int */
    /*  Affiliation: ESA / Advanced Concepts Team (ACT) */
    /*  Made more readible and optimized for speed by Rody P.S. Oldenhuis */
    /*  Code available in MGA.M on
     * http://www.esa.int/gsp/ACT/inf/op/globopt.htm */
    /*  last edited 12/Dec/2009 */
    /*  ADJUSTED FOR EML-COMPILATION 24/Dec/2009 */
    /*  initial values */
    bad = false;
    /*  work with non-dimensional units */
    r1 = b_norm(RI);
    VI[0] = RI[0] / r1;
    VI[1] = RI[1] / r1;
    VI[2] = RI[2] / r1;
    V = MU / r1;
    b_st.site = &cb_emlrtRSI;
    if (V < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    V = muDoubleScalarSqrt(V);
    T = r1 / V;
    /*  also transform to seconds */
    /*  relevant geometry parameters (non dimensional) */
    d = RF[0] / r1;
    VF[0] = d;
    inn2 = d * d;
    d = RF[1] / r1;
    VF[1] = d;
    inn2 += d * d;
    d = RF[2] / r1;
    inn2 += d * d;
    b_st.site = &db_emlrtRSI;
    if (inn2 < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    mr2vec = muDoubleScalarSqrt(inn2);
    /*  make 100% sure it's in (-1 <= dth <= +1) */
    b_st.site = &eb_emlrtRSI;
    dth = muDoubleScalarAcos(muDoubleScalarMax(
        -1.0,
        muDoubleScalarMin(1.0, ((VI[0] * VF[0] + VI[1] * VF[1]) + VI[2] * d) /
                                   mr2vec)));
    /*  decide whether to use the left or right branch (for multi-revolution */
    /*  problems), and the long- or short way */
    leftbranch = muDoubleScalarSign(m);
    longway_tmp = VI[0] * VF[1] - VF[0] * VI[1];
    longway = muDoubleScalarSign(longway_tmp);
    m = muDoubleScalarAbs(m);
    tf = muDoubleScalarAbs(TOF / T);
    if (longway < 0.0) {
      dth = 6.2831853071795862 - dth;
    }
    /*  derived quantities */
    b_st.site = &fb_emlrtRSI;
    c = (mr2vec * mr2vec + 1.0) - 2.0 * mr2vec * muDoubleScalarCos(dth);
    b_st.site = &fb_emlrtRSI;
    if (c < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    c = muDoubleScalarSqrt(c);
    /*  non-dimensional chord */
    s = ((mr2vec + 1.0) + c) / 2.0;
    /*  non-dimensional semi-perimeter */
    a_min = s / 2.0;
    /*  minimum energy ellipse semi major axis */
    b_st.site = &gb_emlrtRSI;
    if (mr2vec < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    Lambda = muDoubleScalarSqrt(mr2vec) * muDoubleScalarCos(dth / 2.0) / s;
    /*  lambda parameter (from BATTIN's book) */
    crossprd[0] = VI[1] * d - VF[1] * VI[2];
    crossprd[1] = VF[0] * VI[2] - VI[0] * d;
    mcr = (crossprd[0] * crossprd[0] + crossprd[1] * crossprd[1]) +
          longway_tmp * longway_tmp;
    b_st.site = &hb_emlrtRSI;
    if (mcr < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
    }
    mcr = muDoubleScalarSqrt(mcr);
    /*  magnitues thereof */
    /*  unit vector thereof */
    /*  Initial values */
    /*  --------------------------------------------------------- */
    /*  ELMEX requires this variable to be declared OUTSIDE the IF-statement */
    b_st.site = &ib_emlrtRSI;
    if (tf < 0.0) {
      emlrtErrorWithMessageIdR2018a(
          &b_st, &e_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
          "Coder:toolbox:ElFunDomainError", 3, 4, 3, "log");
    }
    logt = muDoubleScalarLog(tf);
    /*  avoid re-computing the same value */
    /*  single revolution (1 solution) */
    if (m == 0.0) {
      /*  initial values */
      inn1 = -0.5233;
      /*  first initial guess */
      inn2 = 0.5233;
      /*  second initial guess */
      b_st.site = &jb_emlrtRSI;
      x1 = -0.740867916771357;
      /*  transformed first initial guess */
      b_st.site = &kb_emlrtRSI;
      x2 = 0.42087903416051825;
      /*  transformed first second guess */
      /*  multiple revolutions (0, 1 or 2 solutions) */
      /*  the returned soltuion depends on the sign of [m] */
    } else {
      /*  select initial values */
      if (leftbranch < 0.0) {
        inn1 = -0.5234;
        /*  first initial guess, left branch */
        inn2 = -0.2234;
        /*  second initial guess, left branch */
      } else {
        inn1 = 0.7234;
        /*  first initial guess, right branch */
        inn2 = 0.5234;
        /*  second initial guess, right branch */
      }
      x1 = muDoubleScalarTan(inn1 * 6.2831853071795862 / 4.0);
      /*  transformed first initial guess */
      x2 = muDoubleScalarTan(inn2 * 6.2831853071795862 / 4.0);
      /*  transformed first second guess */
    }
    /*  since (inn1, inn2) < 0, initial estimate is always ellipse */
    x_tmp_tmp = s - c;
    x_tmp = x_tmp_tmp / 2.0;
    a = longway * 2.0;
    d1 = a_min / (1.0 - inn1 * inn1);
    aa_idx_0 = d1;
    bbeta[0] = x_tmp / d1;
    d1 = a_min / (1.0 - inn2 * inn2);
    bbeta[1] = x_tmp / d1;
    b_st.site = &lb_emlrtRSI;
    b_sqrt(&b_st, bbeta);
    b_st.site = &lb_emlrtRSI;
    b_asin(&b_st, bbeta);
    /*  make 100.4% sure it's in (-1 <= xx <= +1) */
    bbeta[0] *= a;
    aalfa[0] = inn1;
    bbeta[1] *= a;
    aalfa[1] = inn2;
    b_st.site = &mb_emlrtRSI;
    b_acos(&b_st, aalfa);
    /*  evaluate the time of flight via Lagrange expression */
    inn2 = 2.0 * aalfa[0];
    aalfa[0] = inn2;
    xx_idx_0 = muDoubleScalarSin(inn2);
    dv[0] = aa_idx_0;
    inn2 = 2.0 * aalfa[1];
    dv[1] = d1;
    b_st.site = &nb_emlrtRSI;
    b_sqrt(&b_st, dv);
    inn1 = 6.2831853071795862 * m;
    aa_idx_0 =
        aa_idx_0 * dv[0] *
        (((aalfa[0] - xx_idx_0) - (bbeta[0] - muDoubleScalarSin(bbeta[0]))) +
         inn1);
    inn2 = d1 * dv[1] *
           (((inn2 - muDoubleScalarSin(inn2)) -
             (bbeta[1] - muDoubleScalarSin(bbeta[1]))) +
            inn1);
    /*  initial estimates for y */
    if (m == 0.0) {
      b_st.site = &ob_emlrtRSI;
      if (aa_idx_0 < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &b_st, &e_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 3, "log");
      }
      aa_idx_0 = muDoubleScalarLog(aa_idx_0) - logt;
      b_st.site = &pb_emlrtRSI;
      if (inn2 < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &b_st, &e_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 3, "log");
      }
      y2 = muDoubleScalarLog(inn2) - logt;
    } else {
      aa_idx_0 -= tf;
      y2 = inn2 - tf;
    }
    /*  Solve for x */
    /*  --------------------------------------------------------- */
    /*  Newton-Raphson iterations */
    /*  NOTE - the number of iterations will go to infinity in case */
    /*  m > 0  and there is no solution. Start the other routine in */
    /*  that case */
    xx_idx_0 = rtInf;
    iterations = 0;
    xnew = 0.0;
    exitg1 = false;
    while ((!exitg1) && (xx_idx_0 > 1.0E-14)) {
      /*  increment number of iterations */
      iterations++;
      /*  new x */
      xnew = (x1 * y2 - aa_idx_0 * x2) / (y2 - aa_idx_0);
      /*  copy-pasted code (for performance) */
      if (m == 0.0) {
        aa_idx_0 = muDoubleScalarExp(xnew) - 1.0;
      } else {
        aa_idx_0 = muDoubleScalarAtan(xnew) * 2.0 / 3.1415926535897931;
      }
      b_st.site = &qb_emlrtRSI;
      a = a_min / (1.0 - aa_idx_0 * aa_idx_0);
      if (aa_idx_0 < 1.0) {
        /*  ellipse */
        b_st.site = &rb_emlrtRSI;
        inn1 = x_tmp / a;
        c_st.site = &rb_emlrtRSI;
        if (inn1 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &c_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn1 = muDoubleScalarSqrt(inn1);
        if (inn1 > 1.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
        }
        inn1 = muDoubleScalarAsin(inn1);
        inn2 = longway * 2.0 * inn1;
        /*  make 100.4% sure it's in (-1 <= xx <= +1) */
        b_st.site = &sb_emlrtRSI;
        inn1 = 2.0 * muDoubleScalarAcos(muDoubleScalarMax(-1.0, aa_idx_0));
      } else {
        /*  hyperbola */
        b_st.site = &tb_emlrtRSI;
        b_acosh(&b_st, &aa_idx_0);
        inn1 = 2.0 * aa_idx_0;
        d1 = x_tmp_tmp / (-2.0 * a);
        b_st.site = &ub_emlrtRSI;
        if (d1 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        d1 = muDoubleScalarSqrt(d1);
        b_asinh(&d1);
        inn2 = longway * 2.0 * d1;
      }
      /*  evaluate the time of flight via Lagrange expression */
      if (a > 0.0) {
        b_st.site = &vb_emlrtRSI;
        if (a < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn1 = a * muDoubleScalarSqrt(a) *
               (((inn1 - muDoubleScalarSin(inn1)) -
                 (inn2 - muDoubleScalarSin(inn2))) +
                6.2831853071795862 * m);
      } else {
        b_st.site = &wb_emlrtRSI;
        if (-a < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn1 = -a * muDoubleScalarSqrt(-a) *
               ((muDoubleScalarSinh(inn1) - inn1) -
                (muDoubleScalarSinh(inn2) - inn2));
      }
      /*  new value of y */
      if (m == 0.0) {
        b_st.site = &xb_emlrtRSI;
        if (inn1 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &e_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 3, "log");
        }
        inn1 = muDoubleScalarLog(inn1) - logt;
      } else {
        inn1 -= tf;
      }
      /*  save previous and current values for the next iterarion */
      /*  (prevents getting stuck between two values) */
      x1 = x2;
      x2 = xnew;
      aa_idx_0 = y2;
      y2 = inn1;
      /*  update error */
      xx_idx_0 = muDoubleScalarAbs(x1 - xnew);
      /*  escape clause */
      if (*emlrtBreakCheckR2012bFlagVar != 0) {
        emlrtBreakCheckR2012b(&st);
      }
      if (iterations > 15) {
        bad = true;
        exitg1 = true;
      }
    }
    /*  If the Newton-Raphson scheme failed, try to solve the problem */
    /*  with the other Lambert targeter. */
    if (bad) {
      real_T Vt1[3];
      /*  NOTE: use the original, UN-normalized quantities */
      Vt1[0] = VI[0] * r1;
      crossprd[0] = VF[0] * r1;
      Vt1[1] = VI[1] * r1;
      crossprd[1] = VF[1] * r1;
      Vt1[2] = VI[2] * r1;
      crossprd[2] = d * r1;
      b_st.site = &yb_emlrtRSI;
      lambert_LancasterBlanchard(&b_st, Vt1, crossprd, longway * tf * T,
                                 leftbranch * m, MU, VI, VF, &inn2);
    } else {
      real_T Vt1[3];
      /*  convert converged value of x */
      if (m == 0.0) {
        aa_idx_0 = muDoubleScalarExp(xnew) - 1.0;
      } else {
        aa_idx_0 = muDoubleScalarAtan(xnew) * 2.0 / 3.1415926535897931;
      }
      /*     %{ */
      /*       The solution has been evaluated in terms of log(x+1) or
       * tan(x*pi/2), we */
      /*       now need the conic. As for transfer angles near to pi the
       * Lagrange- */
      /*       coefficients technique goes singular (dg approaches a zero/zero
       * that is */
      /*       numerically bad) we here use a different technique for those
       * cases. When */
      /*       the transfer angle is exactly equal to pi, then the ih unit
       * vector is not */
      /*       determined. The remaining equations, though, are still valid. */
      /*     %} */
      /*  Solution for the semi-major axis */
      b_st.site = &ac_emlrtRSI;
      a = a_min / (1.0 - aa_idx_0 * aa_idx_0);
      /*  Calculate psi */
      if (aa_idx_0 < 1.0) {
        /*  ellipse */
        b_st.site = &bc_emlrtRSI;
        inn1 = x_tmp / a;
        c_st.site = &bc_emlrtRSI;
        if (inn1 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &c_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn1 = muDoubleScalarSqrt(inn1);
        if (inn1 > 1.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "asin");
        }
        inn1 = muDoubleScalarAsin(inn1);
        /*  make 100.4% sure it's in (-1 <= xx <= +1) */
        b_st.site = &cc_emlrtRSI;
        b_st.site = &dc_emlrtRSI;
        xx_idx_0 = muDoubleScalarSin(
            (2.0 * muDoubleScalarAcos(muDoubleScalarMax(-1.0, aa_idx_0)) -
             longway * 2.0 * inn1) /
            2.0);
        xx_idx_0 = 2.0 * a * (xx_idx_0 * xx_idx_0) / s;
        b_st.site = &ec_emlrtRSI;
        if (xx_idx_0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn2 = muDoubleScalarSqrt(xx_idx_0);
      } else {
        /*  hyperbola */
        d1 = (c - s) / 2.0 / a;
        b_st.site = &fc_emlrtRSI;
        if (d1 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        d1 = muDoubleScalarSqrt(d1);
        b_asinh(&d1);
        inn2 = aa_idx_0;
        b_st.site = &gc_emlrtRSI;
        b_acosh(&b_st, &inn2);
        b_st.site = &hc_emlrtRSI;
        xx_idx_0 = muDoubleScalarSinh((2.0 * inn2 - longway * 2.0 * d1) / 2.0);
        xx_idx_0 = -2.0 * a * (xx_idx_0 * xx_idx_0) / s;
        b_st.site = &ic_emlrtRSI;
        if (xx_idx_0 < 0.0) {
          emlrtErrorWithMessageIdR2018a(
              &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
              "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
        }
        inn2 = muDoubleScalarSqrt(xx_idx_0);
      }
      /*  unit of the normalized normal vector */
      /*  unit vector for normalized [r2vec] */
      crossprd[0] = longway * (crossprd[0] / mcr);
      VF[0] /= mr2vec;
      crossprd[1] = longway * (crossprd[1] / mcr);
      VF[1] /= mr2vec;
      crossprd[2] = longway * (longway_tmp / mcr);
      VF[2] = d / mr2vec;
      /*  cross-products */
      /*  don't use cross() (emlmex() would try to compile it, and this way it
       */
      /*  also does not create any additional overhead) */
      /*  radial and tangential directions for departure velocity */
      b_st.site = &jc_emlrtRSI;
      if (a_min < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      inn1 = 1.0 / inn2 / muDoubleScalarSqrt(a_min) *
             ((2.0 * Lambda * a_min - Lambda) - aa_idx_0 * inn2);
      b_st.site = &kc_emlrtRSI;
      a = muDoubleScalarSin(dth / 2.0);
      xx_idx_0 = mr2vec / a_min / xx_idx_0 * (a * a);
      b_st.site = &kc_emlrtRSI;
      if (xx_idx_0 < 0.0) {
        emlrtErrorWithMessageIdR2018a(
            &b_st, &c_emlrtRTEI, "Coder:toolbox:ElFunDomainError",
            "Coder:toolbox:ElFunDomainError", 3, 4, 4, "sqrt");
      }
      xx_idx_0 = muDoubleScalarSqrt(xx_idx_0);
      /*  radial and tangential directions for arrival velocity */
      inn2 = xx_idx_0 / mr2vec;
      a = (xx_idx_0 - inn2) / muDoubleScalarTan(dth / 2.0) - inn1;
      /*  terminal velocities */
      Vt1[1] = xx_idx_0 * (VI[0] * crossprd[2] - crossprd[0] * VI[2]);
      Vt1[2] = xx_idx_0 * (crossprd[0] * VI[1] - VI[0] * crossprd[1]);
      VI[0] = (inn1 * VI[0] +
               xx_idx_0 * (crossprd[1] * VI[2] - VI[1] * crossprd[2])) *
              V;
      VI[1] = (inn1 * VI[1] + Vt1[1]) * V;
      VI[2] = (inn1 * VI[2] + Vt1[2]) * V;
      Vt1[1] = inn2 * (VF[0] * crossprd[2] - crossprd[0] * VF[2]);
      Vt1[2] = inn2 * (crossprd[0] * VF[1] - VF[0] * crossprd[1]);
      VF[0] =
          (a * VF[0] + inn2 * (crossprd[1] * VF[2] - VF[1] * crossprd[2])) * V;
      VF[1] = (a * VF[1] + Vt1[1]) * V;
      VF[2] = (a * VF[2] + Vt1[2]) * V;
      /*  exitflag */
      /*  (success) */
      /*  also compute minimum distance to central body */
      /*  NOTE: use un-transformed vectors again! */
      /*      extremal_distances = ... */
      /*          minmax_distances(r1vec*r1, r1, r2vec*r1, mr2vec*r1, dth, a*r1,
       * V1, V2, m, muC); */
    }
  }
}

void sigmax_init(void)
{
  static const real_T dv[25] = {0.4,
                                0.2142857142857143,
                                0.0462962962962963,
                                0.006628787878787879,
                                0.00072115384615384609,
                                6.36574074074074E-5,
                                4.7414799253034548E-6,
                                3.0594063283208018E-7,
                                1.74283640925506E-8,
                                8.8924773311095776E-10,
                                4.1101115319865317E-11,
                                1.7367093848414581E-12,
                                6.7597672400414259E-14,
                                2.4391233866140258E-15,
                                8.2034116145380068E-17,
                                2.583771576869575E-18,
                                7.6523313279767163E-20,
                                2.138860629743989E-21,
                                5.6599594511655524E-23,
                                1.4221048338173659E-24,
                                3.4013984832723061E-26,
                                7.7625443047741554E-28,
                                1.693916882090479E-29,
                                3.54129500676686E-31,
                                7.1053361878044024E-33};
  memcpy(&an[0], &dv[0], 25U * sizeof(real_T));
}

/* End of code generation (lambertMR_MEXIFY.c) */
