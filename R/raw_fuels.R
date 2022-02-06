#' Raw Fuels Emissions
#' 
#' @param num_people Number of people to account for.
#' @param electricity_kwh TODO
#' @param kgco2e TODO
#' @param butane amount of Butane used.
#' @param CNG amount used. Compressed natural gas (CNG). A compressed version of the natural gas used in homes. An alternative transport fuel.
#' @param LPG amount used. Liquid petroleum gas. Used to power cooking stoves or heaters off-grid and fuel some vehicles (e.g. fork-lift trucks and vans).
#' @param LNG amount used. Liquefied natural gas. An alternative transport fuel.
#' @param natural_gas amount used. Standard natural gas received through the gas mains grid network in the UK.
#' @param natural_gas_mineral amount used. Natural gas (100% mineral blend) factor is natural gas not obtained through the grid and therefore does not contain any biogas content. It can be used for calculating bespoke fuel mixtures.
#' @param other_petroleum_gas amount used. Consists mainly of ethane, plus other hydrocarbons, (excludes butane and propane).
#' @param propane amount used.
#' @param aviation amount used.  Fuel for piston-engined aircraft - a high octane petrol (aka AVGAS).
#' @param aviation_fuel amount used. Fuel for turbo-prop aircraft and jets (aka jet fuel). Similar to kerosene used as a heating fuel, but refined to a higher quality.
#' @param burning_oil amount used. Main purpose is for heating/lighting on a domestic scale (also known as kerosene).
#' @param diesel amount used. Standard diesel bought from any local filling station (across the board forecourt fuel typically contains biofuel content).
#' @param diesel_mineral amount used. Diesel that has not been blended with biofuel (non-forecourt diesel).
#' @param fuel_oil amount used. Heavy oil used as fuel in furnaces and boilers of power stations, in industry, for industrial heating and in ships.
#' @param gas_oil amount used. Medium oil used in diesel engines and heating systems (also known as red diesel).
#' @param lubricants amount used. Waste petroleum-based lubricating oils recovered for use as fuels
#' @param naptha amount used. A product of crude oil refining - often used as a solvent.
#' @param petrol_biofuel amount used. Standard petrol bought from any local filling station (across the board forecourt fuel typically contains biofuel content).
#' @param petrol_mineral amount used. Petrol that has not been blended with biofuel (non forecourt petrol).
#' @param residual_oil amount used. Waste oils meeting the 'residual' oil definition contained in the 'Processed Fuel Oil Quality Protocol'.
#' @param distillate amount used. Waste oils meeting the 'distillate' oil definition contained in the 'Processed Fuel Oil Quality Protocol'.
#' @param refinery_miscellaneous amount used. Includes aromatic extracts, defoament solvents and other minor miscellaneous products
#' @param waste_oils amount used. Recycled oils outside of the 'Processed Fuel Oil Quality Protocol' definitions.
#' @param marine_gas amount used. Distillate fuels are commonly called "Marine gas oil". Distillate fuel is composed of petroleum fractions of crude oil that are separated in a refinery by a boiling or "distillation" process.
#' @param marine_fuel amount used. Residual fuels are called "Marine fuel oil". Residual fuel or "residuum" is the fraction that did not boil, sometimes referred to as "tar" or "petroleum pitch".
#' @param coal_industrial amount used. Coal used in sources other than power stations and domestic use.
#' @param coal_electricity_gen amount used. Coal used in power stations to generate electricity.
#' @param coal_domestic amount used. Coal used domestically.
#' @param coking_coal amount used. Coke may be used as a heating fuel and as a reducing agent in a blast furnace.
#' @param petroleum_coke amount used. Normally used in cement manufacture and power plants.
#' @param coal_home_produced_gen amount used. Coal used in power stations to generate electricity (only for coal produced in the UK).
#' @param bioethanol amount used. Renewable fuel derived from common crops (such as sugar cane and sugar beet).
#' @param biodiesel amount used. Renewable fuel almost exclusively derived from common natural oils (for example, vegetable oils).
#' @param biomethane amount used. The methane constituent of biogas.  Biogas comes from anaerobic digestion of organic matter.
#' @param biodiesel_cooking_oil amount used. Renewable fuel almost exclusively derived from common natural oils (such as vegetable oils).
#' @param biodiesel_tallow amount used. Renewable fuel almost exclusively derived from common natural oils (such as vegetable oils).
#' @param biodiesel_HVO amount used. 
#' @param biopropane amount used. 
#' @param bio_petrol amount used. 
#' @param renewable_petrol amount used. 
#' @param wood_log amount used. 
#' @param wood_chips amount used. 
#' @param wood_pellets amount used. Compressed low quality wood (such as sawdust and shavings) made into pellet form
#' @param grass amount used. 
#' @param biogas amount used. A naturally occurring gas from the anaerobic digestion of organic materials (such as sewage and food waste), or produced intentionally as a fuel from the anaerobic digestion of biogenic substances (such as energy crops and agricultural residues).
#' @param landfill_gas amount used. Gas collected from a landfill site. This may be used for electricity generation, collected and purified for use as a transport fuel, or be flared off
#' @param butane_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param CNG_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param LPG_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param LNG_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param natural_gas_units units that the gas is given in. Options are `"tonnes"`, `"cubic metres"`, `"kwh"`.
#' @param natural_gas_mineral_units units that the gas is given in. Options are `"tonnes"`, `"cubic metres"`, `"kwh"`.
#' @param other_petroleum_gas_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param propane_units units that the gas is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param aviation_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param aviation_fuel_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param burning_oil_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param diesel_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param diesel_mineral_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param fuel_oil_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param gas_oil_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param lubricants_units units that the fuel is given in. Options are `"tonnes"`, `"kwh"`.
#' @param naptha_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param petrol_biofuel_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param petrol_mineral_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param residual_oil_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param distillate_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param refinery_miscellaneous_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param waste_oils_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param marine_fuel_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param marine_gas_units units that the fuel is given in. Options are `"tonnes"`, `"litres"`, `"kwh"`.
#' @param coal_industrial_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param coal_electricity_gen_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param coal_domestic_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param coking_coal_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param petroleum_coke_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param coal_home_produced_gen_units units that the fuel is given in. Options are `"kwh"`, `"tonnes"`.
#' @param bioethanol_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biodiesel_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biomethane_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biodiesel_cooking_oil_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biodiesel_tallow_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biodiesel_HVO_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param biopropane_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param bio_petrol_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param renewable_petrol_units units that the biofuel is given in. Options are `"litres"`, `"GJ"`, `"kg"`.
#' @param wood_log_units units that the biomass is given in. Options are `"tonnes"`, `"kwh"`.
#' @param wood_chips_units units that the biomass is given in. Options are `"tonnes"`, `"kwh"`.
#' @param wood_pellets_units units that the biomass is given in. Options are `"tonnes"`, `"kwh"`.
#' @param grass_units units that the biomass is given in. Options are `"tonnes"`, `"kwh"`.
#' @param biogas_units units that the biogas is given in. Options are `"tonnes"`, `"kwh"`.
#' @param landfill_gas_units units that the biogas is given in. Options are `"tonnes"`, `"kwh"`.
#'
#'
#' @details Gas fuels: butane, CNG, LPG, LNG, natural_gas, natural_gas_mineral, other_petroleum_gas, propane.
#' Liquid fuels:
#' Solid fuels: 
#' 
#' 
#' @return TODO
#' @export
#'
#' @examples # TODO
#' 
#' @references Descriptions from 2021 UK Government Report: https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021
# also: 
# CO2e from water per cubic meters
# supply: 0.149
# trt (scope 3): 0.272

