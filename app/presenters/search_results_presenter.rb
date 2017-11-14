class SearchResultsPresenter
	def one_star_impacts
		counts_until_impact = {}
		next_lowest_rating = rating - 0.5
		while next_lowest_rating >= 1
			counts_until_impact[next_lowest_rating] = required_ratings_of_value_to_hit_target(1, next_lowest_rating)
			next_lowest_rating -= 0.5
		end

		counts_until_impact
	end

	def five_star_impacts
		counts_until_impact = {}
		next_highest_rating = rating + 0.5
		while next_highest_rating <= 5.0
			counts_until_impact[next_highest_rating] = required_ratings_of_value_to_hit_target(5, next_highest_rating)
			next_highest_rating += 0.5
		end

		counts_until_impact
	end

	def required_ratings_of_value_to_hit_target(value, target)
		target = (target > rating) ? target - 0.25 : target + 0.24

		count = (review_count * (rating - target)) / (target - value)
		count.ceil
	end
end