
library(sf)
library(tidyverse)
library(tmap)
library(readr)
library(RSQLite)

shape = st_read("/Users/frenny/Library/Mobile Documents/com~apple~CloudDocs/GIS/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")
# shp 파일 불러오기

csv = read.csv("/Users/frenny/Library/Mobile Documents/com~apple~CloudDocs/GIS/fly-tipping-borough.csv",fileEncoding = "euc-kr")
# csv 파일 불러오기

plot(shape)
# shp 파일 보기
summary(shape)
# shp 파일 정보 요약본 보기


mycsv = read.csv("/Users/frenny/Library/Mobile Documents/com~apple~CloudDocs/GIS/fly-tipping-borough.csv",fileEncoding = "euc-kr", skip = 1)
# csv 헤더 삭제, 한글 깨짐 해결

mycsv
# print(mycsv)

shape <- shape%>%
  merge(.,
        mycsv,
        by.x="GSS_CODE",
        by.y="row_label") # csv 파일에 있는 이름과 같은지 잘 확인 할 것 
# shp 와 csv 파일을 결합하기

shape%>%
  head(., n=10)
# shp 파일 상위 n개만 보기

tmap_mode("plot")
# change the fill to your column name if different
shape %>%
  qtm(.,fill = "총합계") # 결합된 shp 파일에 있는 변수 명인지 확인 잘 할 것

shape %>%
  st_write(.,"/Users/frenny/Library/Mobile Documents/com~apple~CloudDocs/GIS/week_3.gpkg",
           "london_boroughs_fly_tipping",
           delete_layer=TRUE)
# geopackage 만들기

con <- dbConnect(RSQLite::SQLite(),dbname="/Users/frenny/Library/Mobile Documents/com~apple~CloudDocs/GIS/week_3.gpkg")
# 저장한 geopackage 불러오기

con %>%
  dbListTables()
