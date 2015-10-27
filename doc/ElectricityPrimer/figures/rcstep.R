## Common setup:
source('header.R')

## Time constant:
tau <- R*C

## Time points:
t <- seq(0, n*tau, tau/p)


## Conjure up a data frame for plotting:
df    <- data.frame(t=t, Vr=Vdc*exp(-t/tau))
df$Vc <- Vdc-df$Vr
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

