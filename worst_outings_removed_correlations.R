outings_removed_1 <- read.csv('C:/Baseball/Worst Outings Removed Correlation/1_outings_removed.csv')
outings_removed_2 <- read.csv('C:/Baseball/Worst Outings Removed Correlation/2_outings_removed.csv')
outings_removed_3 <- read.csv('C:/Baseball/Worst Outings Removed Correlation/3_outings_removed.csv')
outings_removed_4 <- read.csv('C:/Baseball/Worst Outings Removed Correlation/4_outings_removed.csv')
outings_removed_5 <- read.csv('C:/Baseball/Worst Outings Removed Correlation/5_outings_removed.csv')


#correlation between realERA and nextERA
realTest <- cor.test(outings_removed_1$realERA, outings_removed_1$nextERA); print("real ERA p-value"); realTest$p.value; print("real ERA correlation estimate"); realTest$estimate

#correlation between 1 outing removed and nextERA
test_1 <- cor.test(outings_removed_1$adjustedERA, outings_removed_1$nextERA); print("1 outing removed p-value"); test_1$p.value; print("1 outing removed correlation estimate"); test_1$estimate; print("greater correlation than real ERA?"); test_1$estimate > realTest$estimate

#correlation between 2 outings removed and nextERA
test_2 <- cor.test(outings_removed_2$adjustedERA, outings_removed_2$nextERA); print("2 outings removed p-value"); test_2$p.value; print("2 outings removed correlation estimate"); test_2$estimate; print("greater correlation than real ERA?"); test_2$estimate > realTest$estimate

#correlation between 3 outings removed and nextER
test_3 <- cor.test(outings_removed_3$adjustedERA, outings_removed_3$nextERA); print("3 outings removed p-value"); test_3$p.value; print("3 outings removed correlation estimate"); test_3$estimate; print("greater correlation than real ERA?"); test_3$estimate > realTest$estimate

#correlation between 4 outings removed and nextERA
test_4 <- cor.test(outings_removed_4$adjustedERA, outings_removed_4$nextERA); print("4 outings removed p-value"); test_4$p.value; print("4 outings removed correlation estimate"); test_4$estimate; print("greater correlation than real ERA?"); test_4$estimate > realTest$estimate

#correlation between 5 outings removed and nextERA
test_5 <- cor.test(outings_removed_5$adjustedERA, outings_removed_5$nextERA); print("5 outings removed p-value"); test_5$p.value; print("5 outings removed correlation estimate"); test_5$estimate; print("greater correlation than real ERA?"); test_5$estimate > realTest$estimate

###The conclusion is that a pitchers real ERA is a better estimate of their
###next year's ERA than having removed any number of their worst outings.
###In fact, the more bad outings you remove, the worse the correlation is.