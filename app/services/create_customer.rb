class CreateCustomer

  def initialize(params, current_user)
    @params = params
    @user = current_user
  end

  def call
    payment_spring_response = create_payment_spring_customer
    if payment_spring_response["errors"].present?
      add_payment_spring_errors_to_customer payment_spring_response
    else
      update_user_locally payment_spring_response["id"]
    end
    @user
  end

  private

  def update_user_locally customer_id
    @user.update(customer_id: customer_id, plan_id: @params[:plan_id])
  end

  def add_payment_spring_errors_to_customer response
    response["errors"].each do |e|
      @user.errors.add(e["field"],e["message"])
    end
  end

  def create_payment_spring_customer
    c = Curl::Easy.new
    c.url = "https://api.paymentspring.com/api/v1/customers"
    c.http_auth_types = :basic
    c.username = ENV["PAYMENTSPRING_SECRET_KEY"]
    c.password = ''
    c.http_post(Curl::PostField.content('first_name', @user.first_name),
                Curl::PostField.content('last_name', @user.last_name),
                Curl::PostField.content('email', @user.email),
                Curl::PostField.content('token', @params[:token_id]))
    JSON.parse(c.body_str)
  end

end
