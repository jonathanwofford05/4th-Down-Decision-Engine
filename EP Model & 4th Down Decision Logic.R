#Model creation
pbp <- read_rds("data/raw/pbp_raw.rds")

ep_model <- lm(
  epa ~ ydstogo + yardline_100 + score_differential +
    qtr + game_seconds_remaining,
  data = pbp
)

saveRDS(ep_model, "outputs/ep_model.rds")

#Load data and model that was just
df <- read_rds("data/processed/fourth_down_data.rds")
model <- readRDS("outputs/conversion_model.rds")

#Pull correct feature order from model
feature_names <- model$feature_names

#Force same column order
X <- df[, feature_names]

#Convert to matrix
dmat <- xgb.DMatrix(as.matrix(X))

#Generate conversion probabilities
df$conv_prob <- predict(model, dmat)
summary(df$conv_prob)

#Convert to expected points
df <- df %>%
  mutate(
    exp_points = conv_prob * 2.5 + (1 - conv_prob) * (-1.2)
  )

summary(df$exp_points)

write_rds(df, "outputs/fourth_down_expected_points.rds")

#Visualization
ggplot(df, aes(x = ydstogo, y = yardline_100, z = exp_points)) +
  stat_summary_2d(fun = mean, bins = 25) +
  scale_fill_viridis_c() +
  labs(
    title = "4th Down Go-For-It Decision Heatmap",
    subtitle = "Expected Points by Field Position & Distance",
    x = "Yards To Go",
    y = "Distance From End Zone",
    fill = "Expected Points"
  ) +
  theme_minimal(base_size = 14)


#4th Down Logic and Decision Heat Map
df <- df %>%
  mutate(
    decision = case_when(
      exp_points > 0.9 ~ "GO FOR IT",
      exp_points > -0.6 ~ "FIELD GOAL",
      TRUE ~ "PUNT"
    )
  )

table(df$decision)

ggplot(df, aes(x = ydstogo, y = yardline_100, color = decision)) +
  geom_point(alpha = 0.2) +
  labs(
    title = "4th Down Decision Regions",
    x = "Yards To Go",
    y = "Distance From End Zone",
    color = "Recommended Decision"
  ) +
  theme_minimal(base_size = 14)