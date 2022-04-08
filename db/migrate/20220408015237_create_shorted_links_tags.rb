class CreateShortedLinksTags < ActiveRecord::Migration[6.1]
  def change
    create_table :shorted_links_tags do |t|
      t.references :shorted_url
      t.references :user_link_tag
    end

    add_index :shorted_links_tags, [:shorted_url_id, :user_link_tag_id]
  end
end
