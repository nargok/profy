class User < ActiveRecord::Base
  
  #accessor
  attr_accessor :group_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable,
         authentication_keys: [:email, :group_key]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100"}
  validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/jpeg", "image/png"]

  #association
  belongs_to :group
  has_many :questions, ->{order("created_at DESC")}
  has_many :answers, ->{order("updated_at DESC")}
  has_many :answered_questions, through: :answers, source: :question

  #validation
  before_validation :group_key_to_id, if: :has_group_key?

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    group_key = conditions.delete(:group_key)
    group_id = Group.where(key: group_key).first
    email = conditions.delete(:email)

    # devise認証を、複数項目に対応させる
    if group_id && email
      where(conditions).where(["group_id = :group_id AND email = :email",
       { group_id: group_id, email: email}]).first
    elsif conditions.has_key?(:confirmation_token)
      where(conditions).first
    else
      false
    end
  end

  def name
    "#{family_name} #{first_name}"
  end

  def name_kana
    "#{family_name_kana} #{first_name_kana}"
  end

  def full_profile?
    #姓名、カナ、画像が設定されていないとfalseを返す
    # カラム名 + ?は値がない時にfalseを返すActiverecordのmethod
    # present? methodでも代用可
    avatar?           &&
    family_name?      &&
    first_name?       &&
    family_name_kana? &&
    first_name_kana?
  end

  private
  def has_group_key?
    group_key.present?
  end

  def group_key_to_id
    group = Group.where(key: group_key).first_or_create
    self.group_id = group.id
  end
end

# has_many throughオプション
# has_manyのthroughオプションは、モデルに多対多の関連を定義するときに利用します。
# throughという名前のとおり、「〜を経由する」という意味です

# 他のhas_manyのオプション
# class_name
#   関連するモデルのクラス名を指定でき、関連名(photos_tags等、has_manyの直後に書くもの)と参照先のクラス名(PhotosTagのようなモデル名)を異なるものにできる。
# foreign_key
#  参照先を参照する外部キーの名前を指定できる（デフォルトは、参照先のモデル名_id）
# dependent
#  親モデルのデータを消したら関連するモデルのデータも連動して消したいときに使用します。destroyとdelete_allでひとつひとつ消していくか、一気に消すかを指定できる
# source
#   関連テーブルから先のモデルにアクセスするための(関連モデルから見た)関連名を指定できる
