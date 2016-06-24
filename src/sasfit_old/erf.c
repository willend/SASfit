/*
 * src/sasfit_old/erf.c
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
 */

#include "include/SASFIT_nr.h"

double sasfit_erf(double x)
{
    int k;
    double w, t, y;
    static double a[65] = {
        5.958930743e-11, -1.13739022964e-9, 
        1.466005199839e-8, -1.635035446196e-7, 
        1.6461004480962e-6, -1.492559551950604e-5, 
        1.2055331122299265e-4, -8.548326981129666e-4, 
        0.00522397762482322257, -0.0268661706450773342, 
        0.11283791670954881569, -0.37612638903183748117, 
        1.12837916709551257377, 
        2.372510631e-11, -4.5493253732e-10, 
        5.90362766598e-9, -6.642090827576e-8, 
        6.7595634268133e-7, -6.21188515924e-6, 
        5.10388300970969e-5, -3.7015410692956173e-4, 
        0.00233307631218880978, -0.0125498847718219221, 
        0.05657061146827041994, -0.2137966477645600658, 
        0.84270079294971486929, 
        9.49905026e-12, -1.8310229805e-10, 
        2.39463074e-9, -2.721444369609e-8, 
        2.8045522331686e-7, -2.61830022482897e-6, 
        2.195455056768781e-5, -1.6358986921372656e-4, 
        0.00107052153564110318, -0.00608284718113590151, 
        0.02986978465246258244, -0.13055593046562267625, 
        0.67493323603965504676, 
        3.82722073e-12, -7.421598602e-11, 
        9.793057408e-10, -1.126008898854e-8, 
        1.1775134830784e-7, -1.1199275838265e-6, 
        9.62023443095201e-6, -7.404402135070773e-5, 
        5.0689993654144881e-4, -0.00307553051439272889, 
        0.01668977892553165586, -0.08548534594781312114, 
        0.56909076642393639985, 
        1.55296588e-12, -3.032205868e-11, 
        4.0424830707e-10, -4.71135111493e-9, 
        5.011915876293e-8, -4.8722516178974e-7, 
        4.30683284629395e-6, -3.445026145385764e-5, 
        2.4879276133931664e-4, -0.00162940941748079288, 
        0.00988786373932350462, -0.05962426839442303805, 
        0.49766113250947636708
    };
    static double b[65] = {
        -2.9734388465e-10, 2.69776334046e-9, 
        -6.40788827665e-9, -1.6678201321e-8, 
        -2.1854388148686e-7, 2.66246030457984e-6, 
        1.612722157047886e-5, -2.5616361025506629e-4, 
        1.5380842432375365e-4, 0.00815533022524927908, 
        -0.01402283663896319337, -0.19746892495383021487, 
        0.71511720328842845913, 
        -1.951073787e-11, -3.2302692214e-10, 
        5.22461866919e-9, 3.42940918551e-9, 
        -3.5772874310272e-7, 1.9999935792654e-7, 
        2.687044575042908e-5, -1.1843240273775776e-4, 
        -8.0991728956032271e-4, 0.00661062970502241174, 
        0.00909530922354827295, -0.2016007277849101314, 
        0.51169696718727644908, 
        3.147682272e-11, -4.8465972408e-10, 
        6.3675740242e-10, 3.377623323271e-8, 
        -1.5451139637086e-7, -2.03340624738438e-6, 
        1.947204525295057e-5, 2.854147231653228e-5, 
        -0.00101565063152200272, 0.00271187003520095655, 
        0.02328095035422810727, -0.16725021123116877197, 
        0.32490054966649436974, 
        2.31936337e-11, -6.303206648e-11, 
        -2.64888267434e-9, 2.050708040581e-8, 
        1.1371857327578e-7, -2.11211337219663e-6, 
        3.68797328322935e-6, 9.823686253424796e-5, 
        -6.5860243990455368e-4, -7.5285814895230877e-4, 
        0.02585434424202960464, -0.11637092784486193258, 
        0.18267336775296612024, 
        -3.67789363e-12, 2.0876046746e-10, 
        -1.93319027226e-9, -4.35953392472e-9, 
        1.8006992266137e-7, -7.8441223763969e-7, 
        -6.75407647949153e-6, 8.428418334440096e-5, 
        -1.7604388937031815e-4, -0.0023972961143507161, 
        0.0206412902387602297, -0.06905562880005864105, 
        0.09084526782065478489
    };

    w = x < 0 ? -x : x;
    if (w < 2.2) {
        t = w * w;
        k = (int) t;
        t -= k;
        k *= 13;
        y = ((((((((((((a[k] * t + a[k + 1]) * t + 
            a[k + 2]) * t + a[k + 3]) * t + a[k + 4]) * t + 
            a[k + 5]) * t + a[k + 6]) * t + a[k + 7]) * t + 
            a[k + 8]) * t + a[k + 9]) * t + a[k + 10]) * t + 
            a[k + 11]) * t + a[k + 12]) * w;
    } else if (w < 6.9) {
        k = (int) w;
        t = w - k;
        k = 13 * (k - 2);
        y = (((((((((((b[k] * t + b[k + 1]) * t + 
            b[k + 2]) * t + b[k + 3]) * t + b[k + 4]) * t + 
            b[k + 5]) * t + b[k + 6]) * t + b[k + 7]) * t + 
            b[k + 8]) * t + b[k + 9]) * t + b[k + 10]) * t + 
            b[k + 11]) * t + b[k + 12];
        y *= y;
        y *= y;
        y *= y;
        y = 1 - y * y;
    } else {
        y = 1;
    }
    return x < 0 ? -y : y;
}

