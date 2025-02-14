
genTeamStats <- function(.results){
  
  .results %>%
    mutate(
      home.win    = as.integer(home.score > away.score),
      away.win    = as.integer(home.score < away.score),
      match.draw  = as.integer(home.score == away.score)
    ) -> .results
  
  .results %>%
    select( date       = match.date, 
            team       = home.team.cod, 
            rank       = home.rank, 
            rating     = home.rating,
            score.pro  = home.score,
            score.agst = away.score,
            win        = home.win,
            draw       = match.draw,
            defeat     = away.win,
            delta.rank = home.deltaRank,
            delta.rating = home.deltaRating,
            atHome     = home.atHome ) -> home.teams
  
  .results %>%
    mutate( atHome     = as.integer(away.team.cod==location) ) %>%
    select( date       = match.date, 
            team       = away.team.cod, 
            rank       = away.rank, 
            rating     = away.rating,
            score.pro  = away.score,
            score.agst = home.score,
            win        = away.win,
            draw       = match.draw,
            defeat     = home.win,
            delta.rank = away.deltaRank,
            delta.rating = away.deltaRating,
            atHome ) -> away.teams
  
  teams.stats <- bind_rows(home.teams, away.teams)
  
  teams.stats %>%
    group_by(team) %>%
    arrange(team, date) %>%
    mutate(
      # saldos de goals
      goals.pro.L1     = as.integer(    lag(score.pro,    k=2, default=0)),
      goals.pro.L2     = as.integer(rollsum(goals.pro.L1, k=2, na.pad=T, fill=0, align = "right")),
      goals.pro.L3     = as.integer(rollsum(goals.pro.L1, k=3, na.pad=T, fill=0, align = "right")),
      goals.pro.L5     = as.integer(rollsum(goals.pro.L1, k=5, na.pad=T, fill=0, align = "right")),
      goals.pro.L10    = as.integer(rollsum(goals.pro.L1, k=10, na.pad=T, fill=0, align = "right")),
      goals.pro.L20    = as.integer(rollsum(goals.pro.L1, k=20, na.pad=T, fill=0, align = "right")),
      goals.pro.L50    = as.integer(rollsum(goals.pro.L1, k=50, na.pad=T, fill=0, align = "right")),
      goals.pro.L100    = as.integer(rollsum(goals.pro.L1, k=100, na.pad=T, fill=0, align = "right")),
      goals.agst.L1    = as.integer(    lag(score.agst,    k=2, default=0)),
      goals.agst.L2    = as.integer(rollsum(goals.agst.L1, k=2, na.pad=T, fill=0, align = "right")),
      goals.agst.L3    = as.integer(rollsum(goals.agst.L1, k=3, na.pad=T, fill=0, align = "right")),
      goals.agst.L5    = as.integer(rollsum(goals.agst.L1, k=5, na.pad=T, fill=0, align = "right")),
      goals.agst.L10   = as.integer(rollsum(goals.agst.L1, k=10, na.pad=T, fill=0, align = "right")),
      goals.agst.L20   = as.integer(rollsum(goals.agst.L1, k=20, na.pad=T, fill=0, align = "right")),
      goals.agst.L50   = as.integer(rollsum(goals.agst.L1, k=50, na.pad=T, fill=0, align = "right")),
      goals.agst.L100   = as.integer(rollsum(goals.agst.L1, k=100, na.pad=T, fill=0, align = "right"))
    ) %>%
    mutate( 
      # net score
      goals.net.L1 = goals.pro.L1 - goals.agst.L1,
      goals.net.L2 = goals.pro.L2 - goals.agst.L2,
      goals.net.L3 = goals.pro.L3 - goals.agst.L3,
      goals.net.L5 = goals.pro.L5 - goals.agst.L5,
      goals.net.L10 = goals.pro.L10 - goals.agst.L10,
      goals.net.L20 = goals.pro.L20 - goals.agst.L20,
      goals.net.L50 = goals.pro.L50 - goals.agst.L50,
      goals.net.L100 = goals.pro.L100 - goals.agst.L100
    ) %>%
    mutate(
      win.L1     = as.integer(    lag(win,    k=2,  default=0)),
      wins.L2    = as.integer(rollsum(win.L1, k=2,  na.pad=T, fill=0, align = "right")),
      wins.L3    = as.integer(rollsum(win.L1, k=3,  na.pad=T, fill=0, align = "right")),
      wins.L5    = as.integer(rollsum(win.L1, k=5,  na.pad=T, fill=0, align = "right")),
      wins.L10   = as.integer(rollsum(win.L1, k=10, na.pad=T, fill=0, align = "right")),
      wins.L20   = as.integer(rollsum(win.L1, k=20, na.pad=T, fill=0, align = "right")),
      wins.L50   = as.integer(rollsum(win.L1, k=50, na.pad=T, fill=0, align = "right")),
      wins.L100   = as.integer(rollsum(win.L1, k=100, na.pad=T, fill=0, align = "right")),
      draw.L1    = as.integer(    lag(draw,    k=2,  default=0)),
      draws.L2   = as.integer(rollsum(draw.L1, k=2,  na.pad=T, fill=0, align = "right")),
      draws.L3   = as.integer(rollsum(draw.L1, k=3,  na.pad=T, fill=0, align = "right")),
      draws.L5   = as.integer(rollsum(draw.L1, k=5,  na.pad=T, fill=0, align = "right")),
      draws.L10  = as.integer(rollsum(draw.L1, k=10, na.pad=T, fill=0, align = "right")),
      draws.L20  = as.integer(rollsum(draw.L1, k=20, na.pad=T, fill=0, align = "right")),
      draws.L50  = as.integer(rollsum(draw.L1, k=50, na.pad=T, fill=0, align = "right")),
      draws.L100  = as.integer(rollsum(draw.L1, k=100, na.pad=T, fill=0, align = "right")),
      defeat.L1    = as.integer(    lag(defeat,    k=2,  default=0)),
      defeats.L2   = as.integer(rollsum(defeat.L1, k=2,  na.pad=T, fill=0, align = "right")),
      defeats.L3   = as.integer(rollsum(defeat.L1, k=3,  na.pad=T, fill=0, align = "right")),
      defeats.L5   = as.integer(rollsum(defeat.L1, k=5,  na.pad=T, fill=0, align = "right")),
      defeats.L10  = as.integer(rollsum(defeat.L1, k=10, na.pad=T, fill=0, align = "right")),
      defeats.L20  = as.integer(rollsum(defeat.L1, k=20, na.pad=T, fill=0, align = "right")),
      defeats.L50  = as.integer(rollsum(defeat.L1, k=50, na.pad=T, fill=0, align = "right")),
      defeats.L100  = as.integer(rollsum(defeat.L1, k=100, na.pad=T, fill=0, align = "right"))
    ) %>%
    mutate(
      strength.L1 = win.L1 - defeat.L1,
      strength.L2 = wins.L2 - defeats.L2,
      strength.L3 = wins.L3 - defeats.L3,
      strength.L5 = wins.L5 - defeats.L5,
      strength.L10 = wins.L10 - defeats.L10,
      strength.L20 = wins.L20 - defeats.L20,
      strength.L50 = wins.L50 - defeats.L50,
      strength.L100 = wins.L100 - defeats.L100
    ) %>%
    mutate(
      # rank and rating
      delta.rank.L1    = as.integer(    lag(delta.rank,    k=2,  default=0)),
      delta.rank.L2    = as.integer(rollsum(delta.rank.L1, k=2,  na.pad=T, fill=0, align = "right")),
      delta.rank.L3    = as.integer(rollsum(delta.rank.L1, k=3,  na.pad=T, fill=0, align = "right")),
      delta.rank.L5    = as.integer(rollsum(delta.rank.L1, k=5,  na.pad=T, fill=0, align = "right")),
      delta.rank.L10   = as.integer(rollsum(delta.rank.L1, k=10, na.pad=T, fill=0, align = "right")),
      delta.rank.L20   = as.integer(rollsum(delta.rank.L1, k=20, na.pad=T, fill=0, align = "right")),
      delta.rank.L50   = as.integer(rollsum(delta.rank.L1, k=50, na.pad=T, fill=0, align = "right")),
      delta.rank.L100   = as.integer(rollsum(delta.rank.L1, k=100, na.pad=T, fill=0, align = "right")),
      delta.rating.L1    = as.integer(    lag(delta.rating,    k=2,  default=0)),
      delta.rating.L2    = as.integer(rollsum(delta.rating.L1, k=2,  na.pad=T, fill=0, align = "right")),
      delta.rating.L3    = as.integer(rollsum(delta.rating.L1, k=3,  na.pad=T, fill=0, align = "right")),
      delta.rating.L5    = as.integer(rollsum(delta.rating.L1, k=5,  na.pad=T, fill=0, align = "right")),
      delta.rating.L10   = as.integer(rollsum(delta.rating.L1, k=10, na.pad=T, fill=0, align = "right")),
      delta.rating.L20   = as.integer(rollsum(delta.rating.L1, k=20, na.pad=T, fill=0, align = "right")),
      delta.rating.L50   = as.integer(rollsum(delta.rating.L1, k=50, na.pad=T, fill=0, align = "right")),
      delta.rating.L100   = as.integer(rollsum(delta.rating.L1, k=100, na.pad=T, fill=0, align = "right"))
    ) %>% 
    mutate(
      avg.rating.L1 = lag(rating, k=2, default=NA),
      avg.rating.L2 = rollmean(avg.rating.L1, k=2, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L3 = rollmean(avg.rating.L1, k=3, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L5 = rollmean(avg.rating.L1, k=5, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L10 = rollmean(avg.rating.L1, k=10, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L20 = rollmean(avg.rating.L1, k=20, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L50 = rollmean(avg.rating.L1, k=50, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rating.L100 = rollmean(avg.rating.L1, k=100, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L1 = lag(rank, k=2, default=NA),
      avg.rank.L2 = rollmean(avg.rank.L1, k=2, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L3 = rollmean(avg.rank.L1, k=3, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L5 = rollmean(avg.rank.L1, k=5, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L10 = rollmean(avg.rank.L1, k=10, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L20 = rollmean(avg.rank.L1, k=20, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L50 = rollmean(avg.rank.L1, k=50, na.pad=T, fill=NA, align = "right", na.rm=T),
      avg.rank.L100 = rollmean(avg.rank.L1, k=100, na.pad=T, fill=NA, align = "right", na.rm=T)
    ) %>%
    ungroup() %>%
    arrange(team,date) %>%
    # remove campos que sao estatisticas do jogo corrente
    select( -score.pro, -score.agst, -win, -draw, -defeat,
            -delta.rank, -delta.rating ) %>% 
    return()
}
  
