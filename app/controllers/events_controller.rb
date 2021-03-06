class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :require_user, only: %i[new create edit update destroy]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @events = Event.all
  end

  def show; end

  def new
    @event = current_user.events.new
    @event.build_address
  end

  def edit
    @event.build_address
  end

  def create
    @event = current_user.events.new(event_params)
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
    flash[:alert] = "Event was successfully deleted!"
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :user_id, :image,
                                  address_attributes: %i[city street
                                                         house_number zip_code])
  end
end
