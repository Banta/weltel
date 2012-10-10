# -*- encoding : utf-8 -*-
require "spec_helper"

describe Weltel::PatientRecordState do
	context "validations" do
		subject { create(:patient_record_state) }

		it { should validate_presence_of(:user) }
	end

	#
	context "asscociations" do
		subject { create(:patient_record_state) }

		it { should belong_to(:record) }
		it { should belong_to(:user) }
	end

	context "methods" do
	end
end
