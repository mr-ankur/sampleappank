class ApplicationController < ActionController::Base
	def hello
		render html:"Hello from My sample app"
	end
end
