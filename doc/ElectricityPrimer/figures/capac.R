## Common setup:
source('header.R')

Z=-j*Xc

## Conjure up a data frame for plotting:
df   <- data.frame(t=t, v=Re(v))
df$i <- milli*Re(v/Z)
dm   <- melt(df, id.vars='t')

## Fixed aspect ratio:
far <- milli*T/Vp

p <- ggplot(dm, aes(x=milli*t, y=value, color=variable)) +
    geom_line() +
    coord_fixed(ratio=far) +
    scale_x_continuous(breaks=milli*t_breaks) +
    labs(x="Time (ms)", y="PD (V) or Current (mA)")

ggsave("capac.pdf", width=7, height=(10/3)*(7*far), units="in")
