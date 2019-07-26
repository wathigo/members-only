class User < ApplicationRecord
  has_many      :posts
  before_save   :downcase_email
  before_create :generate_token
  validates :name, presence: true, length: { minimum: 4,
                                             maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def generate_token
    token = SecureRandom.urlsafe_base64
    self.remember_token = Digest::SHA1.hexdigest(token.to_s)
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      email.downcase!
    end
end
