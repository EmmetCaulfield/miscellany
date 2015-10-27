## Common setup:
source('header.R')

Z=j*Xl

## Conjure up a data frame for plotting:
df   <- data.frame(t=t, v=Re(v))
df$i <- Re(v/Z)
dm   <- melt(df, id.vars='t')

## Fixed aspect ratio:
far <- milli*T/Vp

p <- ggplot(dm, aes(x=milli*t, y=value, color=variable)) +
    geom_line() +
    coord_fixed(ratio=far) +
    scale_x_continuous(breaks=milli*t_breaks) +
    labs(x="Time (ms)", y="PD (V) or Current (A)")

ggsave("indac.pdf", width=7, height=(10/3)*(7*far), units="in")
