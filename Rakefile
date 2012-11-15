
require './main.rb'

namespace :cron do

	desc "fetch"
	task :fetch do

		# check if a crawl is running
		# => lockfile
		require 'lockfile'

		lockfile = Lockfile.new("#{File.basename(Dir.pwd)}.lock")
		begin
			lockfile.lock

			# check config dir
			require 'pathname'
			config_dir = Pathname.new("config/")

			# for each projet
			config_dir.children.each do |project|

				if File.exists?("#{project.to_s}/config.yml")

					p = Project.new(project.to_s)

					p.fetch

				end

			end
		ensure
			lockfile.unlock
		end

	end


	desc "process"
	task :process do

		# check if a crawl is running
		# => lockfile
		require 'lockfile'

		lockfile = Lockfile.new("#{File.basename(Dir.pwd)}.lock")
		begin
			lockfile.lock

			# check config dir
			require 'pathname'
			config_dir = Pathname.new("config/")

			# for each projet
			config_dir.children.each do |project|

				if File.exists?("#{project.to_s}/config.yml")

					p = Project.new(project.to_s)

					p.process

				end

			end
		ensure
			lockfile.unlock
		end

	end


end

