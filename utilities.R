# Utility Functions

# Function to sort AIC and BIC Scores
# Example: sort.score(AIC(model1, model2), score = 'aic')
sort.score <- function(x, score = c("bic", "aic")){
  if (score == "aic"){
    x[with(x, order(AIC)),]
  } else if (score == "bic") {
    x[with(x, order(BIC)),]
  } else {
    warning('score = "x" only accepts valid arguments ("aic","bic")')
  }
}

# ============================================================================= #

# Fitted ARIMA Models Summary generator
# Example: arima_summary(Data, c(1,1,1))

arima_summary <- function(TS_data, pdq_order){

  # Check if TS_data is of class 'ts'
  if (!inherits(TS_data, "ts")) {
    stop("TS_data must be of class 'ts'")
  }

  # Estimate ARIMA model using CSS method
  model_css <- TS_data %>% Arima(order = pdq_order, method = 'CSS')

  # Print parameter estimation results for CSS method
  cat("\nParameter Estimation through Least Squares (CSS) Method for ARIMA(",
      pdq_order, ")\n")
  print(lmtest::coeftest(model_css))
  cat("==============================================================")

  # Estimate ARIMA model using ML method
  model_ml <- TS_data %>% Arima(order = pdq_order, method = 'ML')

  # Print parameter estimation results for ML method
  cat("\nParameter Estimation through Maximum Likelihood (ML) Method for ARIMA(",
      pdq_order, ")\n")
  print(lmtest::coeftest(model_ml))
  cat("==============================================================")

  # Estimate ARIMA model using CSS-ML method
  model_cssml <- TS_data %>% Arima(order = pdq_order, method = 'CSS-ML')

  # Print parameter estimation results for CSS-ML method
  cat("\nParameter Estimation through Combination (CSS-ML) Method for ARIMA(",
      pdq_order, ")\n")
  print(lmtest::coeftest(model_cssml))
  cat("==============================================================")

  # Store the models in a list
  ret_list <- list(model_css, model_ml, model_cssml)

  # Create names for the list elements based on pdq_order
  label <- paste0(pdq_order, collapse = "")
  names(ret_list) <- c(paste0("model_", label, "_css"),
                       paste0("model_", label, "_ml"),
                       paste0("model_", label, "_cssml"))

  # Return the list of models
  return(ret_list)
}
