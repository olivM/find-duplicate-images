class Option
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.get(k, default = nil)
    option = Option.find_or_create_by(:name => k)
    if option.value.nil?
      option.value = default
      option.save
    end
    option.value
  end

  def self.set(k, v)
    option = Option.find_or_create_by(:name => k)
    option.value = v
    option.save
  end

  def self.get?(name)
    !self.get(name).nil? and self.get(name).to_i
  end

  def self.dump
    Option.all.each do |option|
      logr "#{option.name} : #{option.value}"   unless option.name.match(/^_/)
    end
  end

end
