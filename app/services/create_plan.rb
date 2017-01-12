class CreatePlan

  def initialize(plan_params)
    @plan_params = plan_params
    @plan = Plan.new(plan_params)
    @plan_params["callback_url"] = "#{ENV["APP_HOST"]}/plan_billed"
  end

  def call
    save_plan
  end

  private

  def save_plan
    if @plan.valid?
      send_plan_to_payment_spring
    end
    @plan
  end

  def send_plan_to_payment_spring
    result = response
    if result["errors"].present?
      add_payment_spring_errors_to_plan result
    else
      save_plan_locally result
    end
  end

  def save_plan_locally result
    @plan.payment_spring_id = result["id"]
    @plan.save
  end

  def add_payment_spring_errors_to_plan result
    response["errors"].each do |e|
      @plan.errors.add(e["field"],e["message"])
    end
  end

  def response
    c = Curl::Easy.new
    c.url = "https://api.paymentspring.com/api/v1/plans"
    c.http_auth_types = :basic
    c.username = ENV["PAYMENTSPRING_SECRET_KEY"]
    c.password = ''
    c.http_post(Curl::PostField.content('name', @plan_params[:name]),
                Curl::PostField.content('frequency', @plan_params[:frequency]), #@plan_params[:frequency]),
                Curl::PostField.content('amount', @plan_params[:amount]))
    JSON.parse(c.body_str)
  end


end
