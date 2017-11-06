class YelpQuery
	CLIENT_ID = "ivN84k_i8ZLkyvZxYiZjpQ"
	CLIENT_SECRET = "vVuS65bzOtzbtDHwFJRZiOuIsiNUambpuvenqk9RwKoqZajkbqXqPQg0wdC4Mpv5"

	API_HOST = "https://api.yelp.com"
	SEARCH_PATH = "/v3/businesses/search"
	BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
	TOKEN_PATH = "/oauth2/token"
	GRANT_TYPE = "client_credentials"

	SEARCH_LIMIT = 10

	attr_reader :token,
		:name,
		:location,
		:business,
		:nearby_term,
		:nearby

	def initialize(token:, name:, location:, nearby_term:)
		@token = token
		@name = name
		@location = location
		@business = search(term: name, location: location)["businesses"].first
		@nearby_term = nearby_term
		@nearby = search(
			term: nearby_term,
			radius: miles_to_meters(10),
			latitude: business.dig("coordinates", "latitude"),
			longitude: business.dig("coordinates", "longitude")
		)["businesses"]
	end

	def search(**params)
		url = "#{API_HOST}#{SEARCH_PATH}"
	  params = {
	    limit: SEARCH_LIMIT
	  }.merge(params)

		puts params
	  response = HTTP.auth(token).get(url, params: params)
	  response.parse
	end

	private

	def miles_to_meters(miles)
		miles * 1609
	end
end
