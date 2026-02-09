/* SPDX-FileCopyrightText: 2020 Massimiliano Fasi and Mantas Mikaitis */
/* SPDX-License-Identifier: LGPL-2.1-or-later                         */

/**
 * @file cpfloat.h
 * @brief CPFloat header file.
 */

#ifndef _CPFLOAT_
#define _CPFLOAT_

#include "cpfloat_docmacros.h"
#include "cpfloat_definitions.h"





doc_cpfloat_validate_optstruct(double, 12, 24, -126, 127)
int cpfloat_validate_optstructf(const optstruct *fpopts);

doc_cpfloat(float, 24, -126, 127)
int cpfloatf(float *X, const float *A, const size_t numelem,
                           optstruct *fpopts);
doc_cpfloat(float, 24, -126, 127)
int cpf_fproundf(float *X, const float *A,
                               const size_t numelem, optstruct *fpopts);

doc_cpf_bivariate(sum, \f$ X_i = A_i + B_i \f$, 24, -126, 127)
int cpf_addf(float *X, const float *A, const float *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(difference, \f$ X_i = A_i - B_i \f$, 24, -126, 127)
int cpf_subf(float *X, const float *A, const float *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(product, \f$ X_i = A_i \times B_i \f$, 24, -126, 127)
int cpf_mulf(float *X, const float *A, const float *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(ratio, \f$ X_i = A_i / B_i \f$, 24, -126, 127)
int cpf_divf(float *X, const float *A, const float *B,
                           const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(trigonometric cosine, \f$ X_i = \cos(A_i) \f$, 24, -126, 127)
int cpf_cosf(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(trigonometric sine, \f$ X_i = \sin(A_i) \f$, 24, -126, 127)
int cpf_sinf(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(trigonometric tangent, \f$ X_i = \tan(A_i) \f$, 24, -126, 127)
int cpf_tanf(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(inverse trigonometric cosine,
                   \f$ X_i = \mathrm{acos}(A_i) \f$, 24, -126, 127)
int cpf_acosf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse trigonometric sine,
                   \f$ X_i = \mathrm{asin}(A_i) \f$, 24, -126, 127)
int cpf_asinf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse trigonometric tangent,
                   \f$ X_i = \mathrm{atan}(A_i) \f$, 24, -126, 127)
int cpf_atanf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(2-argument arctangent,
                  \f$ X_i = \mathrm{atan} (B_i / A_i) \f$, 24, -126, 127)
int cpf_atan2f(float *X, const float *A, const float *B,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(hyperbolic cosine, \f$ X_i = \mathrm{cosh}(A_i) \f$, 24, -126, 127)
int cpf_coshf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(hyperbolic sine, \f$ X_i = \mathrm{sinh}(A_i) \f$, 24, -126, 127)
int cpf_sinhf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(hyperbolic tangent , \f$ X_i = \mathrm{tanh}(A_i) \f$, 24, -126, 127)
int cpf_tanhf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(inverse hyperbolic cosine,
                   \f$ X_i = \mathrm{arcosh}(A_i) \f$, 24, -126, 127)
int cpf_acoshf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse hyperbolic sine,
                   \f$ X_i = \mathrm{arsinh}(A_i) \f$, 24, -126, 127)
int cpf_asinhf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse hyperbolic tangent,
                   \f$ X_i = \mathrm{artanh}(A_i) \f$, 24, -126, 127)
int cpf_atanhf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(exponential, \f$ X_i = \exp(A_i) \f$, 24, -126, 127)
int cpf_expf(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);

doc_cpf_frexp(24, -126, 127)
int cpf_frexpf(float *X, int *exp, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(2, 24, -126, 127)
int cpf_ldexpf(float *X, const float *A, const int *exp,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(natural logarithm, \f$ X_i = \log(A_i) \f$, 24, -126, 127)
int cpf_logf(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-10 logarithm, \f$ X_i = \log_{10}(A_i) \f$, 24, -126, 127)
int cpf_log10f(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_modf(24, -126, 127)
int cpf_modff(float *X, float *intpart, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-2 exponential, \f$ X_i = 2^{A_i} \f$, 24, -126, 127)
int cpf_exp2f(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(exp(x) - 1, \f$ X_i = \exp(A_i) - 1 \f$, 24, -126, 127)
int cpf_expm1f(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_ilogb(24, -126, 127)
int cpf_ilogbf(int *exp, const float *A,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(natural logarithm of number shifted by one,
                   \f$ X_i = \log(1+A_i) \f$, 24, -126, 127)
int cpf_log1pf(float *X, const float *A,
                             size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-2 logarithm, \f$ X_i = \log_2(A_i) \f$, 24, -126, 127)
int cpf_log2f(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-FLT_RADIX logarithm of absolute value,
                   \f$ X_i = \log(\lvert A_i \rvert) \f$, 24, -126, 127)
int cpf_logbf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(FLT\_RADIX, 24, -126, 127)
int cpf_scalbnf(float *X, const float *A, const int *exp,
                              const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(FLT\_RADIX, 24, -126, 127)
int cpf_scalblnf(float *X, const float *A,
                               const long int *exp, const size_t numelem,
                               optstruct *fpopts);

doc_cpf_bivariate(real powers, \f$ X_i = A_i^{B_i} \f$, 24, -126, 127)
int cpf_powf(float *X, const float *A, const float *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(square root, \f$ X_i = \sqrt{A_i} \f$, 24, -126, 127)
int cpf_sqrtf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(cube root, \f$ X_i = \sqrt[3]{A_i} \f$, 24, -126, 127)
int cpf_cbrtf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(hypotenuse of a right-angle triangle,
                  \f$ X_i = \sqrt{A_i^2 + B_i^2} \f$, 24, -126, 127)
int cpf_hypotf(float *X, const float *A, const float *B,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(error function, \f$ X_i = \mathrm{erf}(A_i) \f$, 24, -126, 127)
int cpf_erff(float *X, const float *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(complementary error function,
                   \f$ X_i = \mathrm{erfc}(A_i) \f$, 24, -126, 127)
int cpf_erfcf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(gamma function, \f$ X_i = \Gamma(A_i) \f$, 24, -126, 127)
int cpf_tgammaf(float *X, const float *A,
                              const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(natural logarithm of absolute value of gamma function,
                   \f$ X_i = \log(\lvert \Gamma(A_i) \rvert) \f$, 24, -126, 127)
int cpf_lgammaf(float *X, const float *A,
                              const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(ceiling function, \f$ X_i = \lceil A_i \rceil \f$, 24, -126, 127)
int cpf_ceilf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(floor function, \f$ X_i = \lfloor A_i \rfloor \f$, 24, -126, 127)
int cpf_floorf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(floating-point remainder of division,
                  \f$ X_i = A_i \;\mathrm{mod}\; B_i \f$, 24, -126, 127)
int cpf_fmodf(float *X, const float *A, const float *B,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(integer truncation, \f$ X_i = \mathrm{trunc}(A_i) \f$, 24, -126, 127)
int cpf_truncf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(closest integer (with round-to-nearest),
                   \f$ X_i = \mathrm{round}(A_i) \f$, 24, -126, 127)
int cpf_roundf(float *X, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(closest integer (with round-to-nearest),
                   \f$ X_i = \mathrm{round}(A_i) \f$, 24, -126, 127)
int cpf_lroundf(long *X, const float *A,
                              const size_t numelem, optstruct *fpopts);
doc_cpf_univariate_nobitflip(closest integer (with round-to-nearest),
                             \f$ X_i = \mathrm{round}(A_i) \f$, 24, -126, 127)
int cpf_llroundf(long long *X, const float *A,
                               const size_t numelem, optstruct *fpopts);

doc_cpf_rint(PMAX, -126, 127)
int cpf_rintf(float *X, int *exception, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_rint(24, -126, 127)
int cpf_lrintf(long *X, int *exception, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_rint(24, -126, 127)
int cpf_llrintf(long long *X, int *exception, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_nearbyint(24, -126, 127)
int cpf_nearbyintf(float *X, const float *A,
                                 const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(remainder of the floating point division,
                  \f$ X_i = A_i^2 - k \times B_i \f$
                  for largest \f$ k \f$ such that \f$ k \times B_i < A_i \f$,
                  24, -126, 127)
int cpf_remainderf(float *X, const float *A, const float *B,
                                 const size_t numelem, optstruct *fpopts);

doc_cpf_remquo(24, -126, 127)
int cpf_remquof(float *X, int *quot,
                              const float *A, const float *B,
                              const size_t numelem, optstruct *fpopts);

doc_cpf_bivariate(number from magnitude and sign,
                  \f$ X_i = \mathrm{sign}(A_i) \times \lvert B_i \rvert \f$,
                  24, -126, 127)
int cpf_copysignf(float *X, const float *A, const float *B,
                                const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(next floating-point number in specified direction,
                  the floating-point number closest to \f$ A_i \f$ in the
                  direction of \f$ B_i \f$, 24, -126, 127)
int cpf_nextafterf(float *X, const float *A, const float *B,
                                 const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(next floating-point number in specified direction,
                  the floating-point number closest to \f$ A_i \f$ in the
                  direction of \f$ B_i \f$, 24, -126, 127)
int cpf_nexttowardf(float *X, const float *A,
                                  const long double *B,
                                  const size_t numelem,
                                  optstruct *fpopts);

doc_cpf_bivariate(positive difference, \f$ X_i = \lvert A_i - B_i \rvert \f$,
                  24, -126, 127)
int cpf_fdimf(float *X, const float *A, const float *B,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(element-wise maximum, \f$ X_i = \mathrm{max}(A_i, B_i) \f$,
                  24, -126, 127)
int cpf_fmaxf(float *X, const float *A, const float *B,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(element-wise minimum, \f$ X_i = \mathrm{min}(A_i, B_i) \f$,
                  24, -126, 127)
int cpf_fminf(float *X, const float *A, const float *B,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_fpclassify(24, -126, 127)
int cpf_fpclassifyf(int *r, const float *A,
                                  const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(finite, 24, -126, 127)
int cpf_isfinitef(int *r, const float *A,
                                const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(infinite, 24, -126, 127)
int cpf_isinff(int *r, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(not a number, 24, -126, 127)
int cpf_isnanf(int *r, const float *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(normal, 24, -126, 127)
int cpf_isnormalf(int *r, const float *A,
                                const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(absolute value, \f$ X_i = \lvert A_i \rvert \f$, 24, -126, 127)
int cpf_fabsf(float *X, const float *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_trivariate(fused multiply-add , \f$ X_i = A_i \times B_i + C_i \f$,
                   24, -126, 127)
int cpf_fmaf(float *X, const float *A, const float *B,
                           const float *C, const size_t numelem,
                           optstruct *fpopts);







doc_cpfloat_validate_optstruct(double, 26, 53, -1022, 1023)
int cpfloat_validate_optstruct(const optstruct *fpopts);

doc_cpfloat(double, 53, -1022, 1023)
int cpfloat(double *X, const double *A, const size_t numelem,
                          optstruct *fpopts);
doc_cpfloat(double, 53, -1022, 1023)
int cpf_fpround(double *X, const double *A,
                              const size_t numelem, optstruct *fpopts);

doc_cpf_bivariate(sum, \f$ X_i = A_i + B_i \f$, 53, -1022, 1023)
int cpf_add(double *X, const double *A, const double *B,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(difference, \f$ X_i = A_i - B_i \f$, 53, -1022, 1023)
int cpf_sub(double *X, const double *A, const double *B,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(product, \f$ X_i = A_i \times B_i \f$, 53, -1022, 1023)
int cpf_mul(double *X, const double *A, const double *B,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(ratio, \f$ X_i = A_i / B_i \f$, 53, -1022, 1023)
int cpf_div(double *X, const double *A, const double *B,
                          const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(trigonometric cosine, \f$ X_i = \cos(A_i) \f$, 53, -1022, 1023)
int cpf_cos(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(trigonometric sine, \f$ X_i = \sin(A_i) \f$, 53, -1022, 1023)
int cpf_sin(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(trigonometric tangent, \f$ X_i = \tan(A_i) \f$, 53, -1022, 1023)
int cpf_tan(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(inverse trigonometric cosine,
                   \f$ X_i = \mathrm{acos(A_i)} \f$, 53, -1022, 1023)
int cpf_acos(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse trigonometric sine,
                   \f$ X_i = \mathrm{asin}(A_i) \f$, 53, -1022, 1023)
int cpf_asin(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse trigonometric tangent,
                   \f$ X_i = \mathrm{atan}(A_i) \f$, 53, -1022, 1023)
int cpf_atan(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(2-argument arctangent,
                  \f$ X_i = \mathrm{atan}(B_i / A_i) \f$, 53, -1022, 1023)
int cpf_atan2(double *X, const double *A, const double *B,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(hyperbolic cosine, \f$ X_i = \mathrm{cosh}(A_i) \f$,
                   53, -1022, 1023)
int cpf_cosh(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(hyperbolic sine, \f$ X_i = \mathrm{sinh}(A_i) \f$, 53, -1022, 1023)
int cpf_sinh(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(hyperbolic tangent , \f$ X_i = \mathrm{tanh}(A_i) \f$,
                   53, -1022, 1023)
int cpf_tanh(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(inverse hyperbolic cosine,
                   \f$ X_i = \mathrm{arcosh}(A_i) \f$, 53, -1022, 1023)
int cpf_acosh(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse hyperbolic sine,
                   \f$ X_i = \mathrm{arsinh}(A_i) \f$, 53, -1022, 1023)
int cpf_asinh(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(inverse hyperbolic tangent,
                   \f$ X_i = \mathrm{artanh}(A_i) \f$, 53, -1022, 1023)
int cpf_atanh(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(exponential, \f$ X_i = \exp(A_i) \f$, 53, -1022, 1023)
int cpf_exp(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);

doc_cpf_frexp(53, -1022, 1023)
int cpf_frexp(double *X, int *exp, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(2, 53, -1022, 1023)
int cpf_ldexp(double *X, const double *A, const int *exp,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(natural logarithm, \f$ X_i = \log(A_i) \f$, 53, -1022, 1023)
int cpf_log(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base - 10 logarithm, \f$ X_i = \log_{10}(A_i) \f$, 53, -1022, 1023)
int cpf_log10(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_modf(53, -1022, 1023)
int cpf_modf(double *X, double *intpart, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-2 exponential, \f$ X_i = 2^{A_i} \f$, 53, -1022, 1023)
int cpf_exp2(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(exp(x) - 1, \f$ X_i = \exp(A_i) - 1 \f$, 53, -1022, 1023)
int cpf_expm1(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_ilogb(53, -1022, 1023)
int cpf_ilogb(int *exp, const double *A,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(natural logarithm of number shifted by one,
                   \f$ X_i = \log(1+A_i) \f$, 53, -1022, 1023)
int cpf_log1p(double *X, const double *A,
                            size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-2 logarithm, \f$ X_i = \log_2(A_i) \f$, 53, -1022, 1023)
int cpf_log2(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(base-FLT_RADIX logarithm of absolute value,
                   \f$ X_i = \log(\lvert A_i \rvert) \f$, 53, -1022, 1023)
int cpf_logb(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(FLT\_RADIX, 53, -1022, 1023)
  int cpf_scalbn(double *X, const double *A, const int *exp,
                               const size_t numelem, optstruct *fpopts);
doc_cpf_scaling(FLT\_RADIX, 53, -1022, 1023)
  int cpf_scalbln(double *X, const double *A,
                                const long int *exp, const size_t numelem,
                                optstruct *fpopts);

doc_cpf_bivariate(real powers, \f$ X_i = A_i^{B_i} \f$, 53, -1022, 1023)
int cpf_pow(double *X, const double *A, const double *B,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(square root, \f$ X_i = \sqrt{A_i} \f$, 53, -1022, 1023)
int cpf_sqrt(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(cube root, \f$ X_i = \sqrt[3]{A_i} \f$, 53, -1022, 1023)
int cpf_cbrt(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(hypotenuse of a right-angle triangle,
                  \f$ X_i = \sqrt{A_i^2 + B_i^2} \f$, 53, -1022, 1023)
int cpf_hypot(double *X, const double *A, const double *B,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(error function, \f$ X_i = \mathrm{erf}(A_i) \f$, 53, -1022, 1023)
int cpf_erf(double *X, const double *A,
                          const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(complementary error function,
                   \f$ X_i = \mathrm{erfc}(A_i) \f$, 53, -1022, 1023)
int cpf_erfc(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(gamma function, \f$ X_i = \Gamma(A_i) \f$, 53, -1022, 1023)
int cpf_tgamma(double *X, const double *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(natural logarithm of absolute value of gamma function,
                   \f$ X_i = \log(\lvert \Gamma(A_i) \rvert) \f$, 53, -1022, 1023)
int cpf_lgamma(double *X, const double *A,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(ceiling function, \f$ X_i = \lceil A_i \rceil \f$, 53, -1022, 1023)
int cpf_ceil(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(floor function, \f$ X_i = \lfloor A_i \rfloor \f$, 53, -1022, 1023)
int cpf_floor(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(floating-point remainder of division,
                  \f$ X_i = A_i \;\mathrm{mod}\; B_i \f$, 53, -1022, 1023)
int cpf_fmod(double *X, const double *A, const double *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(integer truncation, \f$ X_i = \mathrm{trunc}(A_i) \f$,
                   53, -1022, 1023)
int cpf_trunc(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(closest integer (with round-to-nearest),
                   \f$ X_i = \mathrm{round}(A_i) \f$, 53, -1022, 1023)
int cpf_round(double *X, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_univariate(closest integer (with round-to-nearest),
                   \f$ X_i = \mathrm{round}(A_i) \f$, 53, -1022, 1023)
int cpf_lround(long *X, const double *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_univariate_nobitflip(closest integer (with round-to-nearest),
                             \f$ X_i = \mathrm{round}(A_i) \f$, 53, -1022, 1023)
int cpf_llround(long long *X, const double *A,
                              const size_t numelem, optstruct *fpopts);

doc_cpf_rint(53, -1022, 1023)
int cpf_rint(double *X, int *exception, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_rint(53, -1022, 1023)
int cpf_lrint(long *X, int *exception, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_rint(53, -1022, 1023)
int cpf_llrint(long long *X, int *exception, const double *A,
                             const size_t numelem, optstruct *fpopts);
doc_cpf_nearbyint(53, -1022, 1023)
int cpf_nearbyint(double *X, const double *A,
                                const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(remainder of the floating point division,
                  \f$ X_i = A_i^2 - k \times B_i \f$
                  for largest \f$ k \f$ such that \f$ k \times B_i < A_i \f$,
                  53, -1022, 1023)
int cpf_remainder(double *X, const double *A, const double *B,
                                const size_t numelem, optstruct *fpopts);

doc_cpf_remquo(53, -1022, 1023)
int cpf_remquo(double *X, int *quot,
                             const double *A, const double *B,
                             const size_t numelem, optstruct *fpopts);

doc_cpf_bivariate(number from magnitude and sign,
                  \f$ X_i = \mathrm{sign}(A_i) * abs(B_i) \f$, 53, -1022, 1023)
int cpf_copysign(double *X, const double *A, const double *B,
                               const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(next floating-point number in specified direction,
                  the floating-point number closest to \f$ A_i \f$ in the
                  direction of \f$ B_i \f$, 53, -1022, 1023)
int cpf_nextafter(double *X, const double *A, const double *B,
                                const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(next floating-point number in specified direction,
                  the floating-point number closest to \f$ A_i \f$ in the
                  direction of \f$ B_i \f$, 53, -1022, 1023)
int cpf_nexttoward(double *X, const double *A,
                                 const long double *B, const size_t numelem,
                                 optstruct *fpopts);

doc_cpf_bivariate(positive difference, \f$ X_i = \lvert A_i \rvert - B_i \f$,
                  53, -1022, 1023)
int cpf_fdim(double *X, const double *A, const double *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(element-wise maximum, \f$ X_i = \mathrm{max}(A_i, B_i) \f$,
                  53, -1022, 1023)
int cpf_fmax(double *X, const double *A, const double *B,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_bivariate(element-wise minimum, \f$ X_i = \mathrm{min}(A_i, B_i) \f$,
                  53, -1022, 1023)
int cpf_fmin(double *X, const double *A, const double *B,
                           const size_t numelem, optstruct *fpopts);

doc_cpf_fpclassify(53, -1022, 1023)
int cpf_fpclassify(int *r, const double *A,
                                 const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(finite, 53, -1022, 1023)
int cpf_isfinite(int *r, const double *A,
                               const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(infinite, 53, -1022, 1023)
int cpf_isinf(int *r, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(not a number, 53, -1022, 1023)
int cpf_isnan(int *r, const double *A,
                            const size_t numelem, optstruct *fpopts);
doc_cpf_isfun(normal, 53, -1022, 1023)
int cpf_isnormal(int *r, const double *A,
                               const size_t numelem, optstruct *fpopts);

doc_cpf_univariate(absolute value, \f$ X_i = \lvert A_i \rvert \f$, 53, -1022, 1023)
int cpf_fabs(double *X, const double *A,
                           const size_t numelem, optstruct *fpopts);
doc_cpf_trivariate(fused multiply-add , \f$ X_i = A_i \times B_i + C_i \f$,
                   53, -1022, 1023)
int cpf_fma(double *X, const double *A, const double *B,
                          const double *C, const size_t numelem,
                          optstruct *fpopts);



#endif /* #ifndef _CPFLOAT_ */