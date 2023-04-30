#ifndef _CNum4SimDiff_H_
#define _CNum4SimDiff_H_

/**************************************/
/* 構造体宣言                          */
/**************************************/
typedef struct _CNum4SimDiff CNum4SimDiff;
typedef double (*Func)(double x, double dx);

struct _CNum4SimDiff
{
    double* (*FP_eulerMethod)(double *yi, double xi, double h, Func func1, Func func2);
    double* (*FP_heunMethod)(double *yi, double xi, double h, Func func1, Func func2);
    double* (*FP_rungeKuttaMethod)(double *yi, double xi, double h, Func func1, Func func2);
};
/**************************************/
/* define宣言                         */
/**************************************/
#define N 2
/**************************************/
/* プロトタイプ宣言                    */
/**************************************/
double* CNum4SimDiff_eulerMethod(double *yi, double xi, double h, Func func1, Func func2);
double* CNum4SimDiff_heunMethod(double *yi, double xi, double h, Func func1, Func func2);
double* CNum4SimDiff_rungeKuttaMethod(double *yi, double xi, double h, Func func1, Func func2);
#endif
