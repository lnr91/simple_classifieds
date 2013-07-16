class Admin::AdminController < ApplicationController

  layout 'admin'
  before_filter :signed_in_user
  before_filter :is_admin_user
  def home

  end
end
