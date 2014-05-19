# coding=utf-8
'''
Standard constants and functions for fluid calculations.

Constants are (units in square brackets):

p_0   = 101325         # [Pa] sea level standard atmospheric pressure
T_0   =    288.15      # [K]  sea level standard temperature
R     =      8.31447   # [J/mol·K] ideal (universal) gas constant 
S     =    110.5       # [K] Sutherland temperature
'''

import math

p_0    = 101325         # [Pa] sea level standard atmospheric pressure'''
# Measured global record high/low range: 87.0-108.5 kPa
T_0    =    288.15      # [K]  sea level standard temperature
R      =      8.31447   # [J/mol·K] ideal (universal) gas constant 
S      =    110.5       # [K] Sutherland temperature
c_empi =    331.45      # [m/s] median of measured speeds of sound in air
c_theo =    340.30      # [m/s] theoretical speed of sound in air
#c      =    343.0       # [m/s] speed of sound in air (alt. value)

def mu(mu0, T):
    '''
    Dynamic viscosity as a function of temperature (Sutherland's Law).

    '''
    return mu0 * (T/T_0)**1.5 * (T_0+S)/(T+S)


def Re(v, L, nu):
    '''
    Reynolds number at velocity v in air, for characteristic length L
    and kinematic viscosity nu.

    '''
    return v*L / nu


def Ma(v, c=c_theo):
    '''
    Mach number as a function of velocity

    '''
    return v/c


def Pr(nu, alpha):
    '''
    Prandtl number (FIXME)

    '''
    return nu/alpha
