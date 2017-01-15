class SubscriptionsController < ApplicationController

  def new
    @plans = Plan.all
    @user = current_user
  end

  def create
    user = CreateCustomer.new(subscription_params, current_user).call
    if user.errors.any?
      flash.now[:alert] = "Subscription not completed."
      render :new
    else
      user = SubscribeCustomer.new(user, subscription_params).call
    end
    if user.errors.any?
      flash.now[:alert] = "Subscription not completed."
      render :new
    else
      redirect_to user_path(user), notice: "Subscription Created"
    end

  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id, :token_id)
  end

end
