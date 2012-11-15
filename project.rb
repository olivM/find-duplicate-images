class Project

	def initialize(dir)

		Logr.set_logdir("#{dir}/logs/")
		Logr.empty

		@dir = dir

		@slug = self.dir.gsub(/config\//, '')

		self.set_db
		self.load_options

	end

	def name
		@name
	end

	def slug
		@slug
	end

	def dir
		@dir
	end

	def set_db
		p "set db"
		Mongoid.configure do |config|
			config.connect_to "graph-crawler_#{self.slug}"
		end
	end

	def load_options
		p "load options"
		config = YAML::load(File.open("#{self.dir.to_s}/config.yml"))
		if config
			config.each do |k,v|
				Option.set(k, v)
			end
		end
		Option.dump
	end

	def process

		Image.where(:signature => nil).each do |image|
			p image.url
			image.get_signature
		end


	end

	def fetch
		p "fetch"

		Anemone.crawl("http://#{Option.get('url')}") do |anemone|

			anemone.storage = Anemone::Storage.Redis

			anemone.on_every_page do |page|
				puts page.url
			end

			# Regexp.new(Option.get('pages_like'))
			anemone.on_pages_like(%r[/image/\d+]) do |page|

				Image.create(:url => page.url.to_s, :img => page.doc.at('#image')['src'])

				# if title and tag
				# 	post = {title: title, tag: tag}
				# 	puts "Inserting #{post.inspect}"
				# 	posts_collection.insert post
				# end
			end

		end
	end

	def analyse

	end

end