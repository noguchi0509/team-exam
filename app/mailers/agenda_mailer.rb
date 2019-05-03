class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_delete_mail(email,agenda_name)
    @email = email
    @agenda_name = agenda_name
    mail to: @email, subject: 'アジェンダが削除されました'
  end
end
