class CreatePatientRecordStates < ActiveRecord::Migration
  def change
    create_table(:weltel_patient_record_states) do |t|
    	t.references(:patient_record, :null => false)
    	t.references(:user, :null => false)
    	t.boolean(:initial, :null => false, :default => true)
      t.boolean(:active, :null => false, :default => true)
      t.string(:value, :null => false)
      t.datetime(:created_at, :null => false)
    end

		add_index(:weltel_patient_record_states, :patient_record_id)
		add_index(:weltel_patient_record_states, :user_id)
		add_index(:weltel_patient_record_states, :initial)
    add_index(:weltel_patient_record_states, :active)
  end
end
