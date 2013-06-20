class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :ip
      t.string :adminuser
      t.string :rootdir
      t.string :status
      t.integer :priority

      t.timestamps
    end
  end
end
