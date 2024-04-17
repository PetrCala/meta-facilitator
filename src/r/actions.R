action1 <- function(name) {
    print(paste("Hello", name))
}

action2 <- function(x, y) {
    tryCatch(
        {
            x <- as.numeric(x)
            y <- as.numeric(y)
        },
        error = function(e) {
            stop("Please provide numeric values for x and y")
        }
    )
    print(paste("Sum is", x + y))
}

action3 <- function(data) {
    print(mean(data))
}

ACTIONS <- list(
    greet = action1,
    add = action2,
    average = action3
)
