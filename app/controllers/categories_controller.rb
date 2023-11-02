class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  def new
    @category = Category.new    
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category successfully created"
      redirect_to categories_path
    else
      flash[:error] = "Something went wrong"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    category
  end

  def update
    if category.update(category_params)
      flash[:update] = "Category successfully updated"
      redirect_to categories_path
    else
      flash[:error] = "Something went wrong"
      render :edit, status: :unprocessable_entity
    end
  end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           

  def destroy
    category.products.update_all(category_id: nil)
    category.destroy
    flash[:delete] = "category removed succesfully"
    redirect_to categories_path, status: :see_other
  end

    
  
  
  
  def category
    @category = Category.find(params[:id])
  end
  

  private
  def category_params
    params.require(:category).permit(:name, :description)
  end
  
end
