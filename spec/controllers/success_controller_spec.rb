require 'rails_helper'

RSpec.describe SuccessController do
  it_behaves_like "form controller", is_last_section: true
end