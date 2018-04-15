
require "openssl"

class User < ActiveRecord::Base
  ITERATIONS = 2000
  DIGEST = OpenSSL::Digest::SHA256.new

  #Зависимости - взаимодействие с другими моделями
  has_many :questions, dependent: :delete_all

  #Валидации - условия для того, чтобы полученные данные проверку прошли
  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates_length_of :username, maximum: 40
  validates_format_of :username, with: /\A[a-zA-Z0-9_]+\z/
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_presence_of :password, on: :create
  validates_confirmation_of :password

  attr_accessor :password

  #Коллбеки - то, что влияет на жизненный цикл модели(Можно деформировать полученные от пользователя данные)
  before_save :encrypt_password
  before_validation :username_downcase

  def username_downcase
    if self.username.present?
      username.downcase!
    else
      nil
    end
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(self.password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST)
      )
    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    if user.present? && user.password_hash == User.hash_to_string(OpenSSL::PKCS5.pbkdf2_hmac(password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST))
      user
    else
      nil
    end
  end

end