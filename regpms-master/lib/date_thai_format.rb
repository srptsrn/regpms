# encoding: utf-8

class Date
  include ActionView::Helpers::NumberHelper
  
  ABBR_MONTHNAMES_TH = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
  MONTHNAMES_TH = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]


  def to_s_lazy(options={})
    
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year}", "%d/%m/%Y")
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year + 543}", "%d/%m/%Y") if I18n.locale == :th
    
    date.strftime("%d/%m/%Y")
    
  end

  def to_s_thai(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end

    if options[:mon]
      result = %{#{month_names[self.mon]} #{self.year + 543}}
    elsif options[:year_label]
      result = %{#{self.day} #{month_names[self.mon]} พ.ศ. #{self.year + 543}}
    else
      result = %{#{self.day} #{month_names[self.mon]} #{self.year + 543}}
    end
    
    result
  end

  def to_s_thai_month(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end

    result = %{#{month_names[self.mon]}}
    
    result
  end

  def to_s_thai_year

    result = %{#{self.year + 543}}
    
    result
  end
  
  def to_s_thai_date
    result = %{#{self.day}/#{self.mon}/#{self.year + 543}}
  end
  
  def to_s_thai_datetime
    result = %{#{self.day}/#{self.mon}/#{self.year + 543} #{self.hour}:#{self.min}}
  end
  
  def to_s_time
    result = %{#{self.hour}:#{self.min}:#{self.sec}}
  end
end

class DateTime
  include ActionView::Helpers::NumberHelper

  def to_s_lazy(options={})
    
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year}", "%d/%m/%Y")
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year + 543}", "%d/%m/%Y") if I18n.locale == :th
    
    date.strftime("%d/%m/%Y")
    
  end

  def to_s_thai(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end
    
    if options[:mon]
      result = %{#{month_names[self.mon]} #{self.year + 543}}
    elsif options[:year_label]
      result = %{#{self.day} #{month_names[self.mon]} พ.ศ. #{self.year + 543}}
    else
      result = %{#{self.day} #{month_names[self.mon]} #{self.year + 543}}
    end
    
    result
  end

  def to_s_thai_month(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end

    result = %{#{month_names[self.mon]}}
    
    result
  end

  def to_s_thai_year

    result = %{#{self.year + 543}}
    
    result
  end
  
  def to_s_thai_date
    result = %{#{self.day}/#{self.mon}/#{self.year + 543}}
  end
  
  def to_s_thai_datetime
    result = %{#{self.day}/#{self.mon}/#{self.year + 543} #{self.hour}:#{self.min}}
  end
  
  def to_s_time
    result = %{#{self.hour}:#{self.min}:#{self.sec}}
  end
end

class Time
  include ActionView::Helpers::NumberHelper

  def to_s_lazy(options={})
    
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year}", "%d/%m/%Y")
    date = Date.strptime("#{self.day}/#{self.mon}/#{self.year + 543}", "%d/%m/%Y") if I18n.locale == :th
    
    date.strftime("%d/%m/%Y")
    
  end

  def to_s_thai(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end
    
    if options[:mon]
      result = %{#{month_names[self.mon]} #{self.year + 543}}
    elsif options[:year_label]
      result = %{#{self.day} #{month_names[self.mon]} พ.ศ. #{self.year + 543}}
    else
      result = %{#{self.day} #{month_names[self.mon]} #{self.year + 543}}
    end
    
    result
  end

  def to_s_thai_month(options={})
    if options[:abb]
      month_names = ["", "ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
    else
      month_names = ["", "มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
    end

    result = %{#{month_names[self.mon]}}
    
    result
  end

  def to_s_thai_year

    result = %{#{self.year + 543}}
    
    result
  end
  
  def to_s_thai_date
    result = %{#{self.day}/#{self.mon}/#{self.year + 543}}
  end
  
  def to_s_thai_datetime
    result = %{#{self.day}/#{self.mon}/#{self.year + 543} #{self.hour}:#{self.min}}
  end
  
  def to_s_time
    result = %{#{self.hour}:#{self.min}:#{self.sec}}
  end
end

class NilClass
  include ActionView::Helpers::NumberHelper

  def to_s_lazy(options={})
    ""
  end

  def to_s_thai(options={})
    ""
  end

  def to_s_thai_month(options={})
    ""
  end

  def to_s_thai_year
    ""
  end
  
  def to_s_thai_date
    ""
  end
  
  def to_s_thai_datetime
    ""
  end
  
  def to_s_time
    ""
  end
end