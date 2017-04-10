class TopController < ApplicationController
  def index
    @question = Question.new
    @feed_contents = current_user.group.feed_contents.includes(:content).page(params[:page]).per(5)
    @feed_contents_resource = @feed_contents.map(&:content)
    # @questions = current_user.group.questions
  end
end

# 4行目
# current_user.group.feed_contentsで、ログインユーザーの所属グループのfeed_contentsを全て取得しています。
# ここまでは通常のアソシエーションのみです。.includes(:content)に注目してください。これはポリモーフィック先のインスタンスを先読みすることでN+1問題が起きることを防止しています。
# ※先にincludeメソッドはモデル名を引数にとると説明しましたが、このようにポリモーフィック関連名を引数に取ることもできます。
# .includes(:content)は無くても動作に問題ないのですがポリモーフィック関連先を取得するたびにSQLが走り、パフォーマンス低下の原因となります。

# 5行目
# mapメソッドを利用してFeedContentクラスのインスタンス配列を、ポリモーフィック関連先のインスタンスの配列に変換しています。mapメソッドやeachメソッドなど、配列の中身を受け取り順番に処理するときは { |object| object.method } の代わりに (&:method) とシンプルに記述することができます。
# この時、4行目でポリモーフィック関連先のインスタンスは先読みしているためSQLが走ることはありません。