class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @questions = @user.answered_questions.uniq
  end

  def edit
    
  end

  def update
    current_user.update(update_params)
  end

  private
  def update_params
    # params.require(:user) => user以下の情報をパラメータから受け取る、余計な情報は受け取らない
    params.require(:user).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :avatar)
  end

end


#uniqメソッド
# 配列の中の重複する要素を取り除いた値を返してくれるメソッドです。
# fruits = ["apple", "orange", "apple", "banana", "banana"]
# p fruits.uniq

# =>["apple", "orange", "banana"]

