
def logr(s, timing = false, file = nil)
  Logr.logr(s, timing, file)
end

def timr(s = "")
  Logr.timr(s)
end

class Logr

  @@stack = Array.new
  @@logfile = "/tmp/log";

  def self.set_logdir(logdir)
	Dir.mkdir(logdir) unless Dir.exists?(logdir)
	@@logfile = "#{logdir}/#{Time.now.to_filename}"
  end

  def self.logr(s, timing, file = nil)
	file = @@logfile if file.nil?
	if timing
	  @@stack.push([Time.now.to_f, s])
	end
	logger = Logger.new(file, 'daily')
	logger.info "#{Time.now} - #{s}"
  end

  def self.timr(s)
	event = @@stack.pop
	if event.nil?
	  return
	end
	timing = Time.now.to_f - event[0]
	logger = Logger.new(@@logfile, 'daily')
	logger.info "#{Time.now} - #{event[1]} (#{s}) #{timing}"
  end

  def self.empty
	File.truncate(@@logfile, 0)   if File.exists?(@@logfile)
  end

  def self.get
	File.open(@@logfile).read   if File.exists?(@@logfile)
  end

end

class Time

  def to_filename
    "#{self.year.to_s.ljust(4, '0')}#{self.month.to_s.ljust(2, '0')}#{self.day.to_s.ljust(2, '0')}_#{self.hour.to_s.ljust(2, '0')}#{self.min.to_s.ljust(2, '0')}#{self.sec.to_s.ljust(2, '0')}"
  end

  def mysql
    "#{self.strftime('%Y-%m-%d %H:%m:%S')}"
  end

end

def days_in_month(d)
  (Date.new(d.year,12,31) << (12-d.month)).day
end

def beginning_to_end_of_month(date)
  from = date - ((date.day-1).days)
  to = from + (days_in_month(from)-1).days + 1.day
  from..to
end

class Object
  def to_bool
    Boolean(self)
  end
end

class String
  def sanitize
    self.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "")
  end
end

def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
  from_time = from_time.to_time if from_time.respond_to?(:to_time)
  to_time = to_time.to_time if to_time.respond_to?(:to_time)
  distance_in_minutes = (((to_time - from_time).abs)/60).round
  distance_in_seconds = ((to_time - from_time).abs).round

  I18n.with_options :locale => options[:locale], :scope => :'datetime.distance_in_words' do |locale|
    case distance_in_minutes
      when 0..1
        return distance_in_minutes == 0 ?
               locale.t(:less_than_x_minutes, :count => 1) :
               locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds

        case distance_in_seconds
          when 0..4   then locale.t :less_than_x_seconds, :count => 5
          when 5..9   then locale.t :less_than_x_seconds, :count => 10
          when 10..19 then locale.t :less_than_x_seconds, :count => 20
          when 20..39 then locale.t :half_a_minute
          when 40..59 then locale.t :less_than_x_minutes, :count => 1
          else             locale.t :x_minutes,           :count => 1
        end

      when 2..44           then locale.t :x_minutes,      :count => distance_in_minutes
      when 45..89          then locale.t :about_x_hours,  :count => 1
      when 90..1439        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
      when 1440..2529      then locale.t :x_days,         :count => 1
      when 2530..43199     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
      when 43200..86399    then locale.t :about_x_months, :count => 1
      when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
      else
        distance_in_years           = distance_in_minutes / 525600
        minute_offset_for_leap_year = (distance_in_years / 4) * 1440
        remainder                   = ((distance_in_minutes - minute_offset_for_leap_year) % 525600)
        if remainder < 131400
          locale.t(:about_x_years,  :count => distance_in_years)
        elsif remainder < 394200
          locale.t(:over_x_years,   :count => distance_in_years)
        else
          locale.t(:almost_x_years, :count => distance_in_years + 1)
        end
    end
  end
end


module Enumerable
  def median
    # trivial cases
    return nil if self.empty?

    mid = self.length / 2
    if self.length.odd?
      (entries.sort)[mid]
    else
      s = entries.sort
      (s[mid-1] + s[mid]).to_f / 2.0
    end
  end
end
