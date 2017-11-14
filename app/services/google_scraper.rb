class GoogleScraper
	attr_reader :browser, :nearby_term

	BASE_URL = "https://www.google.com/maps/search/"

	def initialize(name:, location:, nearby_term:)
		client = Selenium::WebDriver::Remote::Http::Default.new
		client.read_timeout = 10

		@browser = Watir::Browser.new :chrome, :http_client => client
		@nearby_term = nearby_term
		params = {
			api: 1,
			query: "#{name}, #{location}"
		}
		@browser.goto("#{BASE_URL}?#{params.to_param}")
	end

	def search_nearby
		browser
			.divs(class: "section-action-button-icon maps-sprite-pane-action-ic-searchnearby")
			.first
			.click

		browser.text_field.set(nearby_term)
		browser.buttons(id: "searchbox-searchbutton").first.click
		close_settings_tab
	end

	def business_data
		business_divs.map do |div|
			{
				name: business_name(div),
				rating: rating(div),
				review_count: review_count(div),
			}
		end
	end

	# private

	def close_settings_tab
		browser.windows.last.close if browser.windows.count > 1
	end

	def business_divs
		browser.divs(class: "section-result").to_a.first(10)
	end

	def business_name(business_div)
		business_div.h3s(class: "section-result-title").first.text
	end

	def rating(business_div)
		business_div.spans(class: "cards-rating-score").first.text
	end

	def review_count(business_div)
		business_div.spans(class: "section-result-num-ratings").first.text.match(/\d+/)[0]
	end
end