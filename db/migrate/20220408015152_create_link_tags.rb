class CreateLinkTags < ActiveRecord::Migration[6.1]
  def change
    create_table :link_tags do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
  end
end
