class MemberDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def phone_number
    decorate_phone_number(super)
  end

  def birthday
    super&.strftime("%D")
  end

  private

  def decorate_phone_number(phone_number)
    if phone_number.present?
      "#{phone_number[0..2]}-#{phone_number[3..5]}-#{phone_number[6..9]}"
    end
  end
end
