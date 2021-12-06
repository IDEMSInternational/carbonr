# carbonr
Calculating CO2 equivalent (CO2e) emissions in R

The emissions that are calculated (with their respective sources given in square brackets):

* Train journeys[1]
* Ferry/boat journeys[1]
* Vehicles[1]
* Flights[1, 2]
* Secondary Emissions[3]
* Hotel stays[1]

Sources for the emission values

[1] UK government 2021 report.
See https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990675/2021-ghg-conversion-factors-methodology.pdf
https://www.gov.uk/government/publications/greenhouse-gas-reporting-conversion-factors-2021
Note emissions for flights in the code uses values from direct effects only. Radiative forcing = TRUE will give indirect and direct effects. (multiples by 1.891). See "business travel - air" sheet of gov.uk excel sheet linked above.

[2] 
Radiative forcing as 1.891 is from www.carbonfund.org

[3]
Secondary sources calculated using https://www.carbonfootprint.com/calculatorfaqs.html

Next Steps:
* Add average home office per person function
* Create simple vignette
* Add in short haul/medium haul
Under Employee Travel (https://carbonfund.org/calculation-methods/)
"Short flights are calculated to be under 300 miles one-way with emissions of 0.217kg CO2e per passenger mile
Medium flights are calculated to be 300-2300 miles one-way, average 1500 miles, with emissions of 0.134 kg CO2e per passenger mile
Long flights are calculated to be > 2300 miles, average 3,000 miles one-way with emissions of 0.167kg CO2e per passenger mile"
