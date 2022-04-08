class CreateUserLinkTags < ActiveRecord::Migration[6.1]
  def change
    create_table :user_link_tags do |t|
      t.string :name, null: false
      t.text :description

      t.references :user, index: true
      t.timestamps
    end
  end
end
