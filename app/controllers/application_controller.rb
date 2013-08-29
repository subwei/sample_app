class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This allows us to use the methods in sessions_helper. By default the helper
  # methods are only accessible by the views.
  include SessionsHelper
end
