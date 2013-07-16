class PagesController < ApplicationController
  def home
    @categories = Category.where(parent_id: nil)
  end
end