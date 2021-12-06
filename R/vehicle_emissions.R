#' Calculate Emissions from Land-Travel
#' 
#' @description A function that calculates CO2 emissions on a journey on land. Values to calculate emissions is UK DEFRA from 2021 report.
# see https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2021-ghg-conversion-factors-methodology.pdf, https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021
#'
#' @param distance Distance in km or miles of the journey made (this can be calculated with other tools, such as google maps.). 
#' @param units Units for the distance travelled. Options are `"km"` or `"miles"`.
#' @param vehicle Vehicle used for the journey. Options are `"car"`, `"motorbike"`, `"taxi"`, `"van"`, `"bus"`, `"coach"`, `"tram"`, `"tube"`. Note: bus, coach, tram, tube, are all per passenger 
#' @param fuel Fuel type used for the journey. For car, `"petrol"`, `"diesel"`, `"hybrid"`, `"unknown"`, `"hybrid electric"`, `"battery electric"` are options. For van, `"petrol"`, `"diesel"`, and `"battery electric"` are options.
#' @param size Size of vehicle for car, motorbike, and van.
#' Options are `"small"`, `"medium"`, `"large"`, or `"average"`.
#' For car: small denotes up to a 1.4L engine, unless diesel which is up to 1.7L engine. Medium denotes 1.4-2.0L for petrol cars, 1.7-2.0L for diesel cars. Large denotes 2.0L+ engine.
#' For motorbike, sizes denote upto 125cc, 125cc-500cc, 500cc+ respectively.
#' @param type Options are `"local_nL"`, `"local_L"`, `"local"`, or `"average"`. These denote whether the bus is local but outside of London, local in London, local, or average.
#' @param taxi_type Whether a taxi is regular or black cab. Options are `"regular"`, `"black cab"`.
#'
#' @return Tonnes of CO2e emissions per mile travelled.
#' @export
#'
#' @examples # Emissions for a 100 mile car journey
#'  vehicle_emissions(distance = 100)
#' @examples # Emissions for a 100 mile motorbike journey where the motorbike is 500+cc
#'  vehicle_emissions(distance = 100, vehicle = "motorbike", size = "large")

vehicle_emissions <- function(distance, units = "miles", vehicle = "car", fuel = "petrol", size = "average", type = "average", taxi_type = "regular"){
  if (!is.numeric(distance) || distance < 0){
    stop("`distance` should be a postive number")
  }
  if (!(units) %in% c("miles", "km")){
    stop("`units` can only take values 'km' or 'miles'")
  }
  if (!(vehicle) %in% c("car", "motorbike", "taxi", "van", "bus", "coach", "tram", "tube")){
    stop("`vehicle` can only take values 'car', 'motorbike', 'taxi', 'van', 'bus', 'coach', 'tram', 'tube'")
  }
  if (!(fuel) %in% c("petrol", "diesel", "hybrid", "unknown", "hybrid electric", "battery electric")){
    stop("`fuel` can only take values 'petrol', 'diesel', 'hybrid', 'unknown', 'hybrid electric', 'battery electric'")
  }
  if (!(size) %in% c("small", "medium", "large", "average")){
    stop("`size` can only take values 'small', 'medium', 'large', or 'average'")
  }
  if (!(type) %in% c("local_nL", "local_L", "local", "average")){
    stop("`type` can only take values 'local_nL', 'local_L', 'local', 'average'")
  }
  if (!(taxi_type) %in% c("regular", "black cab")){
    stop("`taxi_type` can only take values 'regular', 'black cab'")
  }
  if (units == "km") {
    distance <- distance * 0.621371
  }
  if (vehicle == "car"){
    if (size == "small"){
      if (fuel == "petrol"){
        t_mile <- 0.00024052
      } else if (fuel == "diesel"){
        t_mile <- 0.00022143
      } else if (fuel == "hybrid"){
        t_mile <- 0.00016889
      } else if (fuel == "unknown"){
        t_mile <- 0.00023414
      } else if (fuel == "hybrid electric"){
        t_mile <- 0.00003607
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    } else if (size == "medium") {
      if (fuel == "petrol"){
        t_mile <- 0.00030231
      } else if (fuel == "diesel"){
        t_mile <- 0.00026549
      } else if (fuel == "hybrid"){
        t_mile <- 0.00017635
      } else if (fuel == "unknown"){
        t_mile <- 0.00028263
      } else if (fuel == "hybrid electric"){
        t_mile <- 0.00011175
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }else if (size == "large") {
      if (fuel == "petrol"){
        t_mile <- 0.00044914
      } else if (fuel == "diesel"){
        t_mile <- 0.00033348
      } else if (fuel == "hybrid"){
        t_mile <- 0.00024382
      } else if (fuel == "unknown"){
        t_mile <- 0.00036366
      } else if (fuel == "hybrid electric"){
        t_mile <- 0.00012350
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }else if (size == "average") {
      if (fuel == "petrol"){
        t_mile <- 0.00028053
      } else if (fuel == "diesel"){
        t_mile <- 0.00027108
      } else if (fuel == "hybrid"){
        t_mile <- 0.00019234
      } else if (fuel == "unknown"){
        t_mile <- 0.00027596
      } else if (fuel == "hybrid electric"){
        t_mile <- 0.00011426
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }
  }
  if (vehicle == "motorbike"){
    if (size == "small"){
      t_mile <- 0.00013369
    } else if (size == "medium") {
      t_mile <- 0.00016237
    }else if (size == "large") {
      t_mile <- 0.00021315
    }else if (size == "average") {
      t_mile <- 0.00018274
    }
  }
  if (vehicle == "taxi"){
    if (taxi_type == "regular"){
      t_mile <- 0.0003351611
    } else if (taxi_type == "black cab"){
      t_mile <- 0.4928443
    }
  }
  if (vehicle == "van"){
    if (size == "small"){
      if (fuel == "petrol"){
        t_mile <- 0.00032165
      } else if (fuel == "diesel"){
        t_mile <- 0.00023608
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    } else if (size == "medium") {
      if (fuel == "petrol"){
        t_mile <- 0.00031898
      } else if (fuel == "diesel"){
        t_mile <- 0.00029476
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }else if (size == "large") {
      if (fuel == "petrol"){
        t_mile <- 0.00050383
      } else if (fuel == "diesel"){
        t_mile <- 0.00042695
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }else if (size == "average"){
      if (fuel == "petrol") {
        t_mile <- 0.00033873
      } else if (fuel == "diesel") {
        t_mile <- 0.00038811
      } else if (fuel == "battery electric"){
        t_mile <- 0
      }
    }
  }
  if (vehicle == "bus"){
    if (type == "local_nL"){
      t_mile <- 0.00018948
    } else if (type == "local_L") {
      t_mile <- 0.00012421
    }else if (type == "average") {
      t_mile <- 0.00016459
    }
  }
  if (vehicle == "coach"){
    t_mile <- 0.00004319
  }
  if (vehicle == "tram"){
    t_mile <- 0.00006557525
  }
  if (vehicle == "tube"){
    t_mile <- 0.00004475575
  }
  emissions <- distance * t_mile
  return(emissions)
}
