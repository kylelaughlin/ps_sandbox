class PlansController < ApplicationController

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = CreatePlan.new(plan_params).call
    if @plan.errors.any?
      flash.now[:alert] = "Plan not created"
      render :new
    else
      redirect_to plans_path, notice: "Plan created."
    end
  end

  def show

  end

  def plan_billed
    puts params
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :frequency, :amount)
  end

end
