library(datasets)
# Use AirPassengers dataset from the R datasets
data(AirPassengers)

f <- decompose(AirPassengers)
fit <- arima(AirPassengers, order=c(1,0,0), list(order=c(2,1,0), period=12))
fore <- predict(fit, n.ahead=24)
# error bounds at 95% confidence level
upper <- fore$pred + 2 * fore$se
lower <- fore$pred - 2 * fore$se
col1 <- c(1,2,4,4)
lty1 <- c(1,1,2,2)
col2  <- c(1,2,4)
lty2 <- c(1,1,2)
ll <- c("Actual", "Forecast", "Error Bounds (95% Confidence)")
mar1 <- c(4, 4, 4, 4)
mns <- c("Jan", "Feb", "Mar", "Apr",  "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

df <- matrix(0, 12, 12)
k <- 1
for (i in 1:12){
  for(j in 1:12){
    df[i,j] <- AirPassengers[k]
    k <- k + 1
  }
}
colnames(df) <- mns
df <- cbind(seq(1949, 1960, 1), df)
colnames(df) <- c("year", colnames(df)[-1])


shinyServer(
  function(input, output) {
    c <- reactive({
      if (input$plottype == "histogram"){
        par(bg="gray95")
        hist(AirPassengers, breaks = input$breakCount, cex = 0.7)
      }
      else if(input$plottype == "boxplot"){
        par(bg="gray95")
        boxplot(df[,2:13], main = "Boxplot of AirPassangers")
      }
      else if(input$plottype == "trend"){
        par(bg="gray95")
        plot(f$trend, main = "Moving Average", ylab = "average per year")
      }
      else if (input$plottype == "seasonal"){
        par(bg="gray95")
        plot(f$figure, type="b", xaxt="n", xlab="", ylab="seasonal fluctuations",
             main = "Seasonal Changes")
        monthNames <- months(ISOdate(2011,1:12,1))
        axis(1, at=1:12, labels=monthNames, las=2)
      }
      else if (input$plottype == "forecast"){
        par(bg="gray95")
        ts.plot(AirPassengers, fore$pred, upper, 
                lower, col=col1, lty = lty1, main="2-Year Forecast")
        legend("topleft", ll, col=col2, lty=lty2)
              
      }
    })
    output$table <- renderDataTable(df)
    output$typePlot <- renderPlot(c())
    
  }
)
  
