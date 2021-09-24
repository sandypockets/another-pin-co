class Order < ApplicationRecord
  has_many :order_items

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :address_1, presence: true
  validates :country, presence: true

  accepts_nested_attributes_for :order_items

  def add_from_cart(cart)
    cart.order_items.all.each do |item|
      order_items.new(product: item.product, quantity: item.quantity)
    end
  end

  def save_and_charge
    if valid?
      Stripe.api_key = Rails.application.credentials[Rails.env.to_sym][:stripe_secret_key]
      Stripe::Charge.create(
        amount: total_price,
        currency: 'usd',
        source: stripe_token,
        description: "Order for #{email}"
      )
      save
    else
      false
    end
  end

  def total_price
    @total = 0
    order_items.each do |item|
      @total += item.product.price * item.quantity
    end

    @total
  end

end
