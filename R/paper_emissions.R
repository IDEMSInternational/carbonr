#' Paper Emissions
#'
#' @description This function calculates the emissions produced from different paper sources based on the specified inputs. It considers emissions from primary material production and waste disposal of paper materials.
#' 
#' @param board Numeric value indicating the weight of paperboard. Default is `0`.
#' @param mixed Numeric value indicating the weight of mixed paper. Default is `0`.
#' @param paper Numeric value indicating the weight of paper. Default is `0`.
#' @param board_WD Numeric value indicating the weight of paperboard disposed of using waste disposal methods. Default is `0`.
#' @param mixed_WD Numeric value indicating the weight of mixed paper disposed of using waste disposal methods. Default is `0`.
#' @param paper_WD Numeric value indicating the weight of paper disposed of using waste disposal methods. Default is `0`.
#' @param waste_disposal Character vector specifying the waste disposal method to use for calculating emissions. Possible values: `"Closed-loop"`, `"Combustion"`, `"Composting"`, `"Landfill"`. Default is `"Closed-loop"`.
#' `"Closed-loop"` is the process of recycling material back into the same product.
#' `"Combustion"` energy is recovered from the waste through incineration and subsequent generation of electricity.
#' `"Compost"` CO2e emitted as a result of composting a waste stream.
#' `"Landfill"` the product goes to landfill after use.
#' @param units Character vector specifying the units of the emissions output. Possible values: `"kg"`, `"tonnes"`. Default is `"kg"`.
#'
#' @return The function returns the calculated paper emissions as a numeric value in tonnes.
#' @export
#'
#' @examples
#' paper_emissions(board = 10, board_WD = 10, paper = 100, paper_WD = 100, units = "kg")
paper_emissions <- function(board = 0, mixed = 0, paper = 0,
                            board_WD = 0, mixed_WD = 0, paper_WD = 0,
                            waste_disposal = c("Closed-loop", "Combustion", "Composting", "Landfill"),
                            units = c("kg", "tonnes")){
  
  waste_disposal <- match.arg(waste_disposal)
  units <- match.arg(units)
  checkmate::assert_numeric(board, lower = 0)
  checkmate::assert_numeric(mixed, lower = 0)
  checkmate::assert_numeric(paper, lower = 0)
  checkmate::assert_numeric(board_WD, lower = 0)
  checkmate::assert_numeric(mixed_WD, lower = 0)
  checkmate::assert_numeric(paper_WD, lower = 0)
  
  MU <- uk_gov_data %>%
    dplyr::filter(`Level 2` == "Paper") %>%
    dplyr::filter(`Column Text` == "Primary material production") %>%
    dplyr::mutate(`Level 3` = ifelse(`Level 2` %in% c("Paper"),
                              gsub(".*: ", "", `Level 3`),
                              `Level 3`))
  
  WD <- uk_gov_data %>%
    dplyr::filter(`Level 1` == "Waste disposal") %>%
    dplyr::filter(`Level 2` == "Paper") %>%
    dplyr::filter(`Column Text` == waste_disposal)
  emission_values <- MU$`GHG Conversion Factor 2022`
  WD_values <- WD$`GHG Conversion Factor 2022`
  
  emission_values <- MU$`GHG Conversion Factor 2022`
  paper_emissions <- board*emission_values[1] + mixed*emission_values[2] + paper*emission_values[3] +
    board_WD*WD_values[1] + mixed_WD*WD_values[2] + paper_WD*WD_values[3]
  if (units == "kg") paper_emissions <- paper_emissions/1000
  return(paper_emissions)
}
