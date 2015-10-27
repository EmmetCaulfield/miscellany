## Clear workspace:
rm(list=ls())

# Import 'ggplot2' library:
library(ggplot2)
library(scales)
library(reshape2)

ggplotColors <- function(n) {
    hues = seq(15, 375, length=n+1)
    hcl(h=hues, l=65, c=100)[1:n]
}

## Frequency (Hz):
f <- 60

## Phase shift (rad):
phi <- 0

## RMS voltage:
Vm <- 120

## Resistance (ohms):
R <- 2

## Inductance (henries):
L <- 4e-3

## Capacitance (farads):
C <- 1e-6


## Number of periods:
n <- 6

## Point to draw per period:
p <- 100


## Complex number:
j <- complex(real=0, imag=1)

## Multiplicative factor to express in milli-units:
milli <- 1000
micro <- 1000000


## Peak voltage:
Vp <- Vm*sqrt(2)

## Frequency (rad/s):
w <- 2*pi*f

## Inductive reactance:
Xl <- w*L

## Capacitive reactance:
Xc <- 1/(w*C)

## Inductive impedance:
Zl  <- R+j*Xl

## Capacitive impedance:
Zc <- R-j*Xc

## Period:
T <- 1/f

## Time points:
t <- seq(0, n*T, T/p)

## Phasor voltage, adjusted so t=0 corresponds to a positive-going
## zero-crossing:
v <- Vp*exp(j*(w*t+phi))

## x breaks at period:
t_breaks <- seq(0, n*T, T)
