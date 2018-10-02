class FormsController < ApplicationController
  layout "form"

  before_action :ensure_change_report_present, only: %i[edit update]

  def edit
    @form = form_class.from_change_report(current_change_report)
  end

  def update
    @form = form_class.new(current_change_report, form_params)
    if @form.valid?
      @form.save
      update_session
      send_mixpanel_event
      redirect_to(next_path)
    else
      send_mixpanel_validation_errors
      render :edit
    end
  end

  def current_path(params = nil)
    screen_path(self.class.to_param, params)
  end

  def next_path(params = {})
    next_step = form_navigation.next
    if next_step
      screen_path(next_step.to_param, params)
    end
  end

  def self.show?(change_report)
    show_rule_sets(change_report).all?
  end

  def current_change_report
    ChangeReport.find_by(id: session[:current_change_report_id])
  end

  private

  delegate :form_class, to: :class

  # Override in subclasses

  def update_session; end

  # Don't override in subclasses

  def ensure_change_report_present
    if current_change_report.blank?
      redirect_to root_path
    end
  end

  def form_params
    params.fetch(:form, {}).permit(*form_class.attribute_names)
  end

  def form_navigation
    @form_navigation ||= FormNavigation.new(self)
  end

  def send_mixpanel_event
    MixpanelService.instance.run(
      unique_id: current_change_report.id,
      event_name: @form.class.analytics_event_name,
      data: current_change_report.mixpanel_data,
    )
  end

  def send_mixpanel_validation_errors
    data = {
      screen: @form.class.analytics_event_name,
      errors: @form.errors.messages.keys,
    }

    if current_change_report.present?
      data.merge!(current_change_report.try(:mixpanel_data))
    end

    MixpanelService.instance.run(
      unique_id: current_change_report.try(:id),
      event_name: "validation_error",
      data: data,
    )
  end

  class << self
    def to_param
      controller_name.dasherize
    end

    def form_class
      (controller_name + "_form").classify.constantize
    end

    def show_rule_sets(_)
      [ShowRules.defaults_to_true]
    end
  end
end
