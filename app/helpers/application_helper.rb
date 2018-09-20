module ApplicationHelper
  def formatted_phone_number(phone)
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}" if phone
  end
end
