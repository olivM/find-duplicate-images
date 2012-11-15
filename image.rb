class Image

	include Mongoid::Document
	field :url, type: String
	field :img, type: String
	field :signature, type: String

	index({url: 1}, {unique: true })
	index({img: 1}, {unique: true })
	index({signature: 1}, {background: true })

	validates_presence_of :url, :img
	validates_uniqueness_of :url
	validates_uniqueness_of :img
	validates_uniqueness_of :signature

	def get_signature
		if self.signature.nil?
			i = Magick::Image.read(self.img)[0]
			self.signature = i .signature
			p self.signature
			self.save
		end
	end

end