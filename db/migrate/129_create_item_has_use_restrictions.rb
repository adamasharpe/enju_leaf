class CreateItemHasUseRestrictions < ActiveRecord::Migration
  def change
    create_table :item_has_use_restrictions do |t|
      t.integer :item_id, :null => false
      t.integer :use_restriction_id, :null => false

      t.timestamps
    end
    add_index :item_has_use_restrictions, :item_id
    add_index :item_has_use_restrictions, :use_restriction_id
  end
end
