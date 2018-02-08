class EventsController < ApplicationController
  before_action(:set_event, only: [:show, :edit, :update, :destroy])
  
  def index
    @events = Event.all
  end

  def show; end
  
  def new
    @event = Event.new
  end
  
  # def edit; end
    
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:info] = "New event was created!"
      redirect_to events_path
    else
      render "new"
    end
  end
  

  private
  
  def set_event
    @event = Event.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:name)
  end
end
