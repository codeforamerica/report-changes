module FeatureHelper
  def proceed_with(submit_button_text, scroll_to_top: false, **opts)
    unless ENV["SKIP_ACCESSIBILITY_SPECS"] == "true"
      check_accessibility(scroll_to_top)
    end

    click_on submit_button_text, opts
  end

  private

  def check_accessibility(scroll_to_top)
    expect(page).to be_accessible

    if scroll_to_top
      page.execute_script "window.scrollTo(0,0)"
    end
  end
end
