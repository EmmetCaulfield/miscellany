## Common setup:
source('header.R')

## For arrows:
library(grid)

## Impedance:
Z  <- R+j*Xl

## Phasor current:
I <- v/Z

## Apparent power:
S <- v*Conj(I)

## Compute phase angles of real and reactive power:
fV <- fft(v)
fI <- fft(I)
fS <- fft(S)

kV <- which.max(Mod(fV))
kI <- which.max(Mod(fI))
kS <- which.max(Mod(fS))

aV <- Arg(fV[kV])
pV <- complex(modulus=log10(Vp), argument=0)

aI <- Arg(fI[kI])-aV
pI <- complex(modulus=log10(max(Mod(I))), argument=aI)

aS <- Arg(fS[kS])
pS <- complex(modulus=log10(max(Mod(S))), argument=aS)

pZ <- complex(modulus=log10(Mod(Z)), argument=Arg(Z))

phasors <- c(pZ, pV, pI, pS)

dV <- aV*180/pi
dZ <- Arg(pZ)*180/pi
dI <- aI*180/pi
dS <- aS*180/pi

df <- data.frame(x=Re(phasors), y=Im(phasors), Phasor=c('Z', 'V', 'I', 'S'))

p <- ggplot(df, aes(x=0, y=0, xend=x, yend=y, color=Phasor)) +
    geom_segment(arrow=arrow(length=unit(0.5, 'cm')), size=2) +
    coord_equal(ratio=1) +
    labs(x="Re", y="Im")

win <- 8
ggsave('pwrphasor.pdf', width=win, height=(11/16)*win, units='in')
