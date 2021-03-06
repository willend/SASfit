/*
 * Author(s) of this file:
 *   Joachim Kohlbrecher (joachim.kohlbrecher@psi.ch)
 */

#ifdef MAKE_SASFIT_PLUGIN
#include "include/private.h"

// functions to mark for export
SASFIT_PLUGIN_EXP_BEGIN(27)
SASFIT_PLUGIN_EXP_ADD( ff_disc_sd_homoxs )
SASFIT_PLUGIN_EXP_ADD( ff_ellsh_sd_homoxs )
SASFIT_PLUGIN_EXP_ADD( ff_cylsh_sd_homoxs )
SASFIT_PLUGIN_EXP_ADD( ff_disc_sd_bilayergauss )
SASFIT_PLUGIN_EXP_ADD( ff_ellsh_sd_bilayergauss )
SASFIT_PLUGIN_EXP_ADD( ff_cylsh_sd_bilayergauss )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_homogeneousplate )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_plate_chains_rw_ )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_layeredcentrosymmetricxs )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_bilayergaus )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_twoinfinitelythinlayers )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___thin_disc )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___thin_spherical_shell )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___thin_ellipsoidal_shell )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___thin_hollow_cylinder )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___rod )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___worm_ps1_ )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___worm_ps2_ )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___worm_ps3_ )
SASFIT_PLUGIN_EXP_ADD( sq_p__q___kholodenko_worm )
SASFIT_PLUGIN_EXP_ADD( ff_ellcylsh_sd_rod )
SASFIT_PLUGIN_EXP_ADD( ff_ellcylsh_sd_worm_ps1 )
SASFIT_PLUGIN_EXP_ADD( ff_ellcylsh_sd_worm_ps2 )
SASFIT_PLUGIN_EXP_ADD( ff_ellcylsh_sd_worm_ps3 )
SASFIT_PLUGIN_EXP_ADD( ff_ellcylsh_sd_worm_kholodenko )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_homogeneouscyl )
SASFIT_PLUGIN_EXP_ADD( ff_pcs_ellcylsh )

SASFIT_PLUGIN_EXP_END

// import functions from other plugins
SASFIT_PLUGIN_IMP_NONE

SASFIT_PLUGIN_INTERFACE

void do_at_init(void)
{
	// insert custom init code here (optional)
}

#endif

