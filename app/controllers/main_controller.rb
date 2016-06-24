class MainController < ApplicationController

	def setupPageTab(params)
		@page_js='main/js/products.js.erb'

		if params[:div]=='cart'
			@page_js='main/js/cart.js.erb'

		elsif params[:div]=='success'
			@page_js='main/js/success.js.erb'

		end
	end

	def index
		setupPageTab params
		@data = File.read("#{Rails.root}/public/categories.json")
		@data = JSON.parse @data
	end

	def login
		puts params
		@login = File.read("#{Rails.root}/public/credential.json")
		@login = JSON.parse @login
		flag = 0
		@login["credentials"].each do |t|
			if t["username"] == params[:username]
				puts "in user"
				puts "#{t["username"]}"
				if t["password"] == params[:password]
					puts "in psw"
					puts "#{t["password"]}"
					flag = 1
					break
				end
			end
		end	
		cookies.delete :products
		if flag
			redirect_to app_path(div: 'success')
		else
			redirect_to app_path(div: 'cart')
		end
	end

	def add_to_cart
		puts params
		@products = cookies[:products]
		if @products.blank?
			@products = cookies[:products] = params[:id]
		else
			cookies[:products] = @products + ',' + params[:id]
		end
		respond_to do |format|
			puts "Respond to AJAX"
			format.js { render :template=>'main/js/additem.js.erb' }
		end
	end

	def sort_price
		puts params
		@data = File.read("#{Rails.root}/public/categories.json")
		@data = JSON.parse @data
		 @data.keys.each do |key|
		 	@data[key].sort_by!{ |hash| hash['price'] }
		 end

		  render 'main/index'
		
	end

end
