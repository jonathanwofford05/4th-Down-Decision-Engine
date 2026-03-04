4th-Down-Decision-Engine
NFL Fourth-Down Decision Analytics Engine

Overview
This project builds an end-to-end NFL fourth-down decision modeling system using 2015–2025 play-by-play data. The objective is to determine whether teams should go for it, attempt a field goal, or punt by maximizing expected value in a given game situation.

The system integrates machine learning for conversion probability, an Expected Points (EP) model, and an expected value decision engine. An interactive Shiny dashboard allows real-time scenario testing and recommendations.

Project Objective
The goal is to move beyond simple prediction and create a prescriptive decision engine that selects the fourth-down action with the highest expected points.




Data:

NFL play-by-play data (2015–2025 seasons)

Filtered to run and pass plays

Isolated fourth down situations

Applied garbage-time filtering to remove low-leverage snaps




Modeling Approach

Conversion Probability Model

  Model: XGBoost classification

  Target variable: success (first down or touchdown)

  Performance: AUC = 0.645


This model estimates the probability of converting a fourth-down attempt based on situational and team context.


Expected Points Model

  Model: Linear regression

  Predicts expected points for a given game state

  Used to quantify the value of success and cost of failure
  

Decision Engine
  The engine calculates expected value for three options:

  Go for it

  Field goal

  Punt

Each decision’s expected value is computed using outcome probabilities and resulting expected points. The recommendation selects the option with the highest expected value.


Key Features Used

  Success
  
  Yards to go
  
  Field position (yardline_100)
  
  Score differential
  
  Game seconds remaining
  
  Quarter
  
  Shotgun indicator
  
  Home team indicator
  
  Offensive EPA
  
  Defensive EPA

Strategic Insights

  Short-yardage situations are often undervalued analytically.
  
  Field position significantly alters optimal aggression.
  
  Team strength shifts decision boundaries.
  
  Midfield fourth-and-medium situations represent the true decision gray area.
  
  Long-yardage attempts are structurally negative expected value.



Interactive Dashboard
The Shiny dashboard allows users to:
  
  Input situational variables
  
  View real-time conversion probability
  
  Compare expected value across all three decisions
  
  Receive a data-driven recommendation


Limitations

  Optimizes expected points rather than win probability
  
  Uses historical averages for punts and field goals
  
  Does not model specific play calls or personnel groupings
  
  Does not incorporate weather or injury context
  


Tech Stack

  R
  
  nflfastR
  
  XGBoost
  
  tidyverse


Author
Jonathan Wofford
Sports Management | Data Analytics 
  ggplot2
  
  Shiny

Author
Jonathan Wofford
Sports Management | Data Analytics
