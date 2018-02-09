class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:destroy]
  before_action :require_admin, only: [:destroy]
  
  def index
    @events = Event.all
  end

  def show; end
  
  def new
    @event = Event.new
  end
  
  def edit; end
    
  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:info] = "New event was created!"
      redirect_to events_path
    else
      render "new"
    end
  end
  
  def update
    if @event.update_attributes(event_params)
      flash[:info] = "Event was successfully updated!"
      redirect_to @event
    else
      render "edit"
    end
  end
  
  def destroy
    @event.destroy
    flash[:danger] = "Event was successfully deleted!"
    redirect_to events_path
  end
  
  private
  
  def set_event
    @event = Event.find(params[:id])
  end
  
  def event_params
    params.require(:event).permit(:name, address: [:city,
                                                   :street,
                                                   :flat_number,
                                                   :zip_code])
  end
  
  def require_user
    return if user_signed_in?
    flash[:alert] = "You must be logged in to do that!"
    redirect_to root_path
  end
  
  def require_admin
    return if current_user.admin?
    flash[:alert] = "You must be an admin to do that!"
    redirect_to root_path
  end
end
