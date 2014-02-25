class CategoriesController < ApplicationController
  before_action :find_category, except: [:index, :new, :create ]

  def index
    @categories = Category.all
  end

  def show

  end

  private
  def find_category
    @category = Category.find_by_slug(params[:id]) if params[:id]
  end
end
