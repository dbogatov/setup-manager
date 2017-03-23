

%w(shevastream mywebsite).each do |project|

	ultimate_postgres "Setup DB for #{project}" do
		project project
		action :run
	end

end
