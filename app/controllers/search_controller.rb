class SearchController < ApplicationController
  def search
    @results = Search.search_selection(params[:query], params[:model])
  end
end