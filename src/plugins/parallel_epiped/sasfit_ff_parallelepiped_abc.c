/*
 * Author(s) of this file:
 *   <your name> (<email address>)
 */

#include "include/private.h"
#include <sasfit_error_ff.h>

// define shortcuts for local parameters/variables
#define A	param->p[0]
#define B	param->p[1]
#define C	param->p[2]
#define ETA	param->p[3]
#define Q	param->p[MAXPAR-1]
#define ALPHA	param->p[MAXPAR-2]
#define BETA	param->p[MAXPAR-3]

scalar sinc(scalar x)
{
	if (x == 0) {
		return 1.0;
	} else {
		return sin(x)/x;
	}
}

scalar Psi_P_kernel(scalar y, sasfit_param * param)
{
	ALPHA = y;
	return 2./M_PI * gsl_pow_2(sinc(Q*A/2.0*sin(ALPHA)*cos(BETA)) *
				               sinc(Q*B/2.0*sin(ALPHA)*sin(BETA)) *
							   sinc(Q*C/2.0*cos(ALPHA))) * sin(ALPHA);
}

scalar Psi_kernel(scalar x, sasfit_param * param)
{
	BETA = x;
	return sasfit_integrate(0.0,M_PI/2.0,&Psi_P_kernel,param);
}

scalar sasfit_ff_parallelepiped_abc(scalar q, sasfit_param * param)
{
	SASFIT_ASSERT_PTR(param); // assert pointer param is valid

	SASFIT_CHECK_COND1((q < 0.0), param, "q(%lg) < 0",q);
	SASFIT_CHECK_COND1((A < 0.0), param, "a(%lg) < 0",A); // modify condition to your needs
	SASFIT_CHECK_COND1((B < 0.0), param, "b(%lg) < 0",B); // modify condition to your needs
	SASFIT_CHECK_COND1((C < 0.0), param, "c(%lg) < 0",C); // modify condition to your needs
	SASFIT_CHECK_COND1((ETA < 0.0), param, "eta(%lg) < 0",ETA); // modify condition to your needs

	Q=q;
	// insert your code here
	return gsl_pow_2(ETA*sasfit_ff_parallelepiped_abc_v(q,param,1))
			*sasfit_integrate(0.0,M_PI/2.0,&Psi_kernel,param);
}

scalar sasfit_ff_parallelepiped_abc_f(scalar q, sasfit_param * param)
{
	SASFIT_ASSERT_PTR(param); // assert pointer param is valid

	// insert your code here
	return 0.0;
}

scalar sasfit_ff_parallelepiped_abc_v(scalar q, sasfit_param * param, int dist)
{
	SASFIT_ASSERT_PTR(param); // assert pointer param is valid

	// insert your code here
	return A*B*C;
}

