
# ============================================================
# FBDP ANALYTICS DASHBOARD
# Portfolio prototype | Illustrative data
# ============================================================

library(shiny)
library(tidyverse)

# 1. LOAD THE EXISTING ANALYSIS OUTPUTS -----------------------

overall_rankings <- read_csv(
  "data/processed/overall_rankings.csv",
  show_col_types = FALSE
)

theme_rankings <- read_csv(
  "data/processed/theme_rankings.csv",
  show_col_types = FALSE
)

rank_change <- read_csv(
  "data/processed/rank_change.csv",
  show_col_types = FALSE
)

block_insights <- read_csv(
  "data/processed/block_insights.csv",
  show_col_types = FALSE
)

years <- sort(unique(overall_rankings$Year))
blocks <- sort(unique(overall_rankings$Block))

latest_year <- tail(years, 1)

# 2. DASHBOARD DESIGN -----------------------------------------

ui <- navbarPage(
  title = "BLOCK DEVELOPMENT ANALYTICS",
  id = "main_nav",
  
  header = tags$head(
    tags$style(HTML("
      :root {
        --navy: #14243e;
        --navy-soft: #203b5b;
        --teal: #36a99b;
        --ink: #243247;
        --muted: #68788d;
        --line: #e2e8f0;
        --page: #f4f6fa;
      }

      html { scroll-behavior: smooth; }
      body {
        background: var(--page);
        color: var(--ink);
        font-family: 'Segoe UI', Arial, sans-serif;
        font-size: 14px;
        line-height: 1.55;
      }

      /* Navigation */
      .navbar {
        background: var(--navy);
        border: 0;
        border-radius: 0;
        margin-bottom: 0;
        box-shadow: 0 3px 12px rgba(20,36,62,.12);
      }
      .navbar-default .navbar-brand,
      .navbar-default .navbar-nav > li > a {
        color: #e8eef6;
        font-weight: 500;
      }
      .navbar-default .navbar-brand {
        font-size: 15px;
        font-weight: 750;
        letter-spacing: .45px;
      }
      .navbar-default .navbar-nav > li > a { padding-top: 17px; padding-bottom: 17px; }
      .navbar-default .navbar-brand:hover,
      .navbar-default .navbar-nav > li > a:hover,
      .navbar-default .navbar-nav > li > a:focus {
        color: #fff; background: #203b5b;
      }
      .navbar-default .navbar-nav > .active > a,
      .navbar-default .navbar-nav > .active > a:hover,
      .navbar-default .navbar-nav > .active > a:focus {
        color: #fff; background: #203b5b;
        box-shadow: inset 0 -3px 0 #45c4b0;
      }

      .container-fluid { padding-left: 26px; padding-right: 26px; }
      .tab-content { padding-top: 22px; padding-bottom: 28px; }

      /* Compact page headers: consistent across every tab */
      .hero {
        background: linear-gradient(110deg, #14243e 0%, #203f5f 72%, #276e6a 100%);
        color: #fff;
        padding: 24px 28px 22px;
        margin: 0 -26px 24px -26px;
        border-bottom: 3px solid #45c4b0;
      }
      .hero h2 {
        color: #fff; font-size: 25px; font-weight: 700;
        letter-spacing: -.35px; margin: 0 0 7px; line-height: 1.25;
      }
      .hero p { color: #dce8f2; font-size: 13px; margin: 3px 0 0; }

      /* KPI cards */
      .kpi {
        height: 100%; min-height: 128px;
        background: #fff; border: 1px solid var(--line);
        border-top: 3px solid var(--teal); border-radius: 10px;
        padding: 20px 21px; margin-bottom: 20px;
        box-shadow: 0 3px 12px rgba(20,36,62,.045);
      }
      .kpi-label {
        color: var(--muted); font-size: 11px; text-transform: uppercase;
        letter-spacing: .75px; font-weight: 700; line-height: 1.45;
      }
      .kpi-value {
        color: var(--navy); font-size: 27px; font-weight: 750;
        margin-top: 13px; overflow-wrap: anywhere; line-height: 1.2;
      }

      /* Panels and section headings */
      .panel-card {
        background: #fff; border: 1px solid var(--line);
        border-radius: 11px; padding: 22px 23px; margin-bottom: 22px;
        box-shadow: 0 3px 12px rgba(20,36,62,.035);
      }
      .section-title { color: var(--navy); font-size: 17px; font-weight: 700; margin: 0 0 10px; }
      .subtext { color: var(--muted); font-size: 12.5px; line-height: 1.5; margin-bottom: 16px; }

      /* Inputs */
      .control-label { color: #35465d; font-weight: 650; font-size: 12px; margin-bottom: 7px; }
      .form-control {
        min-height: 38px; border: 1px solid #d5deea; border-radius: 7px;
        box-shadow: none; color: var(--ink); background: #fff;
      }
      .form-control:focus { border-color: var(--teal); box-shadow: 0 0 0 2px rgba(54,169,155,.12); }
      .selectize-input { border-color: #d5deea; border-radius: 7px; box-shadow: none; }

      /* Tables */
      .table {
        width: 100%; background: #fff; color: #29384d;
        margin-bottom: 0; font-size: 13px;
      }
      .table > thead > tr > th {
        color: #52637a; background: #f7f9fc; font-weight: 700;
        font-size: 11px; text-transform: uppercase; letter-spacing: .45px;
        border-bottom: 1px solid #dfe6ef; padding: 11px 12px;
      }
      .table > tbody > tr > td { padding: 10px 12px; border-top: 1px solid #edf0f5; vertical-align: middle; }
      .table-striped > tbody > tr:nth-of-type(odd) { background: #fafbfd; }
      .table-hover > tbody > tr:hover { background: #f0f7f7; }

      .disclaimer {
        background: #fff9eb; border: 1px solid #f1e3bd;
        border-left: 4px solid #d7a23c; padding: 15px 18px;
        margin: 20px 0; color: #594b2e; border-radius: 8px;
      }
      .disclaimer p { margin: 6px 0 0; }
      .footer-note { color: #7b8798; font-size: 11px; padding: 12px 0 24px; border-top: 1px solid var(--line); }

      /* Chart defaults */
      .shiny-plot-output { max-width: 100%; }
      @media (max-width: 767px) {
        .container-fluid { padding-left: 14px; padding-right: 14px; }
        .hero { margin-left: -14px; margin-right: -14px; padding: 20px 17px; }
        .hero h2 { font-size: 22px; }
        .panel-card { padding: 17px 15px; }
        .navbar-default .navbar-brand { font-size: 12px; }
      }
    "))
  ),
  
  # OVERVIEW TAB ----------------------------------------------
  tabPanel(
    "Overview",
    
    div(
      class = "hero",
      h2("Block Development Analytics"),
      p("Monitoring, evaluation and block performance analytics"),
      p("Portfolio prototype | Illustrative data | Reporting years 2024–25 and 2025–26")
    ),
    
    fluidRow(
      column(
        3,
        selectInput(
          "year",
          "Reporting year",
          choices = years,
          selected = latest_year
        )
      )
    ),
    
    uiOutput("kpi_cards"),
    
    fluidRow(
      column(
        7,
        div(
          class = "panel-card",
          h4(class = "section-title", "Top 10 Blocks"),
          p(class = "subtext", "Ranked by normalised overall score"),
          plotOutput("top_chart", height = "350px")
        )
      ),
      
      column(
        5,
        div(
          class = "panel-card",
          h4(class = "section-title", "Highest-ranked Blocks"),
          tableOutput("top_table")
        )
      )
    ),
    
    div(
      class = "disclaimer",
      strong("Data and methodology note"),
      p(
        "This is an independent portfolio prototype using illustrative ",
        "data. Scores and rankings are not verified official programme ",
        "results. Performance classifications and scoring follow the ",
        "rules implemented in the accompanying analysis scripts."
      )
    )
  ),
  
  # RANKINGS TAB ----------------------------------------------
  tabPanel(
    "Block Rankings",
    
    div(
      class = "hero",
      h2("Block Performance Rankings"),
      p("Explore overall performance, compare blocks and inspect scores.")
    ),
    
    fluidRow(
      column(
        4,
        selectInput(
          "rank_year",
          "Reporting year",
          choices = years,
          selected = latest_year
        )
      ),
      
      column(
        4,
        selectInput(
          "rank_type",
          "Ranking view",
          choices = c("Top 10", "Bottom 10", "All blocks"),
          selected = "Top 10"
        )
      )
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Overall ranking table"),
      p(class = "subtext", "Rank 1 indicates the highest normalised score."),
      tableOutput("ranking_table")
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Score distribution"),
      plotOutput("score_chart", height = "680px")
    )
  ),
  
  # THEME PERFORMANCE TAB -------------------------------------
  tabPanel(
    "Theme Performance",
    
    div(
      class = "hero",
      h2("Performance Across Development Themes"),
      p("Explore relative theme scores for an individual block.")
    ),
    
    fluidRow(
      column(
        4,
        selectInput(
          "theme_year",
          "Reporting year",
          choices = years,
          selected = latest_year
        )
      ),
      
      column(
        4,
        selectInput(
          "selected_block",
          "Select block",
          choices = blocks,
          selected = blocks[1]
        )
      )
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Theme score comparison"),
      p(
        class = "subtext",
        "Normalised scores are scaled within each year and theme; ",
        "compare themes cautiously."
      ),
      plotOutput("theme_chart", height = "400px")
    ),
    
    fluidRow(
      column(
        6,
        div(
          class = "panel-card",
          h4(class = "section-title", "Strongest theme"),
          tableOutput("strongest_table")
        )
      ),
      
      column(
        6,
        div(
          class = "panel-card",
          h4(class = "section-title", "Weakest theme"),
          tableOutput("weakest_table")
        )
      )
    )
  ),
  
  # RANK MOVEMENT TAB -----------------------------------------
  tabPanel(
    "Rank Movement",
    
    div(
      class = "hero",
      h2("Year-on-Year Rank Movement"),
      p("Examine changes in relative block positions.")
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Largest rank improvements"),
      p(
        class = "subtext",
        "Positive rank change indicates improvement; negative change ",
        "indicates a decline. Rank movement does not necessarily mean ",
        "absolute performance improved or deteriorated."
      ),
      plotOutput("movement_chart", height = "450px")
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Rank movement details"),
      tableOutput("movement_table")
    )
  ),
  
  # METHODOLOGY TAB -------------------------------------------
  tabPanel(
    "Methodology",
    
    div(
      class = "hero",
      h2("Methodology and Interpretation"),
      p("How to interpret the prototype's indicators and rankings.")
    ),
    
    div(
      class = "panel-card",
      h4(class = "section-title", "Analytical workflow"),
      tags$ol(
        tags$li("Import and clean source workbook data."),
        tags$li("Prepare block-level actuals and annual targets."),
        tags$li("Classify performance against the available targets."),
        tags$li("Apply the scoring rules implemented in the analysis."),
        tags$li("Aggregate scores and calculate relative rankings."),
        tags$li("Visualise results and compare changes across years.")
      ),
      
      h4(class = "section-title", "Scoring rules in the prototype"),
      tags$ul(
        tags$li("Achiever: score of 1."),
        tags$li(
          "Front-Runner with baseline Under-Performing status: 0.5."
        ),
        tags$li(
          "Front-Runner with baseline Performing status: 0.25."
        ),
        tags$li("Aspirer: score of 0."),
        tags$li(
          "Unavailable values may be excluded from score calculations."
        )
      ),
      
      h4(class = "section-title", "Important limitations"),
      tags$ul(
        tags$li(
          "Illustrative data must not be presented as verified official results."
        ),
        tags$li(
          "Target-based classifications may not fully capture indicator-specific ",
          "policy benchmarks or desired directions of change."
        ),
        tags$li(
          "Overall scores currently average available indicator scores. ",
          "Themes with more indicators can therefore contribute more heavily."
        ),
        tags$li(
          "Normalised scores show relative position within the comparison group, ",
          "not an absolute measure of development outcomes."
        ),
        tags$li(
          "Rank changes can reflect changes in other blocks as well as ",
          "changes in a block's own performance."
        )
      )
    )
  ),
  
  footer = tags$div(
    class = "footer-note",
    "FBDP Analytics | Independent portfolio prototype | Illustrative data"
  )
)

# 3. DASHBOARD LOGIC ------------------------------------------

server <- function(input, output, session) {
  
  # Filter overall rankings for the selected year
  year_data <- reactive({
    overall_rankings |>
      filter(Year == input$year)
  })
  
  # Summary cards
  output$kpi_cards <- renderUI({
    
    dat <- year_data()
    
    n_blocks <- n_distinct(dat$Block)
    
    top_block <- dat |>
      arrange(Overall_Rank) |>
      slice_head(n = 1)
    
    avg_score <- mean(dat$Normalised_Score, na.rm = TRUE)
    
    score_range <- paste0(
      round(min(dat$Normalised_Score, na.rm = TRUE), 1),
      "–",
      round(max(dat$Normalised_Score, na.rm = TRUE), 1)
    )
    
    div(
      class = "kpi-grid",
      
      fluidRow(
        column(
          3,
          div(
            class = "kpi",
            div(class = "kpi-label", "Blocks assessed"),
            div(class = "kpi-value", n_blocks)
          )
        ),
        
        column(
          3,
          div(
            class = "kpi",
            div(class = "kpi-label", "Top-ranked block"),
            div(class = "kpi-value", top_block$Block[1])
          )
        ),
        
        column(
          3,
          div(
            class = "kpi",
            div(class = "kpi-label", "Average normalised score"),
            div(class = "kpi-value", round(avg_score, 1))
          )
        ),
        
        column(
          3,
          div(
            class = "kpi",
            div(class = "kpi-label", "Score range"),
            div(class = "kpi-value", score_range)
          )
        )
      )
    )
  })
  
  # Top 10 horizontal bar chart
  output$top_chart <- renderPlot({
    
    dat <- year_data() |>
      arrange(Overall_Rank) |>
      slice_head(n = 10)
    
    ggplot(
      dat,
      aes(
        x = reorder(Block, Normalised_Score),
        y = Normalised_Score
      )
    ) +
      geom_col(fill = "#239b91", width = 0.68) +
      geom_text(
        aes(label = round(Normalised_Score, 1)),
        hjust = -0.15,
        size = 3.5,
        color = "#14243e"
      ) +
      coord_flip() +
      scale_y_continuous(
        limits = c(0, max(dat$Normalised_Score, na.rm = TRUE) * 1.15)
      ) +
      labs(x = NULL, y = "Normalised score") +
      theme_minimal(base_size = 13) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(
          color = "#e8edf3",
          linewidth = 0.5
        ),
        axis.text = element_text(color = "#33445c"),
        axis.title.x = element_text(
          color = "#65758b",
          margin = margin(t = 10)
        ),
        plot.margin = margin(10, 18, 10, 10)
      )
  })
  
  output$top_table <- renderTable({
    
    year_data() |>
      arrange(Overall_Rank) |>
      slice_head(n = 10) |>
      transmute(
        Rank = as.integer(Overall_Rank),
        Block,
        Score = round(Normalised_Score, 1)
      )
  }, striped = TRUE, bordered = FALSE, hover = TRUE, rownames = FALSE)
  
  # Rankings table, including top/bottom/all views
  ranking_data <- reactive({
    
    dat <- overall_rankings |>
      filter(Year == input$rank_year) |>
      arrange(Overall_Rank)
    
    if (input$rank_type == "Top 10") {
      dat <- dat |> slice_head(n = 10)
    } else if (input$rank_type == "Bottom 10") {
      dat <- dat |> slice_tail(n = 10) |> arrange(desc(Overall_Rank))
    }
    
    dat
  })
  
  output$ranking_table <- renderTable({
    
    ranking_data() |>
      transmute(
        Rank = as.integer(Overall_Rank),
        Block,
        `Normalised score` = round(Normalised_Score, 1)
      )
    
  }, striped = TRUE, bordered = FALSE, hover = TRUE, rownames = FALSE)
  
  output$score_chart <- renderPlot({
    
    dat <- year_data() |>
      arrange(Overall_Rank)
    
    ggplot(
      dat,
      aes(
        x = reorder(Block, Normalised_Score),
        y = Normalised_Score
      )
    ) +
      geom_col(fill = "#284d70", width = 0.68) +
      coord_flip() +
      scale_y_continuous(expand = expansion(mult = c(0, 0.04))) +
      labs(x = NULL, y = "Normalised score") +
      theme_minimal(base_size = 12) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(color = "#e8edf3", linewidth = 0.45),
        axis.text = element_text(color = "#46566b", size = 9),
        axis.title.x = element_text(color = "#68788d", margin = margin(t = 9)),
        plot.margin = margin(8, 12, 8, 8)
      )
  })
  
  # Theme chart for the selected block and year
  output$theme_chart <- renderPlot({
    
    dat <- theme_rankings |>
      filter(
        Year == input$theme_year,
        Block == input$selected_block
      ) |>
      arrange(Normalised_Score)
    
    validate(
      need(nrow(dat) > 0, "No theme data is available for this selection.")
    )
    
    ggplot(
      dat,
      aes(
        x = reorder(Theme, Normalised_Score),
        y = Normalised_Score
      )
    ) +
      geom_col(fill = "#239b91", width = 0.7) +
      geom_text(
        aes(label = round(Normalised_Score, 1)),
        hjust = -0.15,
        size = 4
      ) +
      coord_flip() +
      scale_y_continuous(
        limits = c(
          0,
          max(dat$Normalised_Score, na.rm = TRUE) * 1.2
        )
      ) +
      labs(x = NULL, y = "Normalised score") +
      theme_minimal(base_size = 12) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
      )
  })
  
  output$strongest_table <- renderTable({
    
    block_insights |>
      filter(Block == input$selected_block) |>
      transmute(
        Block,
        Theme = Strongest_Theme,
        Score = round(Strongest_Score, 2)
      )
  }, rownames = FALSE)
  
  output$weakest_table <- renderTable({
    
    block_insights |>
      filter(Block == input$selected_block) |>
      transmute(
        Block,
        Theme = Weakest_Theme,
        Score = round(Weakest_Score, 2)
      )
  }, rownames = FALSE)
  
  # Rank movement data
  movement_data <- reactive({
    
    rank_change |>
      transmute(
        Block,
        Previous_Rank = .data[["2024-25"]],
        Current_Rank = .data[["2025-26"]],
        Rank_Change
      )
  })
  
  output$movement_chart <- renderPlot({
    
    dat <- movement_data() |>
      slice_max(
        order_by = abs(Rank_Change),
        n = 15,
        with_ties = FALSE
      ) |>
      arrange(Rank_Change)
    
    ggplot(
      dat,
      aes(
        x = reorder(Block, Rank_Change),
        y = Rank_Change,
        fill = Rank_Change > 0
      )
    ) +
      geom_col(width = 0.72) +
      geom_hline(yintercept = 0, color = "#66758a") +
      coord_flip() +
      scale_fill_manual(
        values = c("TRUE" = "#239b91", "FALSE" = "#d97768"),
        labels = c("TRUE" = "Improved rank", "FALSE" = "Declined rank"),
        name = NULL
      ) +
      labs(x = NULL, y = "Rank improvement (+) / decline (−)") +
      theme_minimal(base_size = 11) +
      theme(
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = "bottom"
      )
  })
  
  output$movement_table <- renderTable({
    
    movement_data() |>
      arrange(desc(Rank_Change)) |>
      transmute(
        Block,
        `2024–25 rank` = as.integer(Previous_Rank),
        `2025–26 rank` = as.integer(Current_Rank),
        `Rank change` = as.integer(Rank_Change)
      )
  }, striped = TRUE, bordered = FALSE, hover = TRUE, rownames = FALSE)
}

# 4. LAUNCH THE APPLICATION ----------------------------------

shinyApp(ui = ui, server = server)
