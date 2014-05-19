# coding=utf-8
'''
Standard constants and functions for atmospheric calculations.

Functions are provided for "important" properties, usually as a
function of height. Functions are named for the usual letter used to
represent that property. Greek letters are spelled out.

Where such makes any sense, functions that take height as an argument
default to zero, or sea-level, but "go through the motions" performing
any necessary calculations; in principle, they should return the same
value as the given associated constant, if any.

The constants and formulae are fairly standard and (arguably) valid in
the troposphere, although some may not be valid in the surface
boundary layer. YMMV.

Constants are (units in square brackets):

p_0   = 101325         # [Pa] sea level standard atmospheric pressure
T_0   =    288.15      # [K]  sea level standard temperature
g     =      9.80665   # [m/s^2] earth-surface gravitational acceleration
L     =      0.0065    # [K/m] temperature lapse rate
M_a   =      0.0289644 # [kg/mol] molar mass of dry air, kg/mol 
mu_0  =      1.716e-5  # [Pa·s=kg/m·s] sea level dynamic viscosity
nu_0  =      1.460e-5  # [m^2/s] sea level kinematic viscosity
gamma =      1.4       # [1] sea-level static on a standard day
'''

import math
import fluid

p_0   = 101325         # [Pa] sea level standard atmospheric pressure'''
# Measured global record high/low range: 87.0-108.5 kPa
T_0   =    288.15      # [K]  sea level standard temperature
g     =      9.80665   # [m/s^2] earth-surface gravitational acceleration
L     =      0.0065    # [K/m] temperature lapse rate
M_a   =      0.0289644 # [kg/mol] molar mass of dry air, kg/mol 
mu_0  =      1.716e-5  # [Pa·s=kg/m·s] sea level dynamic viscosity
nu_0  =      1.460e-5  # [m^2/s] sea level kinematic viscosity
gamma =      1.4       # [1] sea-level static on a standard day

# Coefficient of exponent in pressure equation:
_ph_exp = g*M_a/(fluid.R*L);


def T(h=0.0):
    '''
    Air temperature as a function of height, based on constant lapse
    rate.

    '''
    return T_0 - L*h


def p(h=0.0):
    '''
    Air pressure as a function of height.
    
    '''
    return p_0 * (T(h)/T_0)**_ph_exp


def rho(h=0.0):
    '''
    Air density as a function of height.

    '''
    return p(h) * M_a / (fluid.R*T(h))


def mu(h=0.0):
    '''
    Dynamic viscosity as a function of height, based on temperature lapse
    rate, then Sutherland's law.
    '''

    return fluid.mu( mu_0, T(h) )


def nu(h=0.0):
    '''
    Kinematic viscosity as a function of height.

    '''
    return mu(h) / rho(h)


def Re(v, c=1.0, h=0.0):
    '''
    Chord reynolds number at velocity v in air, for chord length 'c'
    (1m if not given) and altitude 'h' (sea-level if not given).

    '''
    return fluid.Re(v, c, nu(h))



def shear(h, z0, h0, v0):
    '''
    Log-law wind speed shear due to height.

    '''
    return v0 * math.log(h/z0) / math.log(h0/z0)


def c(h=0.0):
    '''
    Speed-of-sound in air as a function of height.

    '''

    return math.sqrt( gamma*p(h) / rho(h) )


def Ma(v, h=0.0):
    '''
    Mach number as a function of velocity and (optionally) height.

    Height defaults to zero (sea-level)

    '''
    return fluid.Ma(v, c(h))
