# Set working directory to source file location
setwd("/Users/manxinlan/Documents/lmx/00Cornell/ling research/force_choice")

### Load packages
library("dplyr")
library("ggplot2")

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

native_speaker <- subset(results, results$Label=="native_speaker" & results$PennElementName=="keypress")

experimental <- subset(results, results$Label=="experimental_trial" & results$PennElementName=="selection")
experimental <- select(experimental,"MD5.hash.of.participant.s.IP.address","Value","time","itemNo.","Comments")



long <- experimental %>% filter(time=="century"|time=="year"|time=="month"|time=="week")
short <- experimental %>% filter(time=="day"|time=="hour"|time=="minute"|time=="second")

choice=c("hor","ver")
count <-c(nrow(long%>%filter(Value=="hor")),nrow(long%>%filter(Value=="ver")))

long_sum <- tibble(choice,count)
long_sum
long_vis <- ggplot(long, aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Long", x = "Choices", y = "Frequency")
long_vis

short_vis <- ggplot(short, aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "Short", x = "Choices", y = "Frequency")
short_vis

day_vis <- ggplot(short%>%filter(time=="day"), aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "day", x = "Choices", y = "Frequency")
day_vis

hour_vis <- ggplot(short%>%filter(time=="hour"), aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "hour", x = "Choices", y = "Frequency")
hour_vis

minute_vis <- ggplot(short%>%filter(time=="minute"), aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "minute", x = "Choices", y = "Frequency")
minute_vis

second_vis <- ggplot(short%>%filter(time=="second"), aes(x = Value)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(title = "second", x = "Choices", y = "Frequency")
second_vis
experimental2 <- experimental
experimental2$time <- factor(experimental2$time, levels = c("second", "minute", "hour", "day","week","month","year","century"))

bar_plot <- ggplot(experimental2, aes(x = time, fill = Value)) +
  geom_bar(stat = "count", position = "dodge", color = "grey") +
  labs(title = "Frequency of Choice by Time Unit", x = "Time", y = "Frequency") +
  scale_fill_manual(values = c("hor" = "skyblue", "ver" = "salmon")) +
  theme_minimal()

print(bar_plot)


experimental <- experimental%>%mutate(is.hor=ifelse(Value=="hor",1,0))
exp_sum <- experimental%>%group_by(time)%>%summarise(prop_of_hor = mean(is.hor))%>%
  mutate(time = factor(time, levels = c("second", "minute", "hour", "day", "week", "month", "year", "century")))%>%
  arrange(time)

ggplot(exp_sum, aes(x=time,y=prop_of_hor))+
  geom_bar(stat = "identity", fill = "skyblue")+geom_hline(yintercept = 0.5, color="blue")+
  labs(title="Proportion of Horizontal by Time", x="Time", y="Proportion of Horizontal")


experimental <- experimental%>%mutate(time_category=ifelse((time=="second"|time=="minute"|time=="hour"|time=="day"),"short","long"))
exp_cate_sum <- experimental%>%group_by(time_category)%>%
  summarize(prop_of_hor = mean(is.hor))
ggplot(exp_cate_sum, aes(x=time_category,y=prop_of_hor))+
  geom_bar(stat = "identity", fill = "skyblue")+geom_hline(yintercept = 0.5, color="blue")+
  labs(title="Proportion of Horizontal by Short/Long Time", x="Time", y="Proportion of Horizontal")


model <- lmer(experimental$is.hor ~ experimental$time_category + (1+experimental$time_category|experimental$MD5.hash.of.participant.s.IP.address)+(1|experimental$itemNo.))
#model1 <- lmer(experimental$is.hor ~ experimental$time_category + (1|experimental$MD5.hash.of.participant.s.IP.address)+(1+experimental$time_category|experimental$item))

exp_short <- experimental %>% filter(time_category == "short")

exp_short$time <- as.factor(exp_short$time)
contrasts(exp_short$time) <- c(-1/2,-1/4, 1/4, 1/2)


model_short <-
  lmer(is.hor ~ time + (1 + time |MD5.hash.of.participant.s.IP.address) + (1 |itemNo.),
       data = exp_short)
summary(model_short)
# intercept: day; time1: hour; time2: minute; time3: second


exp_long <- experimental %>% filter(time_category=="long")

exp_long$time <- as.factor(exp_long$time)
contrasts(exp_long$time) <- c(-1/2, -1/4, 1/4, 1/2)
model_long <- lmer(is.hor ~ time + (1+time|MD5.hash.of.participant.s.IP.address)+(1|itemNo.),data = exp_long)

summary(model_long)



grand_mean <- mean(experimental$is.hor)




experimental3 <- experimental

experimental3$time <- as.factor(experimental3$time)

contrasts(experimental3$time)<-contr.sum(8)


model_all_alt <- lmer(is.hor ~ time + (1+time|MD5.hash.of.participant.s.IP.address)+(1|itemNo.),data = experimental3)

summary(model_all_alt)

# time1: century, time2: day, time3: hour, time4: minute, time5: month, time6: second, time7: week
#time8: year

#getting the last time (year)

experimental5 <- experimental
experimental5[experimental5=="year"]<-"ayear"
experimental5
experimental5$time <- as.factor(experimental5$time)

contrasts(experimental5$time)<-contr.sum(8)


model_last <- lmer(is.hor ~ time + (1+time|MD5.hash.of.participant.s.IP.address)+(1|itemNo.),data = experimental5)

summary(model_last)



md5 <-c()
n <- 0

for (i in seq(length(experimental$MD5.hash.of.participant.s.IP.address))) {
  
  if (experimental$MD5.hash.of.participant.s.IP.address[i] %in% md5){
    experimental$sid[i]=n
  }
  else{
    md5 <- c(md5,experimental$MD5.hash.of.participant.s.IP.address[i])
    n = n+1
    experimental$sid[i]=n
  }
  
}
experimental <- experimental%>%select(-MD5.hash.of.participant.s.IP.address)


# write result csv file
write.csv(experimental, file = "/Users/manxinlan/Documents/lmx/00Cornell/ling research/force_choice/result_file.csv", row.names = FALSE)

