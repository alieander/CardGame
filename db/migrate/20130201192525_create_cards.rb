class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.string :first
      t.string :last
      t.string :url
      t.string :img_url

      t.timestamps
    end
  end
end
