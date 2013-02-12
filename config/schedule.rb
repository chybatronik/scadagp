set :output, { :standard => "/var/logs/my_app.log", :error => "/var/logs/my_app.errors.log" }
 

every 1.seconds do
	p "Hello "
end