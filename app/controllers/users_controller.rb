class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.plan_id
      @plan = Plan.find(current_user.plan_id)
    end
  end
end
