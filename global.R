data <- readRDS("ohiocp.rds")
data$Region <- as.factor(data$Region)