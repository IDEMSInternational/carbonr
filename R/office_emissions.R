#' CO2e emissions from office work.
#'
#' @param specify Whether an average should be used, or if they wish to specify the amount of energy used.
#' @param num_people Number of people in the office.
#' @param num_wfh Number of people working from home.
#' @param electricity_kwh TODO
#' @param kgco2e TODO
#' @param butane TODO
#' @param butane_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param CNG TODO
#' @param CNG_units # todo: can I give this with other _units ones?
#' @param LPG TODO
#' @param LPG_units TODO
#' @param LNG TODO
#' @param LNG_units TODO
#' @param natural_gas TODO
#' @param natural_gas_units TODO
#' @param gas TODO
#' @param gas_units TODO
#' @param propane TODO
#' @param propane_units TODO
#' @param burning_oil TODO
#' @param burning_oil_units TODO
#' @param diesel TODO
#' @param diesel_units TODO
#' @param coal TODO
#' @param coal_units TODO
#' @param wood TODO
#' @param wood_units TODO
#'
#' @return TODO
#' @export
#'
#' @examples # TODO

# also: 
# CO2e from water per cubic meters
# supply: 0.149
# trt (scope 3): 0.272

office_emissions <- function(specify = FALSE, num_people = 1, num_wfh, electricity_kwh, kgco2e = 0.21233, butane, butane_units, CNG, CNG_units, LPG, LPG_units, LNG, LNG_units, natural_gas, natural_gas_units = "kwh", gas, gas_units, propane, propane_units, burning_oil, burning_oil_units, diesel, diesel_units, coal, coal_units, wood, wood_units){
  if (specify == FALSE){
    # 2.60Tonnes CO2e as average for a year - https://www.carbonfootprint.com/businesscalculator.aspx?c=BusBasic&t=b
    emissions <- 2.60
  } else {
    # electricty - UK electricity tab
    electricity <- electricity_kwh * kgco2e
    
    # fuels - Fuels tab.
    # gaseous fuels calculations
    if (is.null(butane)){
      butane <- 0
    } else {
      if (butane_units == "tonnes"){
        butane <- butane * 3.03332
      } else if (butane_units == "litres"){
        butane <- butane * 0.00175
      } else if (butane_units == "kwh"){
        butane <- butane * 0.00024
      }
    }
    if (is.null(CNG)){
      CNG <- 0
    } else {
      if (CNG_units == "tonnes"){
        CNG <- CNG * 2.53848
      } else if (CNG_units == "litres"){
        CNG <- CNG * 0.00044423
      } else if (CNG_units == "kwh"){
        CNG <- CNG * 0.00020297
      }
    }
    if (is.null(LNG)){
      LNG <- 0
    } else {
      if (LNG_units == "tonnes"){
        LNG <- LNG * 2.55528
      } else if (LNG_units == "litres"){
        LNG <- LNG * 0.00115623
      } else if (LNG_units == "kwh"){
        LNG <- LNG * 0.00020431
      }
    }
    if (is.null(LPG)){
      LPG <- 0
    } else {
      if (LPG_units == "tonnes"){
        LPG <- LPG * 2.93929
      } else if (LPG_units == "litres"){
        LPG <- LPG * 0.00155709
      } else if (LPG_units == "kwh"){
        LPG <- LPG * 0.00023031
      }
    }
    if (is.null(natural_gas)){
      natural_gas <- 0
    } else {
      if (natural_gas_units == "tonnes"){
        natural_gas <- natural_gas * 2.55528
      } else if (natural_gas_units == "cubic metres"){
        natural_gas <- natural_gas * 0.00203473
      } else if (natural_gas_units == "kwh"){
        natural_gas <- natural_gas * 0.00020431
      }
    }
    if (is.null(gas)){
      gas <- 0
    } else {
      if (gas_units == "tonnes"){
        gas <- gas * 2.57825
      } else if (gas_units == "litres"){
        gas <- gas * 0.00094441
      } else if (gas_units == "kwh"){
        gas <- gas * 0.00019917
      }
    }
    if (is.null(propane)){
      propane <- 0
    } else {
      if (propane_units == "tonnes"){
        propane <- propane * 2.99755
      } else if (propane_units == "litres"){
        propane <- propane * 0.00154354
      } else if (propane_units == "kwh"){
        propane <- propane * 0.00023257
      }
    }
    # liquid, solid fuels calculations - to add. See Fuels tab.
    if (is.null(burning_oil)){
      burning_oil <- 0
    } else {
      if (burning_oil_units == "tonnes"){
        burning_oil <- burning_oil * 3.16501
      } else if (burning_oil_units == "litres"){
        burning_oil <- burning_oil * 0.00254514
      } else if (burning_oil_units == "kwh"){
        burning_oil <- burning_oil * 0.00026086
      }
    }
    if (is.null(diesel)){
      diesel <- 0
    } else {
      if (diesel_units == "tonnes"){
        diesel <- diesel * 2.96907
      } else if (diesel_units == "litres"){
        diesel <- diesel * 0.0025123
      } else if (diesel_units == "kwh"){
        diesel <- diesel * 0.00025165
      }
    }
    if (is.null(coal)){
      coal <- 0
    } else {
      if (coal_units == "tonnes"){
        coal <- coal * 2.88326
    } else if (coal_units == "kwh"){
        coal <- coal * 0.00034462
      }
    }
    
    # Bioenergy tab - Wood
    # wood logs
    # there are other wood options - chips, pellets, grass, straw, biofuel
    if (is.null(wood)){
      wood <- 0
    } else {
      if (wood_units == "tonnes"){
        wood <- wood * 0.06181736
      } else if (wood_units == "kwh"){
        wood <- wood * 0.00001513
      }
    }
    
    # add refrigerants - tab "Refrigerants and Other"
    emissions = electricity + butane + CNG + LNG + LPG + natural_gas + propane + wood + coal + diesel + burning_oil
  }
  wfh <- 0.50*num_wfh # from https://www.carbonfootprint.com/
  return((emissions * num_people) + wfh)
}
