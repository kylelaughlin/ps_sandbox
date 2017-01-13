class SubscribeCustomer

  def initialize(user, params)
    @user = user
    @plan = Plan.find(params[:plan_id])
  end

  def call
    payment_spring_response = create_payment_spring_subscription
    puts payment_spring_response
    if payment_spring_response["errors"].present?
      add_payment_spring_errors_to_customer payment_spring_response
    end
    @user
  end

  private

  def add_payment_spring_errors_to_customer response
    response["errors"].each do |e|
      @user.errors.add(e["field"],e["message"])
    end
  end

  def create_payment_spring_subscription
    c = Curl::Easy.new
    c.url = "https://api.paymentspring.com/api/v1/plans/#{@plan.payment_spring_id}/subscription/#{@user.customer_id}"
    c.http_auth_types = :basic
    c.username = ENV["PAYMENTSPRING_SECRET_KEY"]
    c.password = ''
    c.http_post(Curl::PostField.content('ends_after', set_ends_after),
                Curl::PostField.content('bill_immediately', 'true'))
    JSON.parse(c.body_str)
  end

  def set_ends_after
     expire_date = Date.today + 7.days
     expire-date.strftime("%Y-%m-%d")
  end

end
