class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper1,UsersHelper
  helper SessionsHelper1,UsersHelper          #because helper methods are not available in view by default...u have to include them like this...i dunno why....previoously in my 1st project they were available
end
