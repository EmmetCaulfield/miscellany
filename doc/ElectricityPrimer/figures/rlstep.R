## Common setup:
source('header.R')

## Resistance:
R <- 2

## Capacitance:
L <- 5e-3

## Time constant:
tau <- L/R

## DC supply voltage:
Vcc <- 9

## Number of periods:
n <- 6

## Point to draw per period:
p <- 100

## Time points:
t <- seq(0, n*tau, tau/p)


## Conjure up a data frame for plotting:
df    <- data.frame(t=t, Vr=Vcc*(1-exp(-t/tau)))
df$Vl <- Vcc-df$Vr
df$i  <- df$Vr/R
dm    <- melt(df, id.vars='t')

pal <- rev( ggplotColors(3) )

p <- ggplot(dm, aes(x=1000*t, y=value, color=variable)) +
    geom_line() +
    labs(x="Time (ms)", y="PD (V) or Current (A)") +
    scale_y_continuous(breaks=seq(0,10,1)) +
    scale_x_continuous(breaks=1000*seq(0,n*tau,tau)) +
    scale_color_manual(labels=c(expression(v[R](t)),
                                expression(v[L](t)),
                                expression(i(t))),
                       values=pal)

ggsave("rlstep.pdf", width=7, height=4, units="in")
