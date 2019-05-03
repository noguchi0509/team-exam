class TransferAuthorityMailer < ApplicationMailer

 def transfer_done_mail(email,team_name)
    @email = email
    @team_name = team_name
    mail to: @email, subject: 'リーダー権限が移譲されました'
  end
end
