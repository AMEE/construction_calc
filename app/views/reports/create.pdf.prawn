require 'open-uri'

#################
# Headers & Logo
#################
pdf.text "#{@project.name} carbon report", :align => :center, :style => :bold, :size => 18

#################
# Intro Text
#################
pdf.move_down 10
pdf.text "Overview", :style => :bold
pdf.move_down 10
pdf.text "#{@project.client.name} has developed a Carbon Footprint Calculator, powered by AMEE, to calculate the carbon generated from fit out and refurbishment projects.  The #{@project.name} project decided to calculate the carbon emissions from their project in order to understand the impact that their project had on the environment."
pdf.move_down 10
pdf.text "To do this, #{@project.client.name} collects data during the project and enters this into the Carbon Footprint Calculator.  AMEE then calculates the carbon emissions (CO2) from this data."

pdf.move_down 20
pdf.text "In more detail", :style => :bold
pdf.move_down 10
pdf.text "The data that was collected during the project is listed below:"
pdf.move_down 10
pdf.span(20, :position => 15) do
    pdf.text "1."
    pdf.move_down 14
    pdf.text "2."
    pdf.move_down 14
    pdf.text "3."
    pdf.text "4."
    pdf.text "5."
    pdf.text "6."
end
pdf.move_up 111
pdf.span(500, :position => 30) do
    pdf.text "Vehicle deliveries – the number of deliveries to site, the miles travelled and the size of the vehicle."
    pdf.text "Commuting miles – number of people travelling to site, the distance each person commuted to get to the site, and the mode of transport."
    pdf.text "Fuel – quantities of plant gas, diesel, and petrol consumed."
    pdf.text "Electricity – measured using a sub-meter where possible."
    pdf.text "Waste – the quantity and type of wastes produced, and the amount that was recycled."
    pdf.text "Material used – quantity and type of materials used, and whether they contain any recycled content.  (All materials contain ‘embodied energy‘ - the energy needed for procuring the raw material and manufacturing the product.)"
end

#################
# Project Details
#################
# pdf.stroke_color "333333"
# pdf.stroke_rectangle([0,680], 200, 80)
# 
# pdf.stroke_color "000000"
# pdf.text_box "Project Details",
#     :width => 100, :height => 20,
#     :at => [5, 675],
#     :style => :bold
# pdf.text_box "Number:",
#     :width => 75, :height => 20,
#     :at => [5, 655]
# pdf.text_box @project.number,
#     :width => 75, :height => 20,
#     :at => [80, 655]
# pdf.text_box "Value:",
#     :width => 75, :height => 20,
#     :at => [5, 642]
# pdf.text_box "£#{@project.value}",
#     :width => 75, :height => 20,
#     :at => [80, 642]
# pdf.text_box "Floor area:",
#     :width => 75, :height => 20,
#     :at => [5, 629]
# pdf.text_box "#{@project.floor_area}sq.m",
#     :width => 75, :height => 20,
#     :at => [80, 629]
# pdf.text_box "Start Date:",
#     :width => 75, :height => 20,
#     :at => [5, 616]
# pdf.text_box "#{@project.start_date}",
#     :width => 75, :height => 20,
#     :at => [80, 616]

#################
# Chart
#################
pdf.move_down 20
pdf.text "This Project", :style => :bold
pdf.image open(@project.google_chart_url), :at => [0,320], :scale => 0.75

#################
# Carbon Output
#################

pdf.fill_color "888888"
pdf.fill_rectangle([385,330], 160, 40)
pdf.fill_color "ffffff"
pdf.text_box "Total CO² output:",
    :width    => 100, :height => 20,
    :at       => [400, 325],
    :size     => 10
pdf.text_box "#{@project.total_carbon.to_i}kg",
    :width    => 100, :height => 20,
    :at       => [435, 310],
    :style    => :bold,
    :size     => 16

#################
# Chart Legend
#################

pdf.fill_color "000000"
pdf.text_box "Legend", 
    :width    => 100, :height => 20,
    :at       => [385,270],
    :style    => :bold

pdf.fill_color "FFBA4E"
pdf.fill_rectangle([385,250], 10, 15)
pdf.fill_color "000000"
pdf.text_box "Deliveries - #{two_decimal_place_float(@project.deliveries_carbon)}kg", 
    :width    => 145, :height => 20,
    :at       => [400,246]

pdf.fill_color "9A5AAB"
pdf.fill_rectangle([385,232], 10, 15)
pdf.fill_color "000000"
pdf.text_box "Materials - #{two_decimal_place_float(@project.materials_carbon)}kg", 
    :width    => 145, :height => 20,
    :at       => [400,228]

pdf.fill_color "5694ED"
pdf.fill_rectangle([385,214], 10, 15)
pdf.fill_color "000000"
pdf.text_box "Waste - #{two_decimal_place_float(@project.waste_management_carbon)}kg", 
    :width    => 145, :height => 20,
    :at       => [400,210]
    
