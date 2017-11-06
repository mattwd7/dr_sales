class YelpController < ApplicationController
	def index
	end

	def search
		yelp = YelpQuery.new(
			token: bearer_token,
			name: params[:name],
			location: params[:location],
			nearby_term: params[:nearby_term]
		)

		@yelp = YelpPresenter.new(yelp)
	end

	private

	def bearer_token
		return session[:bearer_token] if @bearer_token

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