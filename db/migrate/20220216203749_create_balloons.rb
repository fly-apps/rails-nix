class CreateBalloons < ActiveRecord::Migration[7.0]
  def change
    create_table :balloons do |t|

      t.timestamps
    end
  end
end
