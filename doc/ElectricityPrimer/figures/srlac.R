## Common setup:
source('header.R')

## Impedance:
Z  <- R+j*Xl

## Phasor current:
I <- v/Z

## Conjure up a data frame for plotting:
df   <- data.frame(t=t, v=Re(v))
df$i <- Re(I)
dm   <- melt(df, id.vars='t')

p <- ggplot(dm, aes(x=1000*t, y=value, color=variable)) +
    geom_line() +
    coord_fixed(ratio=(1000*T)/Vp) +
    scale_x_continuous(breaks=1000*t_breaks) +
    labs(x="Time (ms)", y="PD (V) or Current (A)")

ggsave("srlac.pdf", width=7, height=3, units="in")
