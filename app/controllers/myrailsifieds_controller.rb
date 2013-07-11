class MyrailsifiedsController < ApplicationController

  def show


  end

  def show_selling_ads
    @classifieds = current_user.classifieds
  end


end
