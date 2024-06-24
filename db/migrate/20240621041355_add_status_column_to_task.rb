class AddStatusColumnToTask < ActiveRecord::Migration[6.1]
  def change
    #テーブル名, カラム名、データ型　あとはオプション
    add_column :tasks,:deadline_on, :date, foreign_key: true, null: false
    add_column :tasks,:priority, :integer, foreign_key: true, null: false
    add_column :tasks,:status, :integer, foreign_key: true, null: false
  end
end
