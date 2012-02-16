class CategoriesController < ApplicationController
  before_filter :fetch_group 

  def new
    @category = @group.categories.new
    respond_to do |f|
      f.html
    end
  end

  def create
    @category = @group.categories.new params[:category]
    @group.add_category(@category)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [@group, @category], notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

  end
end
