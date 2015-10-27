## Common setup:
source('header.R')

## Conjure up a data frame for plotting:
df      <- data.frame(t=t, v=Re(v))

## Label:
lblVm <- paste('V[RMS]==', Vm)
lblVp <- paste('V[p]%~~%', sprintf('%.1f',Vp))

## Baseline shift:
bls  <- -Vm/8

## Label position in time (x axis)
lblT <- milli*(max(df$t)-T/2)

## Fixed aspect ratio:
far <- milli*T/Vp

## Palette:
pal <- ggplotColors(2)

p <- ggplot(df, aes(x=milli*t, y=v)) +
    geom_line() +
    geom_hline(yintercept=Vm, color=pal[1], alpha=0.5) +
    annotate('text', lblT, Vm+bls, label=lblVm, parse=TRUE, size=3 ) +
    geom_hline(yintercept=Vp, color=pal[2], alpha=0.5) +
    annotate('text', lblT, Vp+bls, label=lblVp, parse=TRUE, size=3 ) +
    coord_fixed(ratio=far) +
    scale_x_continuous(breaks=milli*t_breaks) +
    labs(x="Time (ms)", y="Potential Difference (V)")

win <- 8
ggsave("ac.pdf", width=win, height=(10/3)*(win*far), units="in")