raw_fuels <- function(num_people = 1, electricity_kwh = 0, kgco2e = 0.21233,
                      butane = 0,CNG = 0,LPG = 0,LNG = 0,natural_gas = 0,natural_gas_mineral = 0,other_petroleum_gas = 0,propane = 0,
                      aviation = 0,aviation_fuel = 0,burning_oil = 0,diesel = 0,diesel_mineral = 0,fuel_oil = 0,gas_oil = 0,lubricants = 0,
                      naptha = 0,petrol_biofuel = 0,petrol_mineral = 0,residual_oil = 0,distillate = 0,refinery_miscellaneous = 0,
                      waste_oils = 0,marine_gas = 0,marine_fuel = 0,coal_industrial = 0,coal_electricity_gen = 0,coal_domestic = 0,
                      coking_coal = 0,petroleum_coke = 0,coal_home_produced_gen = 0,bioethanol = 0,biodiesel = 0,biomethane = 0,
                      biodiesel_cooking_oil = 0,biodiesel_tallow = 0,biodiesel_HVO = 0,biopropane = 0,bio_petrol = 0,
                      renewable_petrol = 0,wood_log = 0,wood_chips = 0,wood_pellets = 0,grass = 0,biogas = 0,landfill_gas = 0,
                      butane_units= c("kwh", "litres", "tonnes"), CNG_units= c("kwh", "litres", "tonnes"), LPG_units= c("kwh", "litres", "tonnes"), LNG_units= c("kwh", "litres", "tonnes"), natural_gas_units= c("kwh", "cubic metres", "tonnes"),
                      natural_gas_mineral_units= c("kwh", "cubic metres", "tonnes"), other_petroleum_gas_units= c("kwh", "litres", "tonnes"), propane_units= c("kwh", "litres", "tonnes"), aviation_units= c("kwh", "litres", "tonnes"),
                      aviation_fuel_units= c("kwh", "litres", "tonnes"), burning_oil_units= c("kwh", "litres", "tonnes"), diesel_units= c("kwh", "litres", "tonnes"), diesel_mineral_units= c("kwh", "litres", "tonnes"),
                      fuel_oil_units= c("kwh", "litres", "tonnes"), gas_oil_units= c("kwh", "litres", "tonnes"), lubricants_units= c("kwh", "litres", "tonnes"), naptha_units= c("kwh", "litres", "tonnes"), petrol_biofuel_units= c("kwh", "litres", "tonnes"),
                      petrol_mineral_units= c("kwh", "litres", "tonnes"), residual_oil_units= c("kwh", "litres", "tonnes"), distillate_units= c("kwh", "litres", "tonnes"), refinery_miscellaneous_units= c("kwh", "litres", "tonnes"),
                      waste_oils_units= c("kwh", "tonnes"), marine_gas_units= c("kwh", "tonnes"), marine_fuel_units= c("kwh", "tonnes"), coal_industrial_units= c("kwh", "tonnes"),
                      coal_electricity_gen_units= c("kwh", "tonnes"), coal_domestic_units= c("kwh", "tonnes"), coking_coal_units= c("kwh", "tonnes"), petroleum_coke_units= c("kwh", "tonnes"),
                      coal_home_produced_gen_units= c("kwh", "tonnes"), bioethanol_units = c("litres", "GJ", "kg"), biodiesel_units = c("litres", "GJ", "kg"), biomethane_units = c("litres", "GJ", "kg"),
                      biodiesel_cooking_oil_units = c("litres", "GJ", "kg"), biodiesel_tallow_units = c("litres", "GJ", "kg"), biodiesel_HVO_units = c("litres", "GJ", "kg"), biopropane_units = c("litres", "GJ", "kg"),
                      bio_petrol_units = c("litres", "GJ", "kg"), renewable_petrol_units = c("litres", "GJ", "kg"), wood_log_units= c("kwh", "tonnes"), wood_chips_units= c("kwh", "tonnes"),
                      wood_pellets_units= c("kwh", "tonnes"), grass_units= c("kwh", "tonnes"), biogas_units= c("kwh", "tonnes"), landfill_gas_units= c("kwh", "tonnes")){
  
  checkmate::assert_count(num_people)
  
  checkmate::assert_numeric(butane)
  checkmate::assert_numeric(CNG)
  checkmate::assert_numeric(LNG)
  checkmate::assert_numeric(LPG)
  checkmate::assert_numeric(natural_gas)
  checkmate::assert_numeric(natural_gas_mineral)
  checkmate::assert_numeric(other_petroleum_gas)
  checkmate::assert_numeric(propane)
  checkmate::assert_numeric(aviation)
  checkmate::assert_numeric(aviation_fuel)
  checkmate::assert_numeric(burning_oil)
  checkmate::assert_numeric(diesel)
  checkmate::assert_numeric(diesel_mineral)
  checkmate::assert_numeric(fuel_oil)
  checkmate::assert_numeric(gas_oil)
  checkmate::assert_numeric(lubricants)
  checkmate::assert_numeric(naptha)
  checkmate::assert_numeric(petrol_biofuel)
  checkmate::assert_numeric(petrol_mineral)
  checkmate::assert_numeric(residual_oil)
  checkmate::assert_numeric(distillate)
  checkmate::assert_numeric(refinery_miscellaneous)
  checkmate::assert_numeric(waste_oils)
  checkmate::assert_numeric(marine_gas)
  checkmate::assert_numeric(marine_fuel)
  checkmate::assert_numeric(coal_industrial)
  checkmate::assert_numeric(coal_electricity_gen)
  checkmate::assert_numeric(coal_domestic)
  checkmate::assert_numeric(coking_coal)
  checkmate::assert_numeric(petroleum_coke)
  checkmate::assert_numeric(coal_home_produced_gen)
  checkmate::assert_numeric(bioethanol)
  checkmate::assert_numeric(biodiesel)
  checkmate::assert_numeric(biomethane)
  checkmate::assert_numeric(biodiesel_cooking_oil)
  checkmate::assert_numeric(biodiesel_tallow)
  checkmate::assert_numeric(biodiesel_HVO)
  checkmate::assert_numeric(biopropane)
  checkmate::assert_numeric(bio_petrol)
  checkmate::assert_numeric(renewable_petrol)
  checkmate::assert_numeric(wood_log)
  checkmate::assert_numeric(wood_chips)
  checkmate::assert_numeric(wood_pellets)
  checkmate::assert_numeric(grass)
  checkmate::assert_numeric(biogas)
  checkmate::assert_numeric(landfill_gas)
  
  butane_units <- match.arg(butane_units)
  CNG_units <- match.arg(CNG_units)
  LNG_units <- match.arg(LNG_units)
  LPG_units <- match.arg(LPG_units)
  natural_gas_units <- match.arg(natural_gas_units)
  natural_gas_mineral_units <- match.arg(natural_gas_mineral_units)
  other_petroleum_gas_units <- match.arg(other_petroleum_gas_units)
  propane_units <- match.arg(propane_units)
  aviation_units <- match.arg(aviation_units)
  aviation_fuel_units <- match.arg(aviation_fuel_units)
  burning_oil_units <- match.arg(burning_oil_units)
  diesel_units <- match.arg(diesel_units)
  diesel_mineral_units <- match.arg(diesel_mineral_units)
  fuel_oil_units <- match.arg(fuel_oil_units)
  gas_oil_units <- match.arg(gas_oil_units)
  lubricants_units <- match.arg(lubricants_units)
  naptha_units <- match.arg(naptha_units)
  petrol_biofuel_units <- match.arg(petrol_biofuel_units)
  petrol_mineral_units <- match.arg(petrol_mineral_units)
  residual_oil_units <- match.arg(residual_oil_units)
  distillate_units <- match.arg(distillate_units)
  refinery_miscellaneous_units <- match.arg(refinery_miscellaneous_units)
  waste_oils_units <- match.arg(waste_oils_units)
  marine_gas_units <- match.arg(marine_gas_units)
  marine_fuel_units <- match.arg(marine_fuel_units)
  coal_industrial_units <- match.arg(coal_industrial_units)
  coal_electricity_gen_units <- match.arg(coal_electricity_gen_units)
  coal_domestic_units <- match.arg(coal_domestic_units)
  coking_coal_units <- match.arg(coking_coal_units)
  petroleum_coke_units <- match.arg(petroleum_coke_units)
  coal_home_produced_gen_units <- match.arg(coal_home_produced_gen_units)
  bioethanol_units <- match.arg(bioethanol_units)
  biodiesel_units <- match.arg(biodiesel_units)
  biomethane_units <- match.arg(biomethane_units)
  biodiesel_cooking_oil_units <- match.arg(biodiesel_cooking_oil_units)
  biodiesel_tallow_units <- match.arg(biodiesel_tallow_units)
  biodiesel_HVO_units <- match.arg(biodiesel_HVO_units)
  biopropane_units <- match.arg(biopropane_units)
  bio_petrol_units <- match.arg(bio_petrol_units)
  renewable_petrol_units <- match.arg(renewable_petrol_units)
  wood_log_units <- match.arg(wood_log_units)
  wood_chips_units <- match.arg(wood_chips_units)
  wood_pellets_units <- match.arg(wood_pellets_units)
  grass_units <- match.arg(grass_units)
  biogas_units <- match.arg(biogas_units)
  landfill_gas_units <- match.arg(landfill_gas_units)
  
  var_fuel <- c(unique(fuels$Fuel))
  unit_fuel <- c(butane_units, CNG_units, LNG_units, LPG_units, natural_gas_units, natural_gas_mineral_units, other_petroleum_gas_units, propane_units, aviation_units, aviation_fuel_units, burning_oil_units,
                 diesel_units, diesel_mineral_units, fuel_oil_units, gas_oil_units, lubricants_units, naptha_units, petrol_biofuel_units, petrol_mineral_units, residual_oil_units, distillate_units,
                 refinery_miscellaneous_units, waste_oils_units, marine_gas_units, marine_fuel_units, coal_industrial_units, coal_electricity_gen_units, coal_domestic_units, coking_coal_units, petroleum_coke_units,
                 coal_home_produced_gen_units, bioethanol_units, biodiesel_units, biomethane_units, biodiesel_cooking_oil_units, biodiesel_tallow_units, biodiesel_HVO_units, biopropane_units, bio_petrol_units,
                 renewable_petrol_units, wood_log_units, wood_chips_units, wood_pellets_units, grass_units, biogas_units, landfill_gas_units)
  val_fuel <- c(butane, CNG, LNG, LPG, natural_gas, natural_gas_mineral, other_petroleum_gas, propane, aviation, aviation_fuel, burning_oil,
                diesel, diesel_mineral, fuel_oil, gas_oil, lubricants, naptha, petrol_biofuel, petrol_mineral, residual_oil, distillate,
                refinery_miscellaneous, waste_oils, marine_gas, marine_fuel, coal_industrial, coal_electricity_gen, coal_domestic, coking_coal, petroleum_coke,
                coal_home_produced_gen, bioethanol, biodiesel, biomethane, biodiesel_cooking_oil, biodiesel_tallow, biodiesel_HVO, biopropane, bio_petrol,
                renewable_petrol, wood_log, wood_chips, wood_pellets, grass, biogas, landfill_gas)
  
    # electricty - UK electricity tab
    electricity <- electricity_kwh * kgco2e
    emission <- NULL
    for (i in 1:length(var_fuel)){
      if (val_fuel[i] != 0){
        emission[i] <- (fuels %>%
                          dplyr::filter(Fuel == var_fuel[i]) %>%
                          dplyr::filter(unit == unit_fuel[i]))$CO2e * val_fuel[i]
      } else {
        emission[i] <- 0
      }
    }
    total_emissions <- sum(emission) + electricity
  #}
  overall_emissions <- total_emissions * num_people
  return(overall_emissions)
}
