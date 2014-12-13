/*
 * src/sasfit_sq/sasfit_sq_Cylinder_PRISM.c
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
#include "include/sasfit_sq_utils.h"

/*
float S_Cylinder_PRISM(Tcl_Interp *interp,
			 float Q,
			 float R,
			 float L,
			 float nu,
			bool  *error)
*/

/**
 * Random Distribution Model
 * eta hole volume fraction
 * hole radius
 */
scalar sasfit_sq_Cylinder_PRISM(scalar q, sasfit_param * param)
{
	scalar cq,P15,xP15, R, L, nu;

	SASFIT_ASSERT_PTR( param );

	sasfit_get_param(param, 3, &R, &L, &nu);

	SASFIT_CHECK_COND1((q < 0.0), param, "q(%lg) < 0",q);
	SASFIT_CHECK_COND1((L-2*R < 0.0), param, "L-2*R (%lg) < 0",L-2*R);
	SASFIT_CHECK_COND1((R < 0.0), param, "R(%lg) < 0",R);
	SASFIT_CHECK_COND1((nu < 0.0), param, "nu(%lg) < 0",nu);

	xP15 = q*(L-2.0*R);
	q = q*2.0*R;
	P15 = 2.0*sasfit_si(xP15)/xP15 - 4.0*pow(sin(xP15/2.0)/xP15,2.0);
	if (R == 0) 
	{
		cq = 1;
	} else {
		cq = 3.0*(sin(q)-q*cos(q))/pow(q,3.0);
	}
	return 1./(1.0+nu*cq*P15);
}
