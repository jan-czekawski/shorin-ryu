class EventsController < ApplicationController
  before_action :set_event, except: [:index]
  
  def index
    @events = Event.all
  end
  
  def show; end
    
  def set_event
    @event = Event.find(params[:id])
  end
end
