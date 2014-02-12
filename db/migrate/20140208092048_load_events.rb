class LoadEvents < ActiveRecord::Migration
  def up
  	drinks = Event.new(
  		:title => "Drinks", 
  		:description => "Kick back and relax!", 
  		:date => "02/16/2014",
  		:time => "09:30 am",
  		:place => "Nola",
  		:address => "",
  		:creator => 1)
  	drinks.save(:validate => false)

  	run = Event.new(
  		:title => "Run",
  		:description => "Jog the dish!",
  		:date => "02/28/2014",
  		:time => "08:00 am",
  		:place => "Lake Lag",
  		:address => "",
  		:creator => 1)
  	run.save(:validate => false)

  	movie = Event.new(
  		:title => "Movie Time!",
  		:description => "Let's catch \"The Butler\"",
  		:date => "02/20/2014",
  		:time => "09:30 pm",
  		:place => "Century 12 Redwood City",
  		:address => "",
  		:creator => 1)
  	movie.save(:validate => false)

  	party = Event.new(
  		:title => "Themed Party!",
  		:description => "Mario Party! Dress and destress!",
  		:date => "02/19/2014",
  		:time => "11:00 pm",
  		:place => "Mars",
  		:address => "",
  		:creator => 2)
  	party.save(:validate => false)

  	pset = Event.new(
  		:title => "Math 51 Pset",
  		:description => "Starting the p-set early!",
  		:date => "02/24/14",
  		:time => "04:00 pm",
  		:place => "my room",
  		:address => "",
  		:creator => 2)
  	pset.save(:validate => false)

  	picnic = Event.new(
  		:title => "Picni Time!",
  		:description => "Time to enjoy the good weather and Spring!",
  		:date => "03/27/2014",
  		:time => "02:30 pm",
  		:place => "grass patch outside Green",
  		:address => "",
  		:creator => 2)
  	picnic.save(:validate => false)

  	bike_ride = Event.new(
  		:title => "Bike Ride",
  		:description => "Let's explore Old Pagemill Road!",
  		:date => "02/10/2014",
  		:time => "05:00 pm",
  		:place => "Start at Roble",
  		:address => "374 Stata Teresa Ave, Stanford, CA",
  		:creator => 3)
  	bike_ride.save(:validate => false)

  	set_up_back_end = Event.new(
  		:title => "Set Up Back End",
  		:description => "Gotta Get that code done!",
  		:date => "02/09/2014",
  		:time => "02:00 am",
  		:place => "My Room",
  		:address => "",
  		:creator => 3)
  	set_up_back_end.save(:validate => false)

  	eat = Event.new(
  		:title => "Eat Breakfast",
  		:description => "I\'ve got to stop waking up late!",
  		:date => "02/09/2014",
  		:time => "08:00 am",
  		:place => "Lag Dining",
  		:address => "",
  		:creator => 3)
  	eat.save(:validate => false)

  end

  def down
  	Event.delete_all
  end
end
