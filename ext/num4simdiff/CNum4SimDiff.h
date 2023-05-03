#ifndef _CNum4SimDiff_H_
#define _CNum4SimDiff_H_

/**************************************/
/* 構造体宣言                          */
/**************************************/
typedef struct _CNum4SimDiff CNum4SimDiff;
typedef double* (*Func)(int n, double* yi);

struct _CNum4SimDiff
{
    double* (*FP_dmy)(int n, double *yi, double h, Func func);
    double* (*FP_eulerMethod)(int n, double *yi, double h, Func func);
    double* (*FP_heunMethod)(int n, double *yi, double h, Func func);
    double* (*FP_rungeKuttaMethod)(int n, double *yi, double h, Func func);
};
/**************************************/
/* define宣言                         */
/**************************************/
/**************************************/
/* プロトタイプ宣言                    */
/**************************************/
double* CNum4SimDiff_dmy(int n, double *yi, double h, Func func);
double* CNum4SimDiff_eulerMethod(int n, double *yi, double h, Func func);
double* CNum4SimDiff_heunMethod(int n, double *yi, double h, Func func);
double* CNum4SimDiff_rungeKuttaMethod(int n, double *yi, double h, Func func);
#endif
