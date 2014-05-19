"""
Python code to generate 4 and 5 digit NACA profiles

Based on Matlab code, licensed under the BSD license, by Divahar
Jayaraman:

    * http://www.mathworks.com/matlabcentral/fileexchange/19915-naca-4-digit-airfoil-generator
    * http://www.mathworks.com/matlabcentral/fileexchange/23241-naca-5-digit-airfoil-generator

References:

    [1] Jacobs, Eastman N., Ward, Kenneth E., and Pinkerton, Robert
    M.: "The Characteristics of 78 Related Airfoil Sections From Tests
    in the Variable-Density Wind Tunnel"; NACA Report 537; National
    Advisory Committee for Aeronautics, Washington D.C.; November,
    1933.

    [2] Jacobs, Eastman N., and Pinkerton, Robert M.: "Tests in the
    Variable-Density Wind Tunnel of Related Airfoils Having the
    Maximum Camber Unusually Far Forward"; NACA Report 537; National
    Advisory Committee for Aeronautics, Washington D.C.; November,
    1935.

    [2] Ladson, Charles L., and Brooks, Cuyler W, Jr.: "Development of
    a Computer Program to Obtain Ordinates for NACA 4-Digit, 4-Digit
    Modified, 5-Digit, and 16-Series Airfoils"; NASA Technical
    Memorandum X-3284; NASA, Washington, DC; 1975.


Copyright (c) 2014, Emmet Caulfield

"""

import math
import numpy as np
import scipy.interpolate as si

#: The following are the 87 canonical NACA 4-digit profiles:
naca4canonical = [
    '0006', '0009', '0012', '0015', '0018', '0021', '0025',

    '2206', '2209', '2212', '2215', '2218', '2221',
    '2306', '2309', '2312', '2315', '2318', '2321',
    '2406', '2409', '2412', '2415', '2418', '2421',
    '2506', '2509', '2512', '2515', '2518', '2521',
    '2606', '2609', '2612', '2615', '2618', '2621',
    '2706', '2709', '2712', '2715', '2718', '2721',

    '4206', '4209', '4212', '4215', '4218', '4221',
    '4306', '4309', '4312', '4315', '4318', '4321',
    '4406', '4409', '4412', '4415', '4418', '4421',
    '4506', '4509', '4512', '4515', '4518', '4521',
    '4606', '4609', '4612', '4615', '4618', '4621',
    '4706', '4709', '4712', '4715', '4718', '4721',

    '6206', '6209', '6212', '6215', '6218', '6221',
    '6306', '6309', '6312', '6315', '6318', '6321',
    '6406', '6409', '6412', '6415', '6418', '6421',
    '6506', '6509', '6512', '6515', '6518', '6521',
    '6606', '6609', '6612', '6615', '6618', '6621',
    '6706', '6709', '6712', '6715', '6718', '6721'
]
naca4canonical_regex = '^(0025|(00|[246][2-7])(0[69]|1[258]|21))$'


naca5canonical = [
    '21012', '22012', '23012', '24012', '25012',
    '21112', '22112', '23112', '24112', '25112'
]
naca5canonical_regex = '^2[1-5][01]12$'


def isCanonical(profile):
    if len(profile)==4:
        if profile in naca4canonical:
            return True
    elif len(profile)==5:
        if profile in naca5canonical:
            return True
    return False


