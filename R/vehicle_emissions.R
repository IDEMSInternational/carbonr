vehicle_emissions <- function(distance, units = "miles", vehicle = "car", fuel = "petrol", size = "average", type = "average", taxi_type = "regular"){
  # size only for motorbike: upto 125cc, 125cc-500cc, 500cc+
  # mpg only for car. But defaults are given based off data.
  # source: UK DEFRA
  #https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2021-ghg-conversion-factors-methodology.pdf
  # and UK 2021 https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021
  
  
  if (units == "km") {
    distance <- distance * 0.621371
  }
  
  #if (vehicle == "car"){
  #  if (fuel == "gas") {
  #    fuel <- 0.008887
  #    if (is.null(mpg)){ mpg <- 36.0 }
  #  } else if (fuel == "diesel") {
  #    fuel <- 0.01018
  #    if (is.null(mpg)){ mpg <- 43.0 }
  #  }
  #  # according to: https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle
  #  # similar for carboncalc
  #  # MPG  source: https://www.nimblefins.co.uk/cheap-car-insurance/average-mpg#:~:text=in%20your%20vehicle.-,Average%20Miles%20per%20Gallon,diesel%20cars%20getting%2043%20mpg.
  #  emissions <- distance / mpg * fuel
  #}
  
  # Table 15
  if (vehicle == "car"){
    # T of CO2e burnt per mile
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
      } else if (fuel == "battery"){
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
      } else if (fuel == "battery"){
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
      } else if (fuel == "battery"){
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
  
  # table 25
  if (vehicle == "motorbike"){
    # T of CO2 burnt per mile
    if (size == "small"){
      t_mile <- 0.00013369
    } else if (size == "medium") {
      t_mile <- 0.00016237
    }else if (size == "large") {
      t_mile <- 0.00021315
    }else if (size == "average") {
      t_mile <- 0.00018274
    }
    # https://www.gov.uk/government/statistics/provisional-uk-greenhouse-gas-emissions-national-statistics-2020
    #https://www.thrustcarbon.com/insights/how-to-calculate-motorbike-co2-emissions
  }
  
  # business - travel - land on excel
  if (vehicle == "taxi"){
    # T of CO2 burnt per mile
    if (taxi_type == "regular"){
      t_mile <- 0.0003351611
    } else if (taxi_type == "black cab"){
      t_mile <- 0.4928443
    }
  }
  
  # table 21
  # note: their small/medium/large values don't make sense, or add up with the average stuff.
  if (vehicle == "van"){
    # T of CO2e burnt per mile
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
  
  # note: bus, coach, tram, tube, are all per passenger 
  # table 24
  if (vehicle == "bus"){
    # T of CO2e burnt per mile
    if (type == "local_nL"){
      t_mile <- 0.00018948
    } else if (type == "local_L") {
      t_mile <- 0.00012421
    }else if (type == "local") {
      t_mile <- 0.00016459
    }else if (type == "average") {
      t_mile <- 0.0001594267
    }
  }
  
  # table 24
  if (vehicle == "coach"){
    # T of CO2e burnt per mile
    t_mile <- 0.00004319
  }
  
  # table 26
  if (vehicle == "tram"){
    # T of CO2e burnt per mile
    t_mile <- 0.00006557525
  }
  
  # table 26
  if (vehicle == "tube"){
    # T of CO2e burnt per mile
    t_mile <- 0.00004475575
  }
  
  emissions <- distance * t_mile
  
  return(emissions)
}