class User < ApplicationRecord
  has_secure_password

  validates :role, inclusion: { in: %w(user admin) }
  validates :email, :password_digest, :role, :money, presence: true
  validates :email, uniqueness: true, format: /\A[a-z0-9\+\-_\.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :money, numericality: {:greater_than_or_equal_to => 0}

  after_create :generate_apitoken

  has_many :bets
  has_many :account_statements


  private

  def generate_apitoken
    update!(:apitoken => SecureRandom.hex(10))
  end

end