setwd("C:/xampp/htdocs/bissey/R - appunti/R-homework")

library(RODBC)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(plotly)
connstr <- paste("Server=193.206.59.19",
                "Database=Didattica",
                "uid=Stats",
                "pwd=UpoStats2015!",
                "Driver={SQL Server}",
                sep=";")
conn<-odbcDriverConnect(connstr)
q<-"select count(distinct(MATRICOLA)) as nb,NOME as nome from Iscritti 
group by nome order by nb,nome desc"
res <-sqlQuery(conn,q)
close(conn)

str(res)
res<- res %>% mutate_if(is.factor,as.character) %>% filter(nb>50) 
res %>% 
  ggplot(aes(x=reorder(nome,nb),y=nb,fill=nb)) +
  geom_bar(width=0.4,stat="identity") + 
  scale_fill_gradient2(low="#ff1133",mid="#eeeeee",high="#3311ff",midpoint=700)+
#geom_text(aes(label=nome), position=position_dodge(width=0.9), size=2) +
  coord_flip()+
  theme_classic()#+
#  theme(axis.title.y=element_blank(),
#        axis.text.y=element_blank(),
#        axis.ticks.y=element_blank())
########################################################
conn<-odbcDriverConnect(connstr)
q<-"select count(distinct(MATRICOLA)) as nb,NOME as nome from Iscritti 
group by nome order by nb desc,nome"
res <-sqlQuery(conn,q)
close(conn)

res<- res %>% filter(nb>50) 
res$nome <- factor(res$nome, 
  levels = unique(res$nome)[order(res$nb, decreasing = FALSE)])

colfunc <- colorRampPalette(c("darkred","#eeeeee", "darkblue"))
pal <- colfunc(max(res$nb))[res$nb]

res %>% plot_ly(y=~nome,x=~nb,
                marker = list(color =  pal)) %>% 
  add_bars() 


