source('header.R')

library(grid)

geom.arc <- function(center = c(0,0), radius=1, start=0, end=pi/2, npoints = 100){
    span <- (end-start)*50
    tt <- seq(start, end, length.out=span)
    xx <- center[1] + radius * cos(tt)
    yy <- center[2] + radius * sin(tt)
    return(data.frame(x = xx, y = yy))
}


x <- c(1,   6, 7  )
y <- c(3.5, 2, 5.5)

df <- data.frame(x=x, y=y, Phasor=c('A', 'B', 'v'))

arc1 <- geom.arc(c(0,0), 3, 0, atan(y[1]/x[1]))
arc2 <- geom.arc(c(0,0), 1.5, 0, atan(y[2]/x[2]))
arc3 <- geom.arc(c(0,0), 2.25, 0, atan(y[3]/x[3]))


pal <- ggplotColors(3)

p <- ggplot(df, aes(x=0, y=0, xend=x, yend=y, color=Phasor)) +
    geom_segment(aes(x=x[2], y=y[2], xend=x[3], yend=y[3]),
                 color=pal[1], arrow=arrow(length=unit(0.5,'cm')),
                 linetype='dashed', size=1) +
    geom_segment(aes(x=x[1], y=y[1], xend=x[3], yend=y[3]),
                 color=pal[2], arrow=arrow(length=unit(0.5,'cm')),
                 linetype='dashed', size=1) +
    geom_segment(arrow=arrow(length=unit(0.5, 'cm')), size=2) +
    geom_path(data=arc1, aes(x, y), inherit.aes=FALSE, arrow=arrow(length=unit(0.3,'cm')), color='gray55') +
    geom_path(data=arc2, aes(x, y), inherit.aes=FALSE, arrow=arrow(length=unit(0.3,'cm')), color='gray55') +
    geom_path(data=arc3, aes(x, y), inherit.aes=FALSE, arrow=arrow(length=unit(0.3,'cm')), color='gray55') +
    geom_text(aes( 0.95,  2.60, label='phi',   color='A'), parse=TRUE, show_guide=FALSE) +
    geom_text(aes( 1.30, 0.20, label='theta',  color='B'), parse=TRUE, show_guide=FALSE) +
    geom_text(aes( 1.75, 1.10, label='psi',   color='v'), parse=TRUE, show_guide=FALSE) +
    coord_equal(ratio=1) +
    labs(x='Re', y='Im')

win <- 8
ggsave('phasor.pdf', width=win, height=(11/16)*win) ##, width=win, height=win, units='in')

##polar <- structure(list(degree = c(120L, 30L, -120L, 60L, 150L, -90L, -60L, 0L),
##                        value = c(0.5, 0.2, 0.2, 0.5, 0.4, 0.14, 0.5, 0.6)),
##                   .Names = c("degree", "value"),
##                   class = "data.frame",
##                   row.names = c(NA, 0L))

##p <- ggplot(polar, aes(x=degree, y=value)) +
##    coord_polar() +
##    geom_segment(aes(y=0, xend=degree, yend=value), arrow=arrow(length=unit(0.3, 'cm')))

