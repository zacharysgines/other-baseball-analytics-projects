dat <- read.csv('C:/Baseball/Manager Winning WAR Correlation/manager_winning_war_correlation.csv')

win <- dat$winningpercentage
war <- dat$WAR


test <- cor.test(win, war); print("p-value"); test$p.value; print("cor estimate"); test$estimate
plot(win, war)

###There is no evidence that a managers success as a player 


#Removing managers who had under 5 career war
datOver5War <- dat[dat$WAR > 5, ]

winOver5War <- datOver5War$winningpercentage
warOver5War <- datOver5War$WAR

test <- cor.test(winOver5War, warOver5War); print("p-value"); test$p.value; print("cor estimate"); test$estimate
plot(winOver5War, warOver5War)

###Still, by removing managers who amassed insignificnat WAR totals, 
###there is no correlation between a managers success as a player and their
###success as a manager.
