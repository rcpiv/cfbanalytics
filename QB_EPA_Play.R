library(cfbfastR)
library(tidyverse)

pbp_2022 = load_cfb_pbp(2022)
player_stats = cfbd

dropback_epa = 
  pbp_2022 %>%
  