class StaticPagesController < ApplicationController
  skip_before_action :require_login

  def top
    if logged_in?
      redirect_to posts_path
    end
  end

  def privacy_policy; end

  def terms; end
end
