# frozen_string_literal: true

class DropRegistryPackages < ActiveRecord::Migration[8.0]
  def change
    drop_table :registry_packages do |t|
      t.string :name, null: false
      t.string :version, null: false
      t.string :integrity, null: false
      t.string :shasum, null: false
      t.string :tarball, null: false
      t.text :package_data, null: false
      t.timestamps
      t.index %i[name version], unique: true
    end
  end
end
