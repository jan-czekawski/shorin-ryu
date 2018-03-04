module HandleErrors
  def display_errors
    error = "There is an error. "
    errors.full_messages.each { |msg| error << msg + ". " }
    error
  end
end