# -*- encoding : utf-8 -*-
module Weltel
	class TasksController < ApplicationController
		respond_to(:html, :js)

		#
		def create_records
			# send reminders
			date = Date.today
			Weltel::Factory.service.create_records(date)
			render(:text => "OK")
		end

		#
		def update_records
			date = Date.today
			Weltel::Factory.service.update_records(date)
			render(:text => "OK")
		end

		#
		def receive_responses
			# receive responses
			Weltel::Factory.responder.receive_responses
			render(:text => "OK")
		end
	end
end
