class YelpPresenter
	attr_reader :business, :nearby

	def initialize(yelp_search)
		@business = yelp_search.business
		@nearby = yelp_search.nearby
	end

	def business_name
		business["name"]
	end

	def rating
		business["rating"]
	end

	def review_count
		business["review_count"]
	end

	def one_star_ratings_until_dropping_half_star
		target = rating - 0.5
		required_ratings_of_value_to_hit_target(1, rating - 0.5)
	end

	def five_star_ratings_until_five_stars
		target = rating + 0.5

		required_ratings_of_value_to_hit_target(6, 6)
	end

	def required_ratings_of_value_to_hit_target(value, target)
		target = (target > rating) ? target - 0.25 : target + 0.24

		count = (review_count * (rating - target)) / (target - value)
		count.ceil
	end

	# def years_on_yelp
	# def reviews_per_year
end