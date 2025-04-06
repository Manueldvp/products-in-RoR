class CategoriesController < ApplicationController
  before_action :authorize!
  # GET /categories or /categories.json
  def index
    authorize!
    @categories = Category.all.order(name: :asc)
  end

  
  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    category
  end

  def create
    @category = Category.new(category_params)

      if @category.save
       redirect_to categories_url, notice: "Category was successfully created." 
      else
         render :new, status: :unprocessable_entity 
      end
  end


  def update
    if category.update(category_params)
      redirect_to categories_url, notice: "Category was successfully created." 
    else
        render :new, status: :unprocessable_entity 
    end
    
  end

  def destroy
    category.destroy!
    redirect_to categories_path, status: :see_other, notice: "Category was successfully destroyed." 
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def category
      @category = Category.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name)
    end
end