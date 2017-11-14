class GooglePresenter < SearchResultsPresenter
	attr_reader :business, :nearby

	def initialize(google_query)
		@business = google_query.business
		@nearby = google_query.nearby
		@review_count = google_query.review_count
	end

	def business_name
		business["name"]
	end

	def business_address
		businesses["formatted_address"].split(", ")
	end

	def rating
		business["rating"]
	end

	def review_count
		@review_count
	end

	def nearby_sorted
		nearby.sort_by do |a|
			a["rating"].to_i
		end.reverse
	end
end