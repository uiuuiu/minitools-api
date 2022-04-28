class AddActiveToShortenedUrls < ActiveRecord::Migration[6.1]
  def change
    add_column :shortened_urls, :status, :integer, default: 0
    add_index :shortened_urls, :status
  end
end
