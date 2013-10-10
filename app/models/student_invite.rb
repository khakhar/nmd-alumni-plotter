class StudentInvite < ActiveRecord::Base
  belongs_to :student

  validates_presence_of   :name
  validates_uniqueness_of :token

  before_save :ensure_token


  def filled_for!(student_id)
    self.update_attributes(student_id: student_id, token: SecureRandom.hex(10))
  end


  #NOTE data is a hash with email as key and {name: <value>, token: <value>} as value
  def self.send_invites(data)
    mailgun_url = "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v2/nmd.mailgun.org/messages"

    puts data.inspect

    params = {
      :from        => "noreply@nmd.mailgun.org",
      "h:Reply-To" => "jiggzz@gmail.com",
      :to          => data.keys,
      "recipient-variables" => JSON(data),
      :subject => "NMD Alumni Plotter data request",
      :text    => StudentInvite.mail_template
    }

    RestClient.post mailgun_url, params

    StudentInvite.where(email: data.keys).each do |student|
      student.update_attributes sent: true
    end
  end


  def self.mail_template
    SiteOption.find_by!(name: "invite_email_text").value
  end


  private

  def ensure_token
    self.token ||= SecureRandom.hex(10)
  end
end
