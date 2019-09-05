########################################################################
# Introduce the concept of bar charts through MLHub.
#
# Copyright 2018 Graham.Williams@togaware.com

library(mlhub)

mlcat("Introducing Bar Charts with R ggplot2",
      "The Australian weather dataset from the Rattle package
(https://rattle.togaware.com) is used to illustrate bar
charts. The ggplot2 package provides the platform for
all of our plotting needs.

The examples we will use here come from the book,
Essentials of Data Science, by Graham Williams.
Visit https://essentials.togaware.com for more details.")

#-----------------------------------------------------------------------
# Load required packages from local library into the R session.
#-----------------------------------------------------------------------

suppressMessages(
{
  library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
  library(rattle)       # Support: normVarNames(), weatherAUS. 
  library(ggplot2)      # Visualise data.
  library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
  library(randomForest) # Model: randomForest() na.roughfix() missing data.
  library(RColorBrewer) # Choose different colors.
  library(scales)       # Include commas in numbers.
  library(stringi)      # String concat operator %s+%.
})

#-----------------------------------------------------------------------
# Colour blind friendly palette:
#-----------------------------------------------------------------------

cb <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
        "#0072B2", "#D55E00", "#CC79A7")

#-----------------------------------------------------------------------
# Prepare the Weather dataset.
#-----------------------------------------------------------------------

dsname <- "weatherAUS"
ds     <- get(dsname)

#-----------------------------------------------------------------------
# Cleanup the dataset.
#-----------------------------------------------------------------------

names(ds) %<>% normVarNames()

vars   <- names(ds)
target <- "rain_tomorrow"
vars   <- c(target, vars) %>% unique()
risk   <- "risk_mm"
id     <- c("date", "location")
ignore <- c(risk, id)
vars   <- setdiff(vars, ignore)

ds[vars] %<>% na.roughfix()

#-----------------------------------------------------------------------
# Template variables for the plots.
#-----------------------------------------------------------------------

xv   <- "wind_dir_3pm"
fill <- "rain_tomorrow"

#-----------------------------------------------------------------------
# A simple bar chart.
#-----------------------------------------------------------------------

mlask()

mlcat("Simple Bar Chart",
      "A simple bar chart is easy to generate using gpglot2 and can be used to
understand the frequency of observations. Below we explore the frequency of
different wind directions in the weather dataset.

The pipeline passes the dataset on to ggplot() where the aesethetics are
identified, simply associating the wind direction at 3pm with the x-axis.
A bar chart geometry is added to the plot. The heights of the bars will be
automatically determined from the dataset.

  ds %>%
    ggplot(aes(x=wind_dir_3pm)) +
    geom_bar()")

fname <- "weather_bar_basic.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv)) +
  scale_y_continuous(labels=comma) +
  geom_bar()
invisible(dev.off())
mlask()
mlpreview(fname, begin="")
mlask()

#-----------------------------------------------------------------------
# Incorporate stacked bars.
#-----------------------------------------------------------------------

mlcat("Stacked Bars",
      "We can plot a stacked bar chart to include an extra dimension (variable) in the
presentation. Here we have stacked the variable rain_tomorrow which records
whether there was rain reported on the following day.

  ds %>%
    ggplot(aes(x=wind_dir_3pm, fill=rain_tomorrow)) +
    geom_bar()")

fname <- "weather_bar_stacked.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, fill=fill)) +
  scale_y_continuous(labels=comma) +
  geom_bar() +
  scale_fill_brewer(palette="Paired")
invisible(dev.off())
mlask()
mlpreview(fname, begin="")
mlask()

#-----------------------------------------------------------------------
# Replace stacked bars with dodged bars.
#-----------------------------------------------------------------------

mlcat("Dodged Bars",
      "Often it is more effective to compare bars from a common baseline. The above
bars can be plotted side-by-side by introducing the use of the position=
argument when adding the bars to the plot. ")

fname <- "weather_bar_dodged.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, fill=fill)) +
  scale_y_continuous(labels=comma) +
  geom_bar(position="dodge") +
  scale_fill_brewer(palette="Paired")
invisible(dev.off())
mlask()
mlpreview(fname, begin="")
mlask()

#-----------------------------------------------------------------------
# A carefully crafted bar chart.
#-----------------------------------------------------------------------

mlcat("Crafting the Bar Chart",
      "We demonstrate here a more fully and carefully crafted bar chart as we would
for our final presnetation of the data. Titles are added and the legend is placed
inside the plot iself.")

blues2 <- brewer.pal(4, "Paired")[1:2]

ds$location %>%
  unique() %>%
  length() ->
num_locations

fname <- "weather_bar_informative.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, fill=fill)) +
  geom_bar(position="dodge") +
  scale_fill_brewer(palette="Paired",
                    labels = c("No Rain", "Rain")) +
  scale_y_continuous(labels=comma) +
  theme(legend.position   = c(.75, .95),
        legend.direction  = "horizontal",
        legend.title      = element_text(colour="grey40"),
        legend.text       = element_text(colour="grey40"),
        legend.background = element_rect(fill="transparent")) +
  labs(title    = "Rain Expected by Wind Direction at 3pm",
       subtitle = "Observations from " %s+% num_locations %s+% " weather stations",
       caption  = "Source: Australian Bureau of Meteorology", 
       x        = "Wind Direction 3pm",
       y        = "Number of Days",
       fill     = "Tomorrow")
invisible(dev.off())
mlask()
mlpreview(fname, begin="")
