class CreateDecidimParticipativeActions < ActiveRecord::Migration[6.0]
  def change
    create_table :decidim_participative_actions do |t|
      t.string :recommendation
      t.string :category
      t.string :action
      t.string :resource
      t.integer :points
      t.boolean :completed
    end
  end
end
