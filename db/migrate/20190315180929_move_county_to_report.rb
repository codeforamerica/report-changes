class MoveCountyToReport < ActiveRecord::Migration[5.2]
  class Report < ActiveRecord::Base
    has_one :navigator
  end

  class Navigator < ActiveRecord::Base
    belongs_to :report
  end

  def up
    add_column :reports, :county, :string

    Navigator.all.each do |navigator|
      navigator.report.update(county: navigator.county)
    end

    remove_column :navigators, :county
  end

  def down
    add_column :navigators, :county, :string

    Report.all.each do |report|
      report.navigator.update(county: report.county)
    end

    remove_column :reports, :county
  end
end
