class ProductsController < ApplicationController
    def index
        @categories = Category.order(name: :asc).load_async
        @products = Product.all.with_attached_photo
        if params[:category_id].present? 
            @products = @products.where(category_id: params[:category_id])
        end
        if params[:min_price].present? 
            @products = @products.where("precio >= ?",params[:min_price])
        end
        if params[:max_price].present? 
            @products = @products.where("precio <= ?",params[:max_price])
        end
        if params[:search].present? 
            @products = @products.search_full_text(params[:search])
        end

            order_by = {
                new: "created_at DESC",
                cheap: "precio ASC",
                pricey: "precio DESC"
        }.fetch(params[:order_by]&.to_sym, "created_at DESC")
        @products = @products.order(order_by).load_async
        @pagy, @products = pagy_countless(@products, items: 12)

    
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
          flash[:success] = "Product successfully created"
          redirect_to products_path
        else
          flash[:error] = "Something went wrong"
          render :new, status: :unprocessable_entity
        end
    end

    def edit
        product
        
    end

    def update
        if product.update(product_params)
          flash[:update] = "Product successfully update"
          redirect_to products_path
        else
          flash[:error] = "Something went wrong"
          render :new, status: :unprocessable_entity
        end
    end

    def destroy
        product.destroy
        flash[:delete] = "Product successfully removed"
        redirect_to products_path, status: :see_other
    end
    

    def product
        @product = Product.find(params[:id])
    end
    
    
    private
    def product_params
        params.require(:product).permit(:name, :description,:precio, :photo, :category_id)
    end
    
    
end
