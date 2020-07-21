class RunningNumber < ActiveRecord::Base

  def self.generate(options={})
  
    prefix = options[:prefix].to_s.strip
    suffix = options[:suffix].to_s.strip
    numsize = !options[:numsize].blank? ? options[:numsize].to_i : 4
    
    conditions = nil
    if options[:date]
      dt = options[:date]
      year = dt.year
      mon = dt.mon
      day = dt.day
      conditions = ["prefix = ? and year = ? and mon = ? and day = ?", prefix, year, mon, day]
    else
      year = nil
      mon = nil
      day = nil
      conditions = ["prefix = ? and year IS NULL and mon IS NULL and day IS NULL", prefix]
    end
    
    rec = self.where(conditions).order("last_number DESC").first
    rec = self.create(prefix: prefix, year: year, mon: mon, day: day, last_number: 0, suffix: suffix ) if rec.nil?    
    rec.last_number += 1
    rec.save
    
    number = rec.last_number
    
    numsize_format = "%0#{numsize}d"
    
    result = "#{prefix}#{year}#{mon}#{day}#{numsize_format % number}#{suffix}"
  end
  
  def self.generate_temp(options={})
  
    prefix = options[:prefix].to_s.strip
    suffix = options[:suffix].to_s.strip
    numsize = !options[:numsize].blank? ? options[:numsize].to_i : 4
    
    conditions = nil
    if options[:date]
      dt = options[:date]
      year = dt.year
      mon = dt.mon
      day = dt.day
      conditions = ["prefix = ? and year = ? and mon = ? and day = ?", prefix, year, mon, day]
    else
      year = nil
      mon = nil
      day = nil
      conditions = ["prefix = ? and year IS NULL and mon IS NULL and day IS NULL", prefix]
    end
    
    rec = self.where(conditions).order("last_number DESC").first
    rec = self.create(prefix: prefix, year: year, mon: mon, day: day, last_number: 0, suffix: suffix ) if rec.nil?  
    rec.last_number += 1
    
    number = rec.last_number
    
    numsize_format = "%0#{numsize}d"
    
    result = "#{prefix}#{year}#{mon}#{day}#{numsize_format % number}#{suffix}"
  end
  
end
