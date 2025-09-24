dat <- read.csv("C:/Baseball/Manger Ejection Wins/manager_ejections_wins.csv")

winsLoss <- dat$win_loss

total <- length(winsLoss)
wins <- sum(winsLoss == 'w')

test <- prop.test(wins, total, .5, correct = F)
pvalue <- test$p.value; pvalue

test$estimate

###It is statistically significant that teams win less often when their manager
###is ejected from the game. It is estimated that teams whose managers are 
###ejected win about 35% of the time.


