Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_payload do |controller|
    {
      report_id: controller.try(:current_report).try(:id),
      admin_user_email: controller.try(:current_admin_user).try(:email),
    }
  end
end
