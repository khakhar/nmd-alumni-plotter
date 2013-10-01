class StudentInvite < ActiveRecord::Base
  belongs_to :student

  validates_presence_of   :name
  validates_uniqueness_of :token

  before_save :ensure_token

  private

  def ensure_token
    self.token ||= SecureRandom.hex(7)
  end
end
