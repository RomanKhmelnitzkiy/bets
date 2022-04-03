class User < ApplicationRecord
  
  validates :role, inclusion: { in: %w(user admin) }
  validates :email, :password, :role, :money, presence: true
  validates :email, uniqueness: true
  validates :money, numericality: {:greater_than_or_equal_to => 0}
  
  after_create :generate_apitoken

  has_many :bets
  has_many :account_statements

  private

  def generate_apitoken
    update!(:apitoken => SecureRandom.hex(10))
  end


end