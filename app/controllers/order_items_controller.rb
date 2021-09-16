class OrderItemsController < ApplicationController

  def create
    @product = Product.find(params[:product_id])
    @quantity = form_params[:quantity]
    @current_cart.order_items.create(product: @product, quantity: @quantity)

    flash[:success] = 'Added to cart!'

    redirect_to product_path(@product)
  end

  def update
    @product = Product.find(params[:product_id])
    @order_item = OrderItem.find(params[:id])
    @order_item.update(form_params)
    flash[:success] = 'Cart updated!'
    redirect_to product_path(@product)
  end

  def destroy
    @product = Product.find(params[:product_id])
    @order_item = OrderItem.find(params[:id])
    @order_item.delete

    flash[:success] = "Product removed from cart"

    redirect_to cart_path
  end

  def form_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

end
