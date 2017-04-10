class AddContentToFeedContents < ActiveRecord::Migration
  def change
    add_column :feed_contents, :content_id, :integer
    remove_column :feed_contents, :contnt_id, :integer
  end
end

#テーブル変更のファイルをつくるコマンド
# rails g migration AddXXXX(column)ToXXX(class)
# rails g migration RemoveXXXX(column)FromXXX(class)