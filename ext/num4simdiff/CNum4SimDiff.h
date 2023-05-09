#ifndef _CNum4SimDiff_H_
#define _CNum4SimDiff_H_

/**************************************/
/* 構造体宣言                          */
/**************************************/
typedef struct _CNum4SimDiff CNum4SimDiff;

struct _CNum4SimDiff
{
    double* (*FP_eulerMethod)(int n, double *yi, double h, double *f);
    double* (*FP_heunMethod)(int n, double *yi, double h, double *f);
    double* (*FP_rungeKuttaMethod)(int n, double *yi, double h, double *f);
};
/**************************************/
/* define宣言                         */
/**************************************/
/**************************************/
/* プロトタイプ宣言                    */
/**************************************/
double* CNum4SimDiff_eulerMethod(int n, double *yi, double h, double *f);
double* CNum4SimDiff_heunMethod(int n, double *yi, double h, double *f);
double* CNum4SimDiff_rungeKuttaMethod(int n, double *yi, double h, double *f);
#endif
