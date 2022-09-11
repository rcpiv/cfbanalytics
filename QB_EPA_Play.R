library(cfbfastR)
library(tidyverse)
library(ggimage)

pbp_2022 = load_cfb_pbp(2022)
player_stats_w1 = cfbd_game_player_stats(year =2022, week = 1)
player_stats_w2 = cfbd_game_player_stats(year =2022, week = 2)
players = cfbd_player_usage(year = 2022)
teams = cfbd_team_info(year = 2022)

dropback_epa = 
  pbp_2022 %>%
  filter(week == 1) %>%
  filter(wp_before >= 0.05) %>%
  filter(wp_before <= 0.95) %>%
  select(passer_player_name, home_EPA_pass, away_EPA_pass) %>%
  filter(!is.na(passer_player_name)) %>%
  add_count(passer_player_name) %>%
  filter(n >= 10) %>%
  left_join(players, by = c('passer_player_name' = 'name')) %>%
  filter(position == 'QB') %>%
  left_join(teams, by = c('team' = 'school')) %>%
  replace_na(list(home_EPA_pass = 0, away_EPA_pass = 0)) %>%
  mutate(pass_EPA = home_EPA_pass + away_EPA_pass) %>%
  select(passer_player_name, team, pass_EPA, n, logo) %>%
  group_by(passer_player_name, team, logo, n) %>%
  summarise(EPA_pp = mean(pass_EPA)) %>%
  arrange(desc(EPA_pp))

ggplot(dropback_epa, aes(x = EPA_pp, y= n)) +
  geom_point() +
  geom_image(aes(image = logo), size = 0.05, asp = 16/9)