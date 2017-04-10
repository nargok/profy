class Question < ActiveRecord::Base
  #association
  belongs_to :group
  belongs_to :user
  has_many :answers
  has_one :feed_content, as: :content, dependent: :destroy

  #validation
  validates_presence_of :text, :user_id, :group_id

  #call back
  after_create :create_feed_content


  def user_answer(user_id)
    Answer.find_by(user_id: user_id, question_id: id)
  end

  def answered?(user)
    # レシーバである質問に、現在ログインしているユーザーが既に回答している場合はtrueを、回答していない場合はfalseを返す
    #テーブル名を直接していしてよいのはなぜ？
    answers.exists?(user_id: user.id)
  end

  private
  def create_feed_content
    self.feed_content = FeedContent.create(group_id: group_id, updated_at: updated_at)
  end

end

# find_by method
# user_answerメソッド内部で使用しているfind_byメソッドは、検索条件に該当したレコードを一件だけ取得するメソッドです。
# findメソッドがidのカラムに対してのみ検索をかけられるのに対し、find_byメソッドは検索条件として複数のカラムを指定できるという特徴があります。
# 今回の例でいうとanswersテーブルから user_idカラムの値が、引数として渡されている「現在ログインしているユーザーのid」と一致しかつ、question_idカラムの値が「メソッドを呼び出した元の質問のid」と一致する回答を検索し、取得しています。

# なお「question_id: id」 の id という部分は、self.id の self を省略した形です。

# あるインスタンスメソッド内において、そのインスタンスを利用したインスタンス自身（これをレシーバと言います）を参照する際は self という形で呼び出すことが出来ます。しかしこのselfは省略することも可能なため、今回はメソッドを呼び出した質問の id を whereメソッド の引数に追加する際に「question_id: id」とだけ記述しています。