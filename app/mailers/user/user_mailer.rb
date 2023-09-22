class User::UserMailer < Devise::Mailer
  helper  :application # helpers defined within `application_helper`
  include Devise::Controllers::UrlHelpers # eg. `confirmation_url`

  def headers_for(action, opts)
    subject = action
    if resource.unconfirmed_email.present?
      subject = :confirm_email
    end
    headers = {
      subject: subject_for(subject),
      to: resource.email,
      from: mailer_sender(devise_mapping),
      reply_to: mailer_reply_to(devise_mapping),
      template_path: template_paths,
      template_name: action
    }.merge(opts)

    @email = headers[:to]
    headers
  end
end