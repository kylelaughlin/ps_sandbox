class PlansController < ApplicationController

  def index

  end

  def new
    @plan = Plan.new
  end

  def create

  end

  def show

  end

  private

  def plan_params
    params.require(:plan).permit(:name, :frequency, :amount)
  end

end
