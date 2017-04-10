class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_one :feed_content, as: :content, dependent: :destroy

  #callback
  after_create :create_feed_content
  after_update :update_feed_content

  #validation
  validates_presence_of :user_id, :text

  private
  def create_feed_content
    self.feed_content = FeedContent.create(group_id: question.group_id, updated_at: updated_at)
  end

  def update_feed_content
    self.feed_content.update(updated_at: updated_at)
  end
end

# 8行目
# タイムラインを作成した際に設定したのと同様にafter_updateと、回答に更新が加えられたタイミングでもコールバックを設定しています。

# 19行目
# ここでのupdated_atは「self.updated_at」を省略した形で、コールバックが働いた際のレシーバーである回答の更新日時を表します。


