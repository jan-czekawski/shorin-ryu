class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_class, except: [:home]
  before_action :set_flash, only: [:home]
  before_action :set_cart_for_user

  include UserRequirements

  def home; end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[login image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[login image])
  end

  private

  def set_class
    @body_class = "container-fluid"
  end

  def set_flash
    @flash_row = "row justify-content-center"
    @flash_col = "col-10 absolute"
  end
  
  def set_cart_for_user
    return nil unless user_signed_in?
    @cart ||= current_user.cart? ? current_user.cart : current_user.create_cart
    # @cart.user.create_checkout
  end
end
