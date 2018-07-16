#install.packages('treemap')
library(treemap)
library(ggplot2)
library(GGally)
library(lattice)
library(plyr)


setwd("C:/Tommy/Method DS")
data <- read.csv("Table1.csv")

###############  CREATE AGGREGATE DATASET ##############################################################

Aggregate <- data[which(data$ORIGIN == 0),]
Aggregate <- Aggregate[which(Aggregate$RACE == 0),]
Aggregate <- Aggregate[which(Aggregate$SEX == 0),]

Aggregate <- Aggregate[c(4,5,6,16,26,36,46,56,66,76,86,96,106)]

colnames(Aggregate) <- paste("Aggregate", colnames(Aggregate), sep = "_")

Aggregate <- rename(Aggregate, c("Aggregate_YEAR"="YEAR"))

##########################################################################################################


###############  CREATE NON HISPANIC DATASET ##############################################################

NonHispanic <- data[which(data$ORIGIN == 1),]
NonHispanic <- NonHispanic[which(NonHispanic$RACE == 0),]
NonHispanic <- NonHispanic[which(NonHispanic$SEX == 0),]

NonHispanic <- NonHispanic[c(4,5,6,16,26,36,46,56,66,76,86,96,106)]

colnames(NonHispanic) <- paste("NonHispanic", colnames(NonHispanic), sep = "_")

NonHispanic <- rename(NonHispanic, c("NonHispanic_YEAR"="YEAR"))

##########################################################################################################


##########################  CREATE HISPANIC DATASET ##############################################################

Hispanic <- data[which(data$ORIGIN == 2),]
Hispanic <- Hispanic[which(Hispanic$RACE == 0),]
Hispanic <- Hispanic[which(Hispanic$SEX == 0),]

Hispanic <- Hispanic[c(4,5,6,16,26,36,46,56,66,76,86,96,106)]

colnames(Hispanic) <- paste("Hispanic", colnames(Hispanic), sep = "_")

Hispanic <- rename(Hispanic, c("Hispanic_YEAR"="YEAR"))

##########################################################################################################

##########################  CREATE MALE DATASET ##############################################################

Male <- data[which(data$ORIGIN == 0),]
Male <- Male[which(Male$RACE == 0),]
Male <- Male[which(Male$SEX == 1),]

Male <- Male[c(4,5,6,16,26,36,46,56,66,76,86,96,106)]

colnames(Male) <- paste("Male", colnames(Male), sep = "_")

Male <- rename(Male, c("Male_YEAR"="YEAR"))

##########################################################################################################

##########################  CREATE FEMALE DATASET ##############################################################

Female <- data[which(data$ORIGIN == 0),]
Female <- Female[which(Female$RACE == 0),]
Female <- Female[which(Female$SEX == 2),]

Female <- Female[c(4,5,6,16,26,36,46,56,66,76,86,96,106)]

colnames(Female) <- paste("Female", colnames(Female), sep = "_")

Female <- rename(Female, c("Female_YEAR"="YEAR"))

##########################################################################################################



###########################################   MERGE   ###############################################################

finaldataset <- merge(Aggregate,Hispanic,by = "YEAR")
finaldataset <- merge(finaldataset,NonHispanic,by = "YEAR")
finaldataset <- merge(finaldataset,Male,by = "YEAR")
finaldataset <- merge(finaldataset,Female,by = "YEAR")

####################################################################################################################




###########################################   CREATE SHINY DASHBOARD   ###############################################################




ui <- fluidPage(
  
  titlePanel(title=div("Projected Population 2016 through 2060")),

  
  
  
  plotOutput("plot"),
  plotOutput("plot2")
  

)

server <- function(input,output) {
  
  
  
  output$plot <- renderPlot({
    
    plot(finaldataset$Male_POP_0,type = "l",col = "red", xlab = "Year", ylab = "Total Population", 
         main = "Birthrate over Time",ylim = c(1900000,2300000))
    
    lines(finaldataset$Female_POP_0, type = "l", col = "blue")
    
    legend("bottomright", legend=c("Male - Total", "Female Total"),
           col=c("red", "blue"), lty = 1, cex=0.8)
    
    })
  
  output$plot2 <- renderPlot({
    
    plot(finaldataset$Male_POP_60,type = "l",col = "red", xlab = "Year", ylab = "Total Population", 
         main = "Age 60 Population Over Time",ylim = c(1700000,2500000))
    
    lines(finaldataset$Female_POP_60, type = "l", col = "blue")

    
    legend("bottomright", legend=c("Male", "Female"),
           col=c("red", "blue"), lty = 1, cex=0.8)
    
    
  })
  
}


shinyApp(ui = ui,server = server)