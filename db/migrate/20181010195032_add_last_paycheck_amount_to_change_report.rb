class AddLastPaycheckAmountToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :last_paycheck_amount, :decimal, scale: 2, precision: 8
  end
end
