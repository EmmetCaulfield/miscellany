## Common setup:
source('header.R')

## Resistance:
R <- 2

## Capacitance:
C <- 1e-6

## Time constant:
tau <- R*C

## DC supply voltage:
Vcc <- 9

## Number of periods:
n <- 6

## Point to draw per period:
p <- 100

## Time points:
t <- seq(0, n*tau, tau/p)


## Conjure up a data frame for plotting:
df    <- data.frame(t=t, Vr=Vcc*exp(-t/tau))
df$Vc <- Vcc-df$Vr
df$i  <- df$Vr/R
dm    <- melt(df, id.vars='t')

pal <- rev( ggplotColors(3) )

p <- ggplot(dm, aes(x=1000000*t, y=value, color=variable)) +
    geom_line() +
    labs(x=expression("Time (" * mu * "s)"), y="PD (V) or Current (A)") +
    scale_y_continuous(breaks=seq(0,10,1)) +
    scale_x_continuous(breaks=1000000*seq(0,n*tau,tau)) +
    scale_color_manual(labels=c(expression(v[R](t)),
                                  expression(v[C](t)),
                                  expression(i(t))),
                         values=pal
                         )

ggsave("rcstep.pdf", width=7, height=4, units="in")

