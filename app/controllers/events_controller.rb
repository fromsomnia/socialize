class EventsController < ApplicationController
  def index
  	if params[:id].present? then
  		@events = Event.find(:all, :conditions => "id = #{params[:id]}")
  	else
  		@events = Event.all()
  	end
  end
end