pdf.fill_color "CD3A3D"
pdf.fill_rectangle([385,196], 10, 15)
pdf.fill_color "000000"
pdf.text_box "Energy - #{two_decimal_place_float(@project.energy_consumption_carbon)}kg", 
    :width    => 145, :height => 20,
    :at       => [400,192]
    
pdf.fill_color "86CE66"
pdf.fill_rectangle([385,178], 10, 15)
pdf.fill_color "000000"
pdf.text_box "Commuting - #{two_decimal_place_float(@project.commutes_carbon)}kg", 
    :width    => 145, :height => 20,
    :at       => [400,174]
    
#################
# Deliveries
#################
pdf.move_down 200

pdf.fill_color "FFBA4E"
pdf.text "Deliveries: #{delivery_carbon_percentage(@project)}%", :style => :bold, :size => 16
pdf.fill_color "000000"
pdf.table @project.deliveries.reverse.map {|d| [d.name, d.amee_category.name, "#{d.amount} #{units_name_from_amee_unit(d)}", "#{d.carbon_output_cache.round(2)} kg"]},
  :headers => ['Delivery Name', 'Delivery Mode', 'Distance', 'Emissions'],
  :border_style => :grid,
  :border_color => '999999',
  :header_color => 'FFBA4E',
  :header_text_color  => "ffffff",
  :vertical_padding => 2,
  :horizontal_padding => 3,
  :column_widths => {0 => 200, 1 => 180, 2 => 80, 3 => 80}
  
#################
# Materials
#################
pdf.move_down 20

pdf.fill_color "9A5AAB"
pdf.text "Materials: #{materials_carbon_percentage(@project)}%", :style => :bold, :size => 16
pdf.fill_color "000000"
pdf.table @project.materials.reverse.map {|m| [m.name, m.amee_category.name, "#{m.amount} #{units_name_from_amee_unit(m)}", "#{m.carbon_output_cache.round(2)} kg"]},
:headers => ['Material Name', 'Material Type', 'Weight', 'Emissions'],
:border_style => :grid,
:border_color => '999999',
:header_color => '9A5AAB',
:header_text_color  => "ffffff",
:vertical_padding => 2,
:horizontal_padding => 3,
:column_widths => {0 => 200, 1 => 180, 2 => 80, 3 => 80}

##################
# Waste Management
##################
pdf.move_down 20

pdf.fill_color "5694ED"
pdf.text "Waste Management: #{waste_management_carbon_percentage(@project)}%", :style => :bold, :size => 16
pdf.fill_color "000000"
pdf.table @project.wastes.reverse.map {|w| [w.name, "#{w.amee_category.name} #{'(' + w.waste_method.capitalize + ')' if w.waste_method}", "#{w.amount} #{units_name_from_amee_unit(w)}", "#{w.carbon_output_cache.round(2)} kg"]},
:headers => ['Waste Name', 'Type (and disposal method)', 'Weight', 'Emissions'],
:border_style => :grid,
:border_color => '999999',
:header_color => '5694ED',
:header_text_color  => "ffffff",
:vertical_padding => 2,
:horizontal_padding => 3,
:column_widths => {0 => 200, 1 => 180, 2 => 80, 3 => 80}

####################
# Energy Consumption
####################
pdf.move_down 20

pdf.fill_color "CD3A3D"
pdf.text "Energy Consumption: #{energy_consumption_carbon_percentage(@project)}%", :style => :bold, :size => 16
pdf.fill_color "000000"
pdf.table @project.energy_consumptions.reverse.map {|c| [c.name, c.amee_category.name, "#{c.amount} #{units_name_from_amee_unit(c)}", "#{c.carbon_output_cache.round(2)} kg"]},
:headers => ['Energy Consumption Name', 'Type', 'Amount', 'Emissions'],
:border_style => :grid,
:border_color => '999999',
:header_color => 'CD3A3D',
:header_text_color  => "ffffff",
:vertical_padding => 2,
:horizontal_padding => 3,
:column_widths => {0 => 200, 1 => 180, 2 => 80, 3 => 80}

####################
# Commuting
####################
pdf.move_down 20

pdf.fill_color "86CE66"
pdf.text "Commuting: #{commutes_carbon_percentage(@project)}%", :style => :bold, :size => 16
pdf.fill_color "000000"
pdf.table @project.commutes.reverse.map {|c| [c.name, c.amee_category.name, "#{c.amount} #{units_name_from_amee_unit(c)}", "#{c.carbon_output_cache.round(2)} kg"]},
:headers => ['Commute Name', 'Mode of Transport', 'Distance', 'Emissions'],
:border_style => :grid,
:border_color => '999999',
:header_color => '86CE66',
:header_text_color  => "ffffff",
:vertical_padding => 2,
:horizontal_padding => 3,
:column_widths => {0 => 200, 1 => 180, 2 => 80, 3 => 80}

####################
# Footer
####################
pdf.move_down 50
pdf.text "End of Report", :align => :center