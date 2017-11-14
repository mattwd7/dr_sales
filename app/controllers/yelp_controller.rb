class YelpController < ApplicationController
	def index
	end

	def search
		@yelp = YelpPresenter.new(yelp_query)
		@google = GooglePresenter.new(google_query)
	end

	private

	def yelp_results
		search_results =
			SearchResult.find_by_slug(search_results_slug("yelp")) ||
				SearchResult.create(
					slug: search_results_slug("yelp"),
					results: yelp_query
				)

		search_results.results
	end

	def yelp_query
		YelpQuery.new(
			token: bearer_token,
			name: params[:name],
			location: params[:location],
			nearby_term: params[:nearby_term]
		)
	end

	def google_query
		GoogleQuery.new(
			name: params[:name],
			location: params[:location],
			nearby_term: params[:nearby_term],
			review_count: params[:google_review_count]
		)
	end

	def search_results_slug(service_name)
		(service_name + params[:name] + params[:location])
			.scan(/\w+/)
			.join
			.downcase
	end

	def bearer_token
		return session[:bearer_token] if session[:bearer_token]

	  url = "#{YelpQuery::API_HOST}#{YelpQuery::TOKEN_PATH}"
	  params = {
	    client_id: YelpQuery::CLIENT_ID,
	    client_secret: YelpQuery::CLIENT_SECRET,
	    grant_type: YelpQuery::GRANT_TYPE
	  }

	  response = HTTP.post(url, params: params)
	  parsed = response.parse
	  session[:bearer_token] = "#{parsed['token_type']} #{parsed['access_token']}"
	end
end