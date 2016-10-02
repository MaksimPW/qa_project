class SearchController < ApplicationController
  def search
      @results = if params.has_key?(:query)
                 model.search ThinkingSphinx::Query.escape(params[:query])
               else
                 []
               end
  end

  private

  def model
    if params.has_key? 'model'
      if params[:model] == 'All'
        ThinkingSphinx
      else
        params[:model].constantize
      end
    else
      ThinkingSphinx
    end
  end
end