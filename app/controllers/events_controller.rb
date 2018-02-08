class EventsController < ApplicationController
  before_action(:set_event, except: [:index, :new])
  
  def index
    @events = Event.all
  end
  
  def new; end
  
  def show; end
    
  def set_event
    @event = Event.find(params[:id])
  end
end
