module ApplicationHelper

	# def register_or_logout
	# 	if session["user"]
	# 		 <a class="nav-link" href="#">register</a>
	# 		 <link_to "Register", signup_path, class: "nav-link">
	# 	else
	# 		 <a class="nav-link" href="#">register</a>
	# 	end
	# end

	def active_class(link_path)
    	current_page?(link_path) ? "active" : ""
    	
	end

	#  def current_class?(test_path)
 #    return 'current' if request.path == test_path
 #    ''
 #  end
end
