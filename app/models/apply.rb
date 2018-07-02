class Apply
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :address, :phone_number

  validates :name,  length: { minimum: 3, :too_short => '名前を入力して下さい'}
  validates :email, length: { minimum: 3, :too_short => 'メールアドレスを入力して下さい'}

end
