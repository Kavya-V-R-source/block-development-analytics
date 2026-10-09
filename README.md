**Block Development Analytics**

An independent portfolio project examining block-level development performance across Tamil Nadu, India, through indicator analysis, performance scoring, relative benchmarking and interactive visualisation using R.

**Live dashboard:** [Block Development Analytics](https://kavya-analytics.shinyapps.io/fbdp-analytics-portfolio/)

**Project overview**

The project demonstrates an analytical workflow for organising development indicators and comparing block-level performance across development themes and reporting years. It explores how monitoring data can be translated into structured performance measures to inform sub-state planning and administrative review.

**Analytical approach**

The workflow covers data preparation and validation, indicator-level performance classification, scoring, aggregation, min–max normalisation, ranking and dashboard outputs. Analysis scripts are available in the scripts/ directory.

**Dashboard**

The R Shiny application provides five views:

**_Overview_:** summary measures and leading blocks.

**_Block Rankings_:** top 10, bottom 10 and full rankings.

**_Theme Performance_:** block-level comparison across development themes.

**_Rank Movement_:** changes in relative positions between reporting years.

**_Methodology_:** scoring rules and interpretation guidance.

**Methodological considerations**

Rankings provide relative benchmarks within the comparison group, rather than absolute measures of development outcomes. Min–max normalisation expresses scores relative to the observed range within each comparison group and is sensitive to extreme values. Scores across themes or reporting years should therefore be interpreted in light of the normalisation method. The overall score averages available indicator scores; themes with more indicators can consequently contribute more heavily. Rank changes may also reflect shifts in other blocks' performance.

**Tools**

R · tidyverse · ggplot2 · Shiny

This is an independent technical portfolio project, not an official government assessment. Interpretation is subject to the implemented scoring rules, data coverage and methodological limitations.
