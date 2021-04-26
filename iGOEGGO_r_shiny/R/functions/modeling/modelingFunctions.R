

#   _    __           _                     ______                 __  _                 
#  | |  / /___ ______(_)___  __  _______   / ____/_  ______  _____/ /_(_)___  ____  _____
#  | | / / __ `/ ___/ / __ \/ / / / ___/  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
#  | |/ / /_/ / /  / / /_/ / /_/ (__  )  / __/ / /_/ / / / / /__/ /_/ / /_/ / / / (__  ) 
#  |___/\__,_/_/  /_/\____/\__,_/____/  /_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/  
#                                                                                     

model_generate_linear <- function(data, col, mean_line = FALSE, xvar, yvar) {
  #print(xvar)
  #print(yvar)
  x <- data[, xvar]
  y <- data[, yvar]
  #print(y)
  #print(x)
  #fit <- lm(y ~ x)
  #dat <- data.frame(x, y)
  p <- ggplot(data, aes(x = x, y = y)) +
    geom_point() +
    stat_smooth(method = "lm") +
    theme_minimal()
  p <- ggplotly(p)
  #p
  return(p)
}

model_linear_coef <- function(data, xvar, yvar) {
  x <- data[, xvar]
  y <- data[, yvar]
  fit <- lm(y ~ x)
  p <- fit
  return(p)
}


model_generate_nonlinear <- function(data, col, mean_line = FALSE, xvar, yvar, grad) {
  #print(xvar)
  #print(yvar)
  x <- data[, xvar]
  y <- data[, yvar]
  #print(grad)
  #print(y)
  #print(x)
  #fit <- lm(y ~ x)
  #dat <- data.frame(x, y)
  p <- ggplot(data, aes(x = x, y = y)) +
    geom_point() +
    stat_smooth(method = "lm", formula = y ~ poly(x, grad, raw = TRUE)) +
    theme_minimal()
  p <- ggplotly(p)
  #p
  return(p)
}

model_nonlinear_coef <- function(data, xvar, yvar, grad) {
  x <- data[, xvar]
  y <- data[, yvar]
  fit <- lm(y ~ poly(x, grad, raw = TRUE))
  p <- fit
  return(p)
}

model_generate_exponential <- function(data, col, mean_line = FALSE, xvar, yvar) {
  x <- data[, xvar]
  y <- data[, yvar]
  # print("hier1")
  # f <- function(x,a,b) {a * exp(b * x)}
  # fm0 <- nls(log(y) ~ log(f(x, a, b)), data, start = c(a = 1, b = 1))
  # print(fm0)
  
  fm0 <- nls(log(y) ~ log(a*exp(b * x)), start = c(a = 1, b = 1))
  fm0
  p <- ggplot(data, aes(x = x, y = y)) +
    geom_point() +
    geom_smooth(method = "nls", 
                formula = y ~ a * exp(b * x), 
                se =  FALSE, # this is important 
                method.args = list(start = coef(fm0), na.action=na.exclude)) +
    theme_minimal()
  
  
  # p <- ggplot(data, aes(x = x, y = y)) +
    # geom_point() +
    #geom_smooth(method = "nls",
    #            formula = y ~ a*x^b,
    #            method.args = list(start = coef(fm0), control=nls.control(maxiter=100000)),
    #            se = FALSE) + 
    # stat_smooth(method = "lm", formula = y ~ exp(x)) +
    # geom_smooth(method = "nls", 
    #            formula = y ~ a * exp(b * x), 
    #            se =  FALSE, # this is important 
    #            method.args = list(start = list(a = 0.01, b = 0.01))) + 
    #theme_minimal()
  p <- ggplotly(p)
  # print("hier2")
  return(p)
}

#fm0 <- nls(log(y) ~ log(exp(b * x)), start = c(a = 1, b = 1))

model_exponential_coef <- function(data, xvar, yvar) {
  x <- data[, xvar]
  print(x)
  print(length(x))
  y <- data[, yvar]
  print(y)
  print(length(y))
  # f <- function(x,a,b) {a * exp(b * x)}
  # fm0 <- nls(log(y) ~ log(f(x, a, b)), data, start = c(a = 1, b = 1))
  # print(fm0)
  # fit <- nls(y ~ a*exp(b *x), start = coef(fm0))
  # fit <- lm(y ~ exp(x))
  
  fm0 <- nls(log(y) ~ log(a*exp(b * x)), start = c(a = 1, b = 1))
  # fit <- nls(y ~ a * exp(b * x), start = coef(fm0), na.action=na.exclude)
  fit <- nls(y ~ a * exp(b * x), start = coef(fm0))
  p <- fit
  return(p)
}

model_generate_log <- function(data, col, mean_line = FALSE, xvar, yvar) {
  x <- data[, xvar]
  y <- data[, yvar]
  
  fm0 <- nls(log(y) ~ log(a * log(x) + b), start = c(a = 0.1, b = 0.1))
  p <- ggplot(data, aes(x = x, y = y)) +
    geom_point() +
    geom_smooth(method = "nls",
                formula = y ~ a * log(x) + b,
                se =  FALSE, # this is important
                method.args = list(start = coef(fm0))) +
    theme_minimal()
  
  #p <- ggplot(data, aes(x = x, y = y)) +
  #  geom_point() +
    # stat_smooth(method = "lm", formula = y ~ log(x)) +
  #  geom_smooth(method = "nls", 
  #              formula = y ~ a * log(x) + b, 
  #              se =  FALSE, # this is important 
  #              method.args = list(start = list(a = 0.01, b = 0.01))) + 
  #  theme_minimal()
  p <- ggplotly(p)
  return(p)
}

model_log_coef <- function(data, xvar, yvar) {
  x <- data[, xvar]
  y <- data[, yvar]
  # fit <- lm(y ~ log(x))
  fm0 <- nls(log(y) ~ log(a * log(x) + b), start = c(a = 0.1, b = 0.1))
  fit <- nls(y ~ a * log(x) + b, start = coef(fm0))
  p <- fit
  return(p)
}






