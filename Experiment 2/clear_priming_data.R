# Set working directory to source file location
setwd("/Users/manxinlan/Documents/lmx/00Cornell/ling research/priming")

### Load packages
library("dplyr")
library("ggplot2")
library("lme4")

# User-defined function to read in PCIbex Farm results files
read.pcibex <- function(filepath, auto.colnames=TRUE, fun.col=function(col,cols){cols[cols==col]<-paste(col,"Ibex",sep=".");return(cols)}) {
  n.cols <- max(count.fields(filepath,sep=",",quote=NULL),na.rm=TRUE)
  if (auto.colnames){
    cols <- c()
    con <- file(filepath, "r")
    while ( TRUE ) {
      line <- readLines(con, n = 1, warn=FALSE)
      if ( length(line) == 0) {
        break
      }
      m <- regmatches(line,regexec("^# (\\d+)\\. (.+)\\.$",line))[[1]]
      if (length(m) == 3) {
        index <- as.numeric(m[2])
        value <- m[3]
        if (is.function(fun.col)){
          cols <- fun.col(value,cols)
        }
        cols[index] <- value
        if (index == n.cols){
          break
        }
      }
    }
    close(con)
    return(read.csv(filepath, comment.char="#", header=FALSE, col.names=cols))
  }
  else{
    return(read.csv(filepath, comment.char="#", header=FALSE, col.names=seq(1:n.cols)))
  }
}

# Read in results file
results <- read.pcibex("results.csv")


results[results=="moth"]<- "month" #delete this

clear_data <- results %>% filter(itemType=="experimental") %>%
  select(PennElementName,MD5.hash.of.participant.s.IP.address,Value, EventTime,space,time,Comments,itemNo)

RT<- clear_data$EventTime[clear_data$PennElementName=="target_response"]-clear_data$EventTime[clear_data$PennElementName=="keypress2"&clear_data$Comments=="Wait validation"]
clear_data<- clear_data %>% filter(PennElementName=="target_response") %>% select(-Comments, -EventTime, -PennElementName)
clear_data$RT <- RT


row <- which.max(clear_data$RT)
num<-max(clear_data$RT)
row_605 <- clear_data %>% slice(row)

sum_data<-summary(clear_data$RT)
stdev <- sd(clear_data$RT)
bound=sum_data["3rd Qu."]+1.5*(sum_data["3rd Qu."]-sum_data["1st Qu."])
bound_3sd <- sum_data["Median"]+3*stdev

clear_data <- clear_data %>% filter(RT < bound_3sd)

md5 <-c()
n <- 0

for (i in seq(length(clear_data$MD5.hash.of.participant.s.IP.address))) {
  
  if (clear_data$MD5.hash.of.participant.s.IP.address[i] %in% md5){
    clear_data$sid[i]=n
  }
  else{
    md5 <- c(md5,clear_data$MD5.hash.of.participant.s.IP.address[i])
    n = n+1
    clear_data$sid[i]=n
  }
  
}
clear_data <- clear_data%>%select(-MD5.hash.of.participant.s.IP.address)

# write result csv file
write.csv(clear_data, file = "/Users/manxinlan/Documents/lmx/00Cornell/ling research/priming/result_file.csv", row.names = FALSE)


data_summary <- clear_data %>% 
  select(space, time, RT)%>%
  group_by(space,time)%>% 
  summarise(Mean=mean(RT), .groups = "keep") %>%
  tidyr::spread(space, Mean)



data_long <- tidyr::gather(data_summary, key = "Prime", value = "value", -time)
data_long$time <- factor(data_long$time, levels = c("second", "minute", "hour", "day","week","month","year","century"))

# Create a bar plot
plot1<-ggplot(data_long, aes(x = time, y = value, fill = Prime)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  labs(title = "Reaction Time by Prime Type and Target Time Unit",
       x = "Time Unit",
       y = "RT") +
  scale_fill_manual(values = c("hor" = "skyblue", "ver" = "salmon")) +
  theme_minimal()
plot1



# short(hor-ver) < long(hor-ver) paired t test

data_exclude <- clear_data%>%filter(time!="second", time!="minute", time!="year")
data_exclude <- data_exclude%>% mutate(short_long = ifelse(time=="hour"|time=="day","short","long"))

data_exclude_summary <- data_exclude %>% 
  group_by(short_long,sid,space) %>%
  summarise(meanRT = mean(RT)) %>%
  tidyr::spread(space, meanRT) %>%
  summarise(hor_minus_ver = hor-ver)%>%
  tidyr::spread(short_long, hor_minus_ver)
paired_test <- t.test(data_exclude_summary$short, data_exclude_summary$long, paired=T, alternative = "less")
paired_test



# Create a bar plot for time units without minute, second, and year
data_exclude_summary <- data_exclude %>% 
  select(space, time, RT)%>%
  group_by(space,time)%>% 
  summarise(Mean=mean(RT), .groups = "keep") %>%
  tidyr::spread(space, Mean)


data_exclude_long <- tidyr::gather(data_exclude_summary, key = "Prime", value = "value", -time)
data_exclude_long$time <- factor(data_exclude_long$time, levels = c("hour", "day","week","month","century"))

plot2<-ggplot(data_exclude_long, aes(x = time, y = value, fill = Prime)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  labs(title = "Reaction Time by Prime Type and Target Time Unit without minute, second, year",
       x = "Time Unit",
       y = "RT") +
  scale_fill_manual(values = c("hor" = "skyblue", "ver" = "salmon")) +
  theme_minimal()
plot2






