## Common setup:
source('header.R')

## Conjure up a data frame for plotting:
phi=2*pi/3
A <- Vp*cos(w*t)
B <- Vp*cos(w*t+phi)
C <- Vp*cos(w*t+2*phi)
D <- abs(A)+abs(B)+abs(C)

df <- data.frame(t=t, A=A, B=B, C=C, DC=D)
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
ggsave("nicerect.pdf", width=win, height=(10/2)*(win*far), units="in")

