class GoogleQuery < Query
	API_KEY = "AIzaSyBnIw_uVAdY_uzm3eSkRqgB-pCVY_tLA2I"

	API_HOST = "https://maps.googleapis.com"
	SEARCH_PATH = "/maps/api/place/textsearch/json"
	BUSINESS_PATH = "/maps/api/place/details/json"
	NEARBY_PATH = "/maps/api/place/nearbysearch/json"

	SEARCH_LIMIT = 10

	attr_reader :token,
		:name,
		:location,
		:business,
		:nearby_term,
		:nearby,
		:review_count

	def initialize(name:, location:, nearby_term:, review_count: nil)
		@token = token
		@name = name
		@location = location
		@nearby_term = nearby_term
		@review_count = review_count.to_i
		@business = business_details(
			placeid: business_place_id
		)
		@nearby = nearby_businesses(
			keyword: nearby_term,
	    location: "#{business.dig("geometry", "location", "lat")},#{business.dig('geometry', 'location', 'lng')}",
	    radius: miles_to_meters(10),
		).map do |biz|
			business_details(placeid: biz['place_id'])
		end
	end

	def business_details(**params)
		url = "#{API_HOST}#{BUSINESS_PATH}"
	  params = {
	    key: API_KEY,
	  }.merge(params)

	  response = HTTP.get(url, params: params)
	  response.parse["result"]
	end

	def business_place_id(**params)
		search_params = {
			query: "#{name}, #{location}"
		}.merge(params)
		
		search(search_params).first["place_id"]
	end

	def search(**params)
		url = "#{API_HOST}#{SEARCH_PATH}"
	  params = {
	    key: API_KEY
	  }.merge(params)

	  response = HTTP.get(url, params: params)
	  response.parse["results"]
	end

	def nearby_businesses(**params)
		url = "#{API_HOST}#{NEARBY_PATH}"
	  params = {
	    key: API_KEY,
	  }.merge(params)

	  response = HTTP.get(url, params: params)
	  response.parse["results"].first(10)
	end
end
