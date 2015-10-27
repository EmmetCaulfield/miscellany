## Common setup:
source('header.R')

## For arrows:
library(grid)

## Impedance:
Z  <- R+j*Xl/2

## Phasor current:
I <- v/Z

## Apparent power:
S <- v*Conj(I)

## Compute phase angles of real and reactive power:
fV <- fft(v)
fS <- fft(S)

kV <- which.max(Mod(fV))
kS <- which.max(Mod(fS))

aV <- Arg(fV[kV])
aS <- Arg(fS[kS])-aV
pS <- complex(modulus=max(Mod(S)), argument=aS)

phasors <- c(pS, Re(pS), j*Im(pS))

df <- data.frame(x=Re(phasors), y=Im(phasors), Phasor=c('S', 'P=Re(S)', 'Q=Im(S)'))

p <- ggplot(df, aes(x=0, y=0, xend=x, yend=y, color=Phasor)) +
    geom_segment(arrow=arrow(length=unit(0.5, 'cm')), size=2) +
    coord_equal(ratio=1) +
    labs(x="Re", y="Im")

win <- 8
ggsave('acpower.pdf', width=win, height=(7/16)*win, units='in')
