class CommissionsController < ApplicationController
@@search_commissions = {}
	def view
		@commission = Commission.find(params['id'])
	end
	def index
		if session[:user_id]
			@user = User.find(session[:user_id])
		else
			if session[:page_user_id]
				@page_user = User.find(session[:page_user_id])
				redirect_to "/#{@page_user.username}"
			else
				redirect_to "/" and return
			end
		end
	end
	def tracker
		if session[:user_id]
			@user = User.find(session[:user_id])
		else
			if session[:page_user_id]
				@page_user = User.find(session[:page_user_id])
				redirect_to "/#{@page_user.username}"
			else
				redirect_to "/" and return
			end
		end
	end
	def create
		if session[:user_id]
			@user = User.find(session[:user_id])
			@commission = Commission.new(commission_params)
			if @commission.save
				@user.address = @commission.address
				@user.city = @commission.city
				@user.state = @commission.state
				@user.country = @commission.country
				@user.zip = @commission.zip
				@user.save
				flash[:sent_mail] = true
				# email commission here
			else
				flash[:errors] = "Something went wrong!"
			end
			redirect_to "/#{@user.username}"
		else
			if session[:page_user_id]
				@page_user = User.find(session[:page_user_id])
				redirect_to "/#{@page_user.username}"
			else
				redirect_to "/" and return
			end
		end
	end
	def commission_params
		params.require(:commission).permit(:user_id, :email, :first, :last, :address, :city, :state, :country, :traveler_names, :traveler_phone, :traveler_email, :depart, :return, :itinerary, :ticket, :supplier, :airline, :hotel, :car_rental, :form, :last_4, :comments, :trip_total, :estimate, :zip, :agent_id, :processed, :c2go)
	end
	def search
		@commissions = Commission.where("email LIKE ? OR first LIKE ? OR last LIKE ? OR traveler_names LIKE ? OR traveler_email LIKE ? OR traveler_phone LIKE ?", "%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%")
		if @commissions
			@@search_commissions = @commissions
			redirect_to "/commissions_found"
		else
			flash[:errors] = "No Users Found"
			redirect_to "/admin_dash" and return
		end
	end
	def unprocessed_search
		@commissions = Commission.where("processed = false")
		if @commissions
			@@search_commissions = @commissions
			redirect_to "/commissions_found"
		else
			flash[:errors] = "No Users Found"
			redirect_to "/admin_dash" and return
		end
	end
	def commissions_found
		@commissions = @@search_commissions.paginate(:page => params[:page])
	end
	def process_commission
		@commission = Commission.find(params['id'])
		@commission.processed = true
		@commission.save
		redirect_to "/commissions/#{@commission.id}"
	end
	def unprocess
		@commission = Commission.find(params['id'])
		@commission.processed = false
		@commission.save
		redirect_to "/commissions/#{@commission.id}"
	end
	def import_commissions
		Commission.import(params[:file])
		redirect_to '/admin_dash'
		flash[:imported] = "Users Imported"
	end
end
