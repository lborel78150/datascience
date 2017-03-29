# dowload à la main sur https://opendata.paris.fr/explore/dataset/stations-velib-disponibilites-en-temps-reel/export/
library(shiny)
library(stringr)
library(ggmap)
library(leaflet)

# se mettre dans le bon répertoire 
setwd("D:/Projet_Velib")
velib<-read.csv("stations-velib.csv",header=T,sep=";")
# repartition des stations par tailles
hist(velib$bike_stands,xlab="Nombre de vélos",col=3,main="Repartition de la taille des stations vélib")
plot(density(velib$bike_stands),main="Densité des stations vélib / taille",col=4)

# recuperer les donnees GPS
velib_position<-as.data.frame((str_split_fixed(velib[,4], ", ", 2)))
names(velib_position)<-c("lat","longitude")

# remettre les positions
velib<-cbind(velib[,1:3],velib_position,velib[,5:12])
velib$longitude<-as.numeric(as.character(velib$longitude))
velib$lat<-as.numeric(as.character(velib$lat))
plot(x=velib$longitude,y=velib$lat)

#charger la carte de paris
map.paris<-get_map(c(lon=2.35,lat=48.86),zoom=12,maptype="roadmap")
#afficher la carte de paris
ggmap(map.paris)
#indiquer la taille max = device
map.paris<-ggmap(map.paris, extent="device")
# afficher les stations
map.paris + geom_point(data=velib,aes(x=longitude,y=lat,size=bike_stands,col=bonus))


