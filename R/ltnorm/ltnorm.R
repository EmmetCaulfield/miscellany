library(msm)    # For `rtnorm()`

### Reminder: dnorm => PDF => phi, pnorm => CDF => Phi

ltnorm.pdf <- function(mu=0,sigma=1,a) {
    alpha <- (a-mu)/sigma
    denom <- sigma*(1-pnorm(alpha));
    function(xx) {
        sapply(xx, function(x) {
                   xi <- (x-mu)/sigma
                   return( dnorm(xi)/denom )
               })
    }
}

ltnorm.cdf <- function(mu=0,sigma=1,a) {
    alpha <- (a-mu)/sigma
    denom <- (1-pnorm(alpha))
    subtr <- pnorm(alpha)/denom

    function(xx) {
        sapply(xx, function(x) {
                   xi <- (x-mu)/sigma
                   return( pnorm(xi)/denom-subtr )
               })
    }
}

ltnorm.lambda <- function(alpha) {
    return( dnorm(alpha)/(1-pnorm(alpha)) )
}

ltnorm.delta <- function(alpha) {
    return( tnorm.lambda(alpha)*(tnorm.lambda(alpha)-alpha) )
}

ltnorm.mean<-function(mu,sigma,a){
    alpha=(a-mu)/sigma
    return( mu+sigma*tnorm.lambda(alpha) )
}

ltnorm.var<-function(mu,sigma,a){
    alpha=(a-mu)/sigma
    return( sigma^2*(1-tnorm.delta(alpha)) )
}

### Testing
if( FALSE ) {
    n_samples <- 1e5
    mu <- 1.4
    sigma <- 1
    a <- 1
    t <- rtnorm(n=n_samples, mean=mu, sd=sigma, lower=a)
    paste(mean(t), var(t))
    paste(ltnorm.mean(mu, sigma, a), ltnorm.var(mu,sigma,a))
    
    h   <- hist(t, breaks=20)
    
    x <- seq(1,6, len=100)
    f <- ltnorm.pdf(mu,sigma,a)
    y <- f(x)
    scale <- max(h$counts/max(y))
    lines(x, scale*y, col="red")
    
    F <- ltnorm.cdf(mu,sigma,a);
    y <- F(x)
    scale <- max(h$counts)
    lines(x, scale*y, col="blue")
}
