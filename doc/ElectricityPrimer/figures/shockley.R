## Common setup:
source('header.R')

## Voltage range:
V <- seq(-1, 1, 0.01)

## Reverse saturation current:
Is <- 20e-9

## Non-ideality factor:
n <- 1

# Temperature (K):
T <- 300

# Boltzmann's constant (J/K):
k <- 1.3806488e-23

# Elementary charge (C):
q <- 1.6021766208e-19

## Thermal voltage:
Vt <- k*T/q


## Conjure up a data frame for plotting:
df    <- data.frame(V=V, I=Is*exp(V/(n*Vt)))

p <- ggplot(df, aes(x=V, y=I)) +
    geom_line() +
    labs(x=expression("Diode Voltage (V)"), y="Diode Current (A)") +

ggsave("shockley.pdf", width=7, height=7, units="in")
