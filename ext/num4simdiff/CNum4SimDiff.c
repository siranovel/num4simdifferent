#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdlib.h>
#include "CNum4SimDiff.h"

static double* CNum4SimDiff_doEulerMethod(double *yi, double xi, double h, Func func1, Func func2);
static double* CNum4SimDiff_doHeunMethod(double *yi, double xi, double h, Func func1, Func func2);
static double* CNum4SimDiff_doRungeKuttaMethod(double *yi, double xi, double h, Func func1, Func func2);
static CNum4SimDiff _cNum4SiDiff = {
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
double* CNum4SimDiff_eulerMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    assert(func1 != 0);
    assert(func2 != 0);

    return _cNum4SiDiff.FP_eulerMethod(yi, xi, h, func1, func2);
}
double* CNum4SimDiff_heunMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    assert(func1 != 0);
    assert(func2 != 0);

    return _cNum4SiDiff.FP_heunMethod(yi, xi, h, func1, func2);
}
double* CNum4SimDiff_rungeKuttaMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    assert(func1 != 0);
    assert(func2 != 0);

    return _cNum4SiDiff.FP_rungeKuttaMethod(yi, xi, h, func1, func2);
}
/**************************************/
/* 処理実行部                         */
/**************************************/
/* 
 * オイラー法
 */
static double* CNum4SimDiff_doEulerMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    int i;
    double *f = malloc(sizeof(double) * N);
    double *yi_1 = malloc(sizeof(double) * N);

    f[0] = func1(xi, yi[1]);
    f[1] = func2(xi, yi[1]);
    // yi_1 = yi + h * f(xi, y)
    for (i = 0; i < N; i++) {
        yi_1[i] = yi[i] + h * f[i];
    }
    return yi_1;
}
/*
 * ホイン法
 */
static double* CNum4SimDiff_doHeunMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    int i;
    double *f = malloc(sizeof(double) * N);
    double *yi_1 = malloc(sizeof(double) * N);
    double *k1 = malloc(sizeof(double) * N);
    double *k2 = malloc(sizeof(double) * N);

    f[0] = func1(xi, yi[1]);
    f[1] = func2(xi, yi[1]);
    // k1 = h * f(xi, y)
    // k2 = h * f(xi + h, h * f(xi + h, yi + k1)
    // yi_1 = yi + (k1 + k2) / 2.0;
    for (i = 0; i < N; i++) {
        k1[i] = h * f[i];
        k2[i] = h * (yi[i] + k1[i]);
        yi_1[i] = yi[i] + (k1[i] + k2[i]) / 2.0;
    }
    return yi_1;
}
static double* CNum4SimDiff_doRungeKuttaMethod(double *yi, double xi, double h, Func func1, Func func2)
{
    int i;
    double *f = malloc(sizeof(double) * N);
    double *yi_1 = malloc(sizeof(double) * N);
    double *k1 = malloc(sizeof(double) * N);
    double *k2 = malloc(sizeof(double) * N);
    double *k3 = malloc(sizeof(double) * N);
    double *k4 = malloc(sizeof(double) * N);

    f[0] = func1(xi, yi[1]);
    f[1] = func2(xi, yi[1]);
    // k1 = h * f(xi, y)
    // k2 = h * f(xi + h / 2, yi + k1 / 2)
    // k3 = h * f(xi + h / 2, y1 + k2 / 2)
    // k4 = h * f(xi + h, yi + k3)
    for (i = 0; i < N; i++) {
        k1[i] = h * f[i];
        k2[i] = h * (yi[i] + k1[i] / 2.0);
        k3[i] = h * (yi[i] + k2[i] / 2.0); 
        k4[i] = h * (yi[i] + k3[i]);
        yi_1[i] = yi[i] + (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]) / 6.0;
    }
    return yi_1;
}

