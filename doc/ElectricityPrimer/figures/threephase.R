## Common setup:
source('header.R')

## Conjure up a data frame for plotting:
phi=2*pi/3
df <- data.frame(t=t, A=Vp*cos(w*t), B=Vp*cos(w*t+phi), C=Vp*cos(w*t+2*phi))
dm <- melt(df, id.vars='t')

## Fixed aspect ratio:
far <- milli*T/Vp

## Palette:
pal <- ggplotColors(3)

p <- ggplot(dm, aes(x=milli*t, y=value, color=variable)) +
    geom_line() +
    coord_fixed(ratio=far) +
    scale_x_continuous(breaks=milli*t_breaks) +
    labs(x="Time (ms)", y="Potential Difference (V)")

win <- 8
ggsave("threephase.pdf", width=win, height=(10/3)*(win*far), units="in")

