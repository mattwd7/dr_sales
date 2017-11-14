class CreateSearchResults < ActiveRecord::Migration[5.1]
  def change
    create_table :search_results do |t|
    	t.string :slug
    	t.text :results

    	t.timestamps
    end
  end
end