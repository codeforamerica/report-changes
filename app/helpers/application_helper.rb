module ApplicationHelper
  def formatted_phone_number(phone)
    "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}" if phone
  end

  def wicked_blob_path(image)
    save_path = Rails.root.join("tmp", "#{image.id}_#{image.filename}")
    File.open(save_path, "wb") do |file|
      file << image.blob.download
    end
    save_path.to_s
  end
end
