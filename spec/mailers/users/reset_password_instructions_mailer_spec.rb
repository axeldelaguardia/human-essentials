RSpec.describe "User Reset Password Instructions", type: :mailer do
  describe "#send_reset_password_instructions" do
    context "user gets an email with instructions" do
      let(:user) { create(:user)}
      
      before do
				@time = Time.now.in_time_zone("America/New_York")
				allow(IpInfoService).to receive(:get_timezone).and_return("America/New_York")
        user.send_reset_password_instructions
      end
      
      let(:mail) { ActionMailer::Base.deliveries.last }
      
      it "sends an email with instructions" do
        expiration_time = (@time + 6.hour).strftime("%I:%M %p on %m/%d/%Y")

        expect(mail.body.encoded).to include("Someone has requested a link to change your password. You can do this through the link below.")
        expect(mail.body.encoded).to include("For security reasons these invites expire. This reset will expire at #{ expiration_time } Pacific Time or if a new password reset is triggered.")
        expect(mail.body.encoded).to include("If your invitation has expired message go hereand enter the email address to receive a new invite")
        expect(mail.body.encoded).to include("If you didn't request this, please ignore this email.")
        expect(mail.body.encoded).to include("Your password won't change until you access the link above and create a new one.")
      end
    end
  end
end