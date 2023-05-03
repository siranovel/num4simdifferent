#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdlib.h>
#include "CNum4SimDiff.h"

static double* CNum4SimDiff_doDmy(int n, double *yi, double h, Func func);
static double* CNum4SimDiff_doEulerMethod(int n, double *yi, double h, Func func);
static double* CNum4SimDiff_doHeunMethod(int n, double *yi, double h, Func func);
static double* CNum4SimDiff_doRungeKuttaMethod(int n, double *yi, double h, Func func);
static CNum4SimDiff _cNum4SiDiff = {
    .FP_dmy              = CNum4SimDiff_doDmy,
    .FP_eulerMethod      = CNum4SimDiff_doEulerMethod,
    .FP_heunMethod       = CNum4SimDiff_doHeunMethod,
    .FP_rungeKuttaMethod = CNum4SimDiff_doRungeKuttaMethod,
};
/**************************************/
/* InterFface部                       */
/**************************************/
/**************************************/
/* Class部                            */
/**************************************/
double* CNum4SimDiff_dmy(int n, double *yi, double h, Func func)
{
    assert(func != 0);

    return _cNum4SiDiff.FP_dmy(n, yi, h, func);
}
double* CNum4SimDiff_eulerMethod(int n, double *yi, double h, Func func)
{
    assert(func != 0);

    return _cNum4SiDiff.FP_eulerMethod(n, yi,  h, func);
}
double* CNum4SimDiff_heunMethod(int n, double *yi, double h, Func func)
{
    assert(func != 0);

    return _cNum4SiDiff.FP_heunMethod(n, yi, h, func);
}
double* CNum4SimDiff_rungeKuttaMethod(int n, double *yi, double h, Func func)
{
    assert(func != 0);

    return _cNum4SiDiff.FP_rungeKuttaMethod(n, yi, h, func);
}
/**************************************/
/* 処理実行部                         */
/**************************************/
static double* CNum4SimDiff_doDmy(int n, double *yi, double h, Func func)
{
    return func(2, yi);
}
/* 
 * オイラー法
 */
static double* CNum4SimDiff_doEulerMethod(int n, double *yi, double h, Func func)
{
    int i;
    double *f = func(n, yi);
    double *yi_1 = malloc(sizeof(double) * n);

    // yi_1 = yi + h * f(xi, y)
    for (i = 0; i < n; i++) {
        yi_1[i] = yi[i] + h * f[i];
    }
    return yi_1;
}
/*
 * ホイン法
 */
static double* CNum4SimDiff_doHeunMethod(int n, double *yi, double h, Func func)
{
    int i;
    double *f = func(n, yi);
    double *yi_1 = malloc(sizeof(double) * n);
    double *k1 = malloc(sizeof(double) * n);
    double *k2 = malloc(sizeof(double) * n);

    // k1 = h * f(xi, y)
    // k2 = h * f(xi + h, h * f(xi + h, yi + k1)
    // yi_1 = yi + (k1 + k2) / 2.0;
    for (i = 0; i < n; i++) {
        k1[i] = h * f[i];
        k2[i] = h * (yi[i] + k1[i]);
        yi_1[i] = yi[i] + (k1[i] + k2[i]) / 2.0;
    }
    return yi_1;
}
static double* CNum4SimDiff_doRungeKuttaMethod(int n, double *yi, double h, Func func)
{
    int i;
    double *f = func(n, yi);
    double *yi_1 = malloc(sizeof(double) * n);
    double *k1 = malloc(sizeof(double) * n);
    double *k2 = malloc(sizeof(double) * n);
    double *k3 = malloc(sizeof(double) * n);
    double *k4 = malloc(sizeof(double) * n);

    // k1 = h * f(xi, y)
    // k2 = h * f(xi + h / 2, yi + k1 / 2)
    // k3 = h * f(xi + h / 2, y1 + k2 / 2)
    // k4 = h * f(xi + h, yi + k3)
    for (i = 0; i < n; i++) {
        k1[i] = h * f[i];
        k2[i] = h * (yi[i] + k1[i] / 2.0);
        k3[i] = h * (yi[i] + k2[i] / 2.0); 
        k4[i] = h * (yi[i] + k3[i]);
        yi_1[i] = yi[i] + (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]) / 6.0;
    }
    return yi_1;
}

