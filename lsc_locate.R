# lsc_locate
# script to scrape Legal Services Corporation grantee data
# source: http://www.lsc.gov/grants-grantee-resources/our-grantees 

# 1. Libraries

library(readxl)
library(tidyverse)

# 2. LSC grantee identifier
# grantee pages identified with unique RNO (recipient number) value
# this code extracts RNO values for grantees in 2015

?download.file
download.file("http://www.lsc.gov/sites/default/files/Grants/pdfs/FUNDSBYGRANTEE2015.xlsx", "funds_2015.xlsx", mode = "wb")
funds_2015 <- read_excel("funds_2015.xlsx", col_names = FALSE)

lsc_ident <- funds_2015[2:4] %>%
  filter(complete.cases(.)) %>% # includes RESERVE: American Samoa Legal Aid (lower)
  rename(rno = X1, name = X2, state = X3 ) %>%
  slice(2:length(rno)) %>%
  distinct(rno, name, state) 

# some RNO are duplicated

lsc_ident_dups <- lsc_ident %>%
  group_by(rno) %>%
  mutate(dups = anyDuplicated(rno)) %>%
  filter(dups > 0) %>%
  select(- dups)
    
# unique RN0

rnos <- lsc_ident %>% distinct(rno) %>% as.list()
    
