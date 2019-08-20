class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def self.find_or_create_from_auth_hash(auth)
    generated_password = rand(10_000, 99_999)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = "#{auth.info.first_name} #{auth.info.last_name}"
      user.email = auth.info.email
      user.password = generated_password
      user.save!
    end
    # SendPasswordToUserMailer.send_now(generated_password)
  end
end
