/*
 * src/sasfit_sd/sasfit_sd_GaussDistribution.c
 *
 * Copyright (c) 2008-2009, Paul Scherrer Institute (PSI)
 *
 * This file is part of SASfit.
 *
 * SASfit is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SASfit is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SASfit.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Author(s) of this file:
 *   Joachim Kohlbrecher (joachim.kohlbrecher@psi.ch)
 *   Ingo Bressler (ingo@cs.tu-berlin.de)
 */

#include <gsl/gsl_math.h>
#include "include/sasfit_sd_utils.h"


/*
float GaussDistribution(Tcl_Interp *interp,
			  float N,
              float s,
              float R0,
              float R,
              bool  *error)
	      */
/**
 * Calculates a Gauss distribution function.
 */
scalar sasfit_sd_GaussDistribution(scalar x, sasfit_param * param)
{
	scalar N, s, R0;
	scalar c;

	SASFIT_ASSERT_PTR( param );

	sasfit_get_param(param, 3, &N, &s, &R0);

	SASFIT_CHECK_COND1((s == 0.0), param, "s(%lg) == 0", s);

	c = 0.5*sqrt(2.0*M_PI)*fabs(s) + 0.5*sasfit_erf_pure(0.5/fabs(s)*R0*sqrt(2.0))*sqrt(2.0*M_PI)*fabs(s);

	return N/c*exp(-pow(x-R0,2.0)/(2.0*fabs(s)*fabs(s)));
}
