library(nflfastR)
library(nfl4th)
library(nflplotR)
library(nflreadr)
library(nflseedR)
library(nflverse)
library(tidyverse)
library(caret)
library(xgboost)
library(randomForest)
library(shiny)
library(ggplot2)
library(plotly)
library(reactable)
library(gt)

pbp <- load_pbp(2015:2025)

dir.create("data", showWarnings = FALSE)
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs", showWarnings = FALSE)
dir.create("visuals", showWarnings = FALSE)
dir.create("app", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)

write_rds(pbp, "data/raw/pbp_raw.rds")
pbp <- read_rds("data/raw/pbp_raw.rds")
#Filter out garbage time plays
pbp <- pbp %>%
  filter(
    !(
      (qtr == 4 & abs(score_differential) >= 17) |
        (qtr == 3 & abs(score_differential) >= 24)
    )
  )
View(pbp)


team_strength <- pbp %>%
  filter(play_type %in% c("run","pass")) %>%
  group_by(posteam) %>%
  summarise(
    off_epa = mean(epa, na.rm = TRUE),
    plays = n()
  )
def_strength <- pbp %>%
  filter(play_type %in% c("run","pass")) %>%
  group_by(defteam) %>%
  summarise(
    def_epa = mean(epa, na.rm = TRUE)
  )

fourth <- pbp %>%
filter(down == 4, play_type %in% c("run", "pass")) %>%
  mutate(
    success = ifelse(first_down == 1 | touchdown == 1, 1, 0),
    home_team = ifelse(posteam_type == "home", 1, 0),
    shotgun = ifelse(shotgun == 1, 1, 0),
    short_yd = ifelse(ydstogo <= 3, 1, 0)
  ) %>%
  left_join(team_strength, by = "posteam") %>%
  left_join(def_strength, by = c("defteam" = "defteam")) %>%
  select(
    success,
    ydstogo,
    yardline_100,
    score_differential,
    qtr,
    game_seconds_remaining,
    shotgun,
    short_yd,
    home_team,
    off_epa,
    def_epa
  ) %>%
  drop_na()

View(fourth)

write_rds(fourth, "data/processed/fourth_down_data.rds")