def naca(profile, n, finite_TE=False, half_cosine_spacing=False):
    '''
    Returns four numpy vectors: the x- and y- coordinates of the foil
    surface and the camber line.

    In all cases "percent" refers to percentage of chord length. NACA
    airfoils are always considered normalized to the chord length, and
    are drawn "facing left" with the leading edge at the origin and
    the trailing edge at [1,0]. 

    The *camber* is, by definition, "the maximum ordinate of the mean
    line"[1], or, in modern parlance, the maximum value of the
    y-coordinate. The *position of the camber* is the corresponding
    x-coordinate.

    A NACA 4-digit profiles [1], "MPTT" consist of three parts:
    
        * One digit, M, the maximum camber amount in percent
        * One digit, P, the x-coordinate of the point of maximum camber in TENS of percent
        * Two digits: TT, the maximum thickness of the airfoil in percent

    No NACA-4 profile can meaningfully have a zero for M or P if it
    does not have a zero for both.

    The 

    A NACA 5-digit profile [2], "LPSTT", also consists of four parts:

        * One digit, L: the design lift coefficient is 3L/20 (or 0.15L)
        * One digit, P, the x-coordinate of the point of maximum camber in FIVES of percent
        * One digit, S, indicating simple (0) or reflex (1) camber 
        * Two digits: TT, the maximum thickness of the airfoil in percent

    Canonical NACA-5 profiles *ALL* have L=2 and, accordingly, have a
    design lift coefficient at their optimum angle-of-attack of 0.3.

    Canonical NACA-5 profiles *ALL* have a P between 1 and 5 (inclusive).

    No NACA-5 profile can meaningfully have S not in {0,1} as it is a
    boolean flag.

    Canonical NACA-5 profiles *ALL* have TT="12".

    Canonical NACA 5-digit profiles match the regex: '^2[1-5][01]12$'

    Note that, in both cases, the thickness is the last two digits
    (TT) and the camber line is defined by the preceding digits: a
    "2-digit camber line" in the case of 4-digit profiles, and a
    "3-digit camber line" in the case of 5-digit profiles.

    The substring "MP" defines the camber line. It is "00" for
    symmetric 4-digit NACA profiles. It is called a "2-digit camber line".



    '''

    # Make sure the given NACA profile is convertible to an integer:
    try:
        int(profile)
    except ValueError:
        raise ValueError("Only 4 or 5 digit NACA profiles are accepted")

    # Choose the appropriate coefficients according to whether it's a
    # 4 or 5 digit profile and bail if it's neither:
    len_profile = len(profile)
    if len_profile==4:
        m = 0.01 * float(profile[0])         # Camber amount
        p = 0.10 * float(profile[1])         # Max. camber position
        t = 0.01 * float(profile[2:4])       # Max. thickness
    elif len_profile==5:
        dlc = 0.150 * float(profile[0])      # Design lift coefficient
        p   = 0.005 * float(profile[1:3])    # Max camber position
        t   = 0.010 * float(profile[3:5])    # Max. thickness.
    else:
        raise ValueError("Only 4 or 5 digit NACA profiles are accepted")

    a0 =  0.2969
    a1 = -0.1260
    a2 = -0.3516
    a3 =  0.2843
    
    if finite_TE:
        a4 = -0.1015
    else:
        a4 = -0.1036
        
    if half_cosine_spacing:
        beta = np.linspace(0.0, math.pi, n+1)
        x = 0.5*(1.0-np.cos(beta))
    else:
        x = np.linspace(0.0, 1.0, n+1)
    
    yt = 5.0*t*(a0*np.sqrt(x) + a1*x + a2*x**2 + a3*x**3 + a4*x**4)

    if p == 0:
        # No camber
        xu = x
        yu = yt
        xl = x
        yl = -1.0*yt
        xc = x
        yc = np.zeros(x.shape)
    else:
        xc1 = x[x<=p]
        xc2 = x[x>p]
        xc  = np.hstack((xc1,xc2))

        if len_profile==4:
            yc1 = (m/p**2) * (2*p*xc1 - xc1**2);
            yc2 = (m/(1.0-p)**2) * ((1.0-2.0*p) + 2.0*p*xc2 - xc2**2);
            yc  = np.hstack((yc1,yc2))
            
            dyc1_dx = (m/p**2) * (2*p-2*xc1)
            dyc2_dx = (m/(1.0-p)**2) * (2*p - 2*xc2)
        elif len_profile==5:
            # FIXME: this is nonsense
            P  = [0.05, 0.1, 0.15, 0.2, 0.25]
            R  = [0.0580, 0.1260, 0.2025, 0.2900, 0.3910]
            K  = (dlc/0.3)*[361.4, 51.64, 15.957, 6.643, 3.230]
            r  = si.InterpolatedUnivariateSpline(P,R)(p)
            k1 = si.InterpolatedUnivariateSpline(P,K)(p)

            yc1 = xc1**3 - 3.0*m*xc1**2 + m**2.0*(3.0-m)*xc1
            yc2 = m**3 * (1.0-xc2)
            yc  = (5.0*cld*k1/9.0)*np.hstack((yc1,yc2))

            dyc1_dx = (k1/6.0) * ( 3.0*xc1**2 - 6.0*m*xc1 + m**2*(3.0-m) )
            dyc2_dx = k1*m**3/6.0 * np.ones_like(xc2)
        else:
            # This is impossible because we checked the length of the
            # profile string before and would have bailed if it wasn't
            # 4 or 5
            raise RuntimeError("Impossible code reached")

        dyc_dx = np.hstack((dyc1_dx,dyc2_dx))
        theta  = np.arctan(dyc_dx)
            
        yt_cos_theta = yt * np.cos(theta)
        yt_sin_theta = yt * np.sin(theta)
            
        xu = x  - yt_sin_theta
        yu = yc + yt_cos_theta
            
        xl = x  + yt_sin_theta
        yl = yc - yt_cos_theta


    x = np.hstack((xu[::-1], xl[1:]))
    y = np.hstack((yu[::-1], yl[1:]))

    return x,y,xc,yc


if __name__ == "__main__":
    from pylab import *

    x,y,xc,yc = naca("23012", 56, False, True)
    plot(x,y)
