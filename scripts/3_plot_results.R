# Load libraries
library(here)
library(ggplot2)

# Load results
results_1train <- read.csv(here::here('results', 'results_1trainenv.csv'))

# Plot results

## Create plots for one training environment

# Create a plot for the calibration slope
glm_plot_train <- ggplot(results_1train, aes(calibration_train.slope, AUC_train)) +
  geom_point(aes(color=train_variable), size=2) +
  geom_segment(aes(xend = calibration_test.slope, yend = AUC_test, color = train_variable, linetype = interaction(dataset, task_tag)),
               arrow = arrow(type = "open", length = unit(0.2, "inches")),
               linewidth = 1) +
  scale_linetype_manual(values=c("solid", "dotted", "dashed", "dotted", "solid", "dashed")) +
  geom_vline(xintercept = 0, color = "darkgrey", linetype = "dashed", linewidth = 1) +
  geom_vline(xintercept = 1, color = "darkgrey", linetype = "dashed", linewidth = 1) +
  xlab("Calibration slope") +
  ylab("Discrimination") +
  ggtitle("Calibration slope versus discrimination score") +
  facet_wrap(~type, ncol=2) + 
  scale_y_continuous(limits=c(0.45, 1), breaks=c(0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  theme_bw() +
  theme(legend.position = "bottom", legend.box = "vertical")

# Create a plot for the calibration intercept
glm_plot_train_2 <- ggplot(results_1train, aes(calibration_train.int, AUC_train)) +
  geom_point(aes(color=train_variable), size=2) +
  geom_segment(aes(xend = calibration_test.int, yend = AUC_test, color = train_variable, linetype = interaction(dataset, task_tag)),
               arrow = arrow(type = "open", length = unit(0.2, "inches")),
               linewidth = 1) +
  scale_linetype_manual(values=c("solid", "dotted", "dashed", "dotted", "solid", "dashed")) +
  geom_vline(xintercept = 0, color = "darkgrey", linetype = "dashed", linewidth = 1) +
  xlab("Calibration intercept") +
  ylab("Discrimination") +
  ggtitle("Calibration intercept versus discrimination score") +
  facet_wrap(~type, ncol=2) + 
  scale_y_continuous(limits=c(0.45, 1), breaks=c(0.5, 0.6, 0.7, 0.8, 0.9, 1.0)) +
  theme_bw() +
  theme(legend.position = "bottom", legend.box = "vertical")


# Save the plots under results
path <- here::here("results", "graphics")
path_train_slope_glm <- file.path(path, "arrow_plot_trainenv_slope.pdf")
path_train_int_glm <- file.path(path, "arrow_plot_trainenv_int.pdf")


pdf(path_train_slope_glm)
glm_plot_train
dev.off()

pdf(path_train_int_glm)
glm_plot_train_2
dev.off()

# Interpreting the results
res_diag_train <- results_1train[results_1train$type=="diagnosis",]
res_prog_train <- results_1train[results_1train$type=="prognosis",]

# Calculating the mean values for diagnosis
mean(res_diag_train$AUC_train)
mean(res_diag_train$AUC_test)
mean(res_diag_train$calibration_train.int)
mean(res_diag_train$calibration_test.int)
mean(res_diag_train$calibration_train.slope)
mean(res_diag_train$calibration_test.slope)

# Calculating the mean values for prognosis
mean(res_prog_train$AUC_train)
mean(res_prog_train$AUC_test)
mean(res_prog_train$calibration_train.int)
mean(res_prog_train$calibration_test.int)
mean(res_prog_train$calibration_train.slope)
mean(res_prog_train$calibration_test.slope)
