# encoding: utf-8

class Float
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( self, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    
    number = self
    words = ["ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
    units = ["", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน"]
    arr = number.to_s.split(".")
    
    result1s = []
    result_str1s = []
    arr[0].each_char {|i| result1s << i }
    result1s.reverse.each_index {|i| result_str1s << "#{(i == 0 || i % 6 == 0) && result1s.reverse[i].to_i == 1 && result1s.size != i + 1 ? "เอ็ด" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 2 ? "ยี่" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 1 ? "" : words[result1s.reverse[i].to_i]))}#{units[i]}" unless result1s.reverse[i].to_i == 0}
    
    result_str2s = []
    result_str2s << "#{arr[1][0].to_i == 2 ? "ยี่" : (arr[1][0].to_i == 1 ? "" : words[arr[1][0].to_i])}#{units[1]}" unless arr[1][0].to_i == 0
    result_str2s << "#{arr[1][1].to_i == 1 ? "เอ็ด" : words[arr[1][1].to_i]}#{units[0]}" unless arr[1][0].to_i == 0
    
    return result_str1s.reverse.join('') + (result_str1s.size == 0 ? "" : "บาท") + result_str2s.join('') + (result_str2s.size == 0 ? (result_str1s.size == 0 ? "" : "ถ้วน") : "สตางค์")
  end

end

class BigDecimal
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( self, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    
    number = self
    words = ["ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
    units = ["", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน"]
    arr = number.to_s.split(".")
    
    result1s = []
    result_str1s = []
    arr[0].each_char {|i| result1s << i }
    result1s.reverse.each_index {|i| result_str1s << "#{(i == 0 || i % 6 == 0) && result1s.reverse[i].to_i == 1 && result1s.size != i + 1 ? "เอ็ด" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 2 ? "ยี่" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 1 ? "" : words[result1s.reverse[i].to_i]))}#{units[i]}" unless result1s.reverse[i].to_i == 0}
    
    result_str2s = []
    result_str2s << "#{arr[1][0].to_i == 2 ? "ยี่" : (arr[1][0].to_i == 1 ? "" : words[arr[1][0].to_i])}#{units[1]}" unless arr[1][0].to_i == 0
    result_str2s << "#{arr[1][1].to_i == 1 ? "เอ็ด" : words[arr[1][1].to_i]}#{units[0]}" unless arr[1][0].to_i == 0
    
    return result_str1s.reverse.join('') + (result_str1s.size == 0 ? "" : "บาท") + result_str2s.join('') + (result_str2s.size == 0 ? (result_str1s.size == 0 ? "" : "ถ้วน") : "สตางค์")
  end

end

class Decimal
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( self, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    
    number = self
    words = ["ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
    units = ["", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน"]
    arr = number.to_s.split(".")
    
    result1s = []
    result_str1s = []
    arr[0].each_char {|i| result1s << i }
    result1s.reverse.each_index {|i| result_str1s << "#{(i == 0 || i % 6 == 0) && result1s.reverse[i].to_i == 1 && result1s.size != i + 1 ? "เอ็ด" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 2 ? "ยี่" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 1 ? "" : words[result1s.reverse[i].to_i]))}#{units[i]}" unless result1s.reverse[i].to_i == 0}
    
    result_str2s = []
    result_str2s << "#{arr[1][0].to_i == 2 ? "ยี่" : (arr[1][0].to_i == 1 ? "" : words[arr[1][0].to_i])}#{units[1]}" unless arr[1][0].to_i == 0
    result_str2s << "#{arr[1][1].to_i == 1 ? "เอ็ด" : words[arr[1][1].to_i]}#{units[0]}" unless arr[1][0].to_i == 0
    
    return result_str1s.reverse.join('') + (result_str1s.size == 0 ? "" : "บาท") + result_str2s.join('') + (result_str2s.size == 0 ? (result_str1s.size == 0 ? "" : "ถ้วน") : "สตางค์")
  end

end

class Fixnum
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( self, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( self, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    
    number = self
    words = ["ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
    units = ["", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน"]
    arr = number.to_s.split(".")
    
    result1s = []
    result_str1s = []
    arr[0].each_char {|i| result1s << i }
    result1s.reverse.each_index {|i| result_str1s << "#{(i == 0 || i % 6 == 0) && result1s.reverse[i].to_i == 1 && result1s.size != i + 1 ? "เอ็ด" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 2 ? "ยี่" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 1 ? "" : words[result1s.reverse[i].to_i]))}#{units[i]}" unless result1s.reverse[i].to_i == 0}
    
    result_str2s = []
    result_str2s << "#{arr[1][0].to_i == 2 ? "ยี่" : (arr[1][0].to_i == 1 ? "" : words[arr[1][0].to_i])}#{units[1]}" unless arr[1][0].to_i == 0
    result_str2s << "#{arr[1][1].to_i == 1 ? "เอ็ด" : words[arr[1][1].to_i]}#{units[0]}" unless arr[1][0].to_i == 0
    
    return result_str1s.reverse.join('') + (result_str1s.size == 0 ? "" : "บาท") + result_str2s.join('') + (result_str2s.size == 0 ? (result_str1s.size == 0 ? "" : "ถ้วน") : "สตางค์")
  end

end

class String
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( self.to_d, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( self.to_d, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( self.to_d, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    
    number = self.to_d
    words = ["ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า"]
    units = ["", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน"]
    arr = number.to_s.split(".")
    
    result1s = []
    result_str1s = []
    arr[0].each_char {|i| result1s << i }
    result1s.reverse.each_index {|i| result_str1s << "#{(i == 0 || i % 6 == 0) && result1s.reverse[i].to_i == 1 && result1s.size != i + 1 ? "เอ็ด" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 2 ? "ยี่" : ((i == 1 || i % 6 == 1) && result1s.reverse[i].to_i == 1 ? "" : words[result1s.reverse[i].to_i]))}#{units[i]}" unless result1s.reverse[i].to_i == 0}
    
    result_str2s = []
    result_str2s << "#{arr[1][0].to_i == 2 ? "ยี่" : (arr[1][0].to_i == 1 ? "" : words[arr[1][0].to_i])}#{units[1]}" unless arr[1][0].to_i == 0
    result_str2s << "#{arr[1][1].to_i == 1 ? "เอ็ด" : words[arr[1][1].to_i]}#{units[0]}" unless arr[1][0].to_i == 0
    
    return result_str1s.reverse.join('') + (result_str1s.size == 0 ? "" : "บาท") + result_str2s.join('') + (result_str2s.size == 0 ? (result_str1s.size == 0 ? "" : "ถ้วน") : "สตางค์")
  end

end

class NilClass
  include ActionView::Helpers::NumberHelper

  def to_s_comma
    number_with_precision( 0, :precision => 0, :delimiter => ',')
  end

  def to_s_decimal(precision=2)
    number_with_precision( 0, :precision => precision, :separator => '.')
  end

  def to_s_decimal_comma(precision=2)
    number_with_precision( 0, :precision => precision, :separator => '.', :delimiter => ',')
  end
  
  def to_s_thai_currency
    ""
  end

end