#' Anaesthetic Emissions
#' 
#' Estimates the CO2e emissions associated with different anaesthetic agents.
#'
#' @param desflurane Amount of desflurane used in KG (default: 0).
#' @param sevoflurane Amount of sevoflurane used in KG (default: 0).
#' @param isoflurane Amount of isoflurane used in KG (default: 0).
#' @param N2O Amount of nitrous oxide (N2O) used in KG (default: 0).
#' @param methoxyflurane Amount of methoxyflurane used in KG (default: 0).
#' @param propofol Amount of propofol used in KG (default: 0).
#'
#' @return The total CO2e emissions in tonnes.
#' @export
#' @examples
#' anaesthetic_emissions(desflurane = 200, sevoflurane = 30, N2O = 5)
#'
#' @details These estimates are based on available literature and may vary depending on factors such as specific anaesthetic agents, usage conditions, and waste gas management practices.
#'
#' @references 
#' - McGain F, Muret J, Lawson C, Sherman JD. Environmental sustainability in anaesthesia and critical care. Br J Anaesth. 2020 Nov;125(5):680-692. doi: 10.1016/j.bja.2020.06.055. Epub 2020 Aug 12. PMID: 32798068; PMCID: PMC7421303. [Link](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7421303/)
#' - ACS Sustainable Chem. Eng. 2019, 7, 7, 6580–6591. Publication Date: January 20, 2019. [Link](https://pubs.acs.org/doi/pdf/10.1021/acssuschemeng.8b05473)
#' - Sherman, Jodi MD*; Le, Cathy; Lamers, Vanessa; Eckelman, Matthew PhD. Life Cycle Greenhouse Gas Emissions of Anesthetic Drugs. Anesthesia & Analgesia 114(5):p 1086-1090, May 2012. DOI: 10.1213/ANE.0b013e31824f6940. [Link](https://journals.lww.com/anesthesia-analgesia/Fulltext/2012/05000/Life_Cycle_Greenhouse_Gas_Emissions_of_Anesthetic.25.aspx)
anaesthetic_emissions <- function(desflurane = 0, sevoflurane = 0, isoflurane = 0,
                                  N2O = 0, methoxyflurane = 0, propofol = 0){
  anaesthetics_df <- anaesthetics_df %>%
    dplyr::mutate(amount = c(desflurane, sevoflurane, isoflurane, N2O, methoxyflurane, propofol),
                  usage = c(amount*co2e)) %>%
    dplyr::summarise(co2e_kg = sum(usage))
  return(anaesthetics_df$co2e_kg * 0.001)
}
