class StaticPagesController < ApplicationController
  def home
	@app_name =  Rails.root.to_s.scan(/[a-zA-z0-9]+$/).first
  end
end
