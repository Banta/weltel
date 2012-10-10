# -*- encoding : utf-8 -*-
require "spec_helper"

describe Weltel::Patient do
	#
	context "validations" do
		subject { create(:patient) }
		it { should validate_presence_of(:user_name) }
		it { should ensure_length_of(:user_name).is_at_least(2) }
		it { should ensure_length_of(:user_name).is_at_most(32) }
		it { should ensure_length_of(:study_number).is_at_most(32) }
		#it { should ensure_length_of(:contact_phone_number).is_equal_to(10) }
	end

	#
	context "associations" do
		subject { create(:patient) }
		it { should have_one(:subscriber) }
		it { should belong_to(:clinic) }
		it { should have_many(:records).dependent(:destroy) }
		it { should have_many(:states).through(:records) }
	end

	#
	context "methods" do

		context "class methods" do
			subject { Weltel::Patient }

			#
			it "finds active patients" do
				expected = create(:patient)
				create(:patient, :active => false)
				patients = subject.active
				patients.count.should == 1
				patients[0].should == expected
			end

			#
			it "searches all patients when searching for blank" do
				expected = create(:patient)
				patients = subject.search(nil)
				patients.count.should == 1
				patients[0].should == expected
			end

			#
			it "searches patients with matching user name" do
				search = "test"
				create(:patient)
				expected = create(:patient, :user_name => search)
				patients = subject.search(search[1..2])
				patients.count.should == 1
				patients[0].should == expected
			end

			#
			it "searches patients with matching study number" do
				search = "test"
				create(:patient)
				expected = create(:patient, :study_number => search)

				patients = subject.search(search[1..2])

				patients.count.should == 1
				patients[0].should == expected
			end

			#
			it "filters by clinic" do
				create(:patient)
				create(:patient)
				expected = create(:patient)

				c = Weltel::Clinic.table_name
				patients = subject.joins(:clinic).filtered_by("#{c}.id", expected.clinic.id)

				patients.count.should == 1
				patients[0].should == expected
			end

			#
			it "sorts by attribute" do
				c = create(:patient, :user_name => "CC")
				a = create(:patient, :user_name => "AA")
				b = create(:patient, :user_name => "BB")

				patients = subject.sorted_by(:user_name, :asc)

				patients.count.should == 3
				patients.should == [a, b, c]
			end

			#
			it "sorts by subscriber phone number" do
				a = create(:subscriber, :phone_number => "2222222222").patient
				c = create(:subscriber, :phone_number => "4444444444").patient
				b = create(:subscriber, :phone_number => "3333333333").patient

				s = Sms::Subscriber.table_name
				patients = subject.joins(:subscriber).sorted_by("#{s}.phone_number", :desc)

				patients.count.should == 3
				patients.should == [c, b, a]
			end

			#
			it "sorts by clinic name" do
				b = create(:patient, :clinic => create(:clinic, :name => "BB"))
				c = create(:patient, :clinic => create(:clinic, :name => "CC"))
				a = create(:patient, :clinic => create(:clinic, :name => "AA"))

				c = Weltel::Clinic.table_name
				patients = subject.joins(:clinic).sorted_by("#{c}.name", :asc)

				patients.count.should == 3
				patients.should == [a, b, c]
			end

			it "filters by state" do
				create(:patient)
				subject.with_state(:unknown).count
			end

			it "filters by active record" do
				create(:patient)
				subject.with_active_record.count
			end

			it "filters by no active record" do
				create(:patient)
				subject.without_active_record.count
			end

			it "filters by no active record created before" do
				create(:patient)
				subject.without_active_record_created_on(Date.today).count
			end
		end
	end
end
