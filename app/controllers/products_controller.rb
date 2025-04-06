class ProductsController < ApplicationController
    skip_before_action :protect_pages, only: [:index, :show]
    def index
        @categories = Category.order(name: :asc).load_async
        # @products = Product.all.with_attached_photo
        # if params[:category_id]
        #     @products = @products.where(category_id: params[:category_id])
        # end
        # if params[:min_price].present?
        #     @products = @products.where('price >=?', params[:min_price])
        # end
        # if params[:max_price].present?
        #     @products = @products.where('price <=?', params[:max_price])
        # end
        # if params[:query_text].present?
        #     @products = @products.search_full_text(params[:query_text])
        # end
        # order_by = Product::ORDER_BY.fetch(params[:order_by]&.to_sym, Product::ORDER_BY[:newest])
        # @products = @products.order(order_by)
        params[:page] = 1 if params[:page].to_i < 1
        @pagy, @products = pagy_countless(FindProducts.new.call(params).load_async, items:12)
    end
    def new
        @product = Product.new
    end
    def show
        product
    end
    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to products_path, notice: t('.created')
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        authorize! product
    end
    
    def update
        authorize! product
        if product.update(product_params)
            redirect_to products_path, notice: t('.updated')
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        authorize! product
        product.destroy
        redirect_to products_path, notice: t('.destroyed'), status: :see_other
    end

    private
    def product_params
        params.require(:product).permit(:title, :description, :price, :photo, :category_id)
    end

    def product_params_index
        params.permit(:category_id, :min_price, :max_price, :query_text, :order_by)
    end
    def product
        @product = Product.find(params[:id])
    end
end