#figure out this sitax
=begin
class Float
  def *(multiple)
    if multiple.is_a? BaseUnit
      multiple * self.to_f
    else
      super
    end
  end
end
=end
class BaseUnit
  attr_accessor :base_units, :starting_units, :quantity, :unit_table
  def initialize starting_units
    raise "shit" unless starting_units.is_a? Hash
    init_base_units
    init_unit_table
    @quantity = starting_units[:quantity]
    @quantity ||= 0.0
    starting_units.delete :quantity
    @starting_units = starting_units
    @starting_units.each do |k,v|
      add_to_base_units(k, v)
    end
  end
  def init_base_units
    @base_units = {
      :meter => 0,
      :kg => 0,
      :second => 0,
      :amp => 0,
      :kelvin => 0,
      :candela => 0, 
      :mol => 0}
  end
  def init_unit_table
    @unit_table = {}
    @unit_table[{
      :meter => 1,
      :kg => 1,
      :second => -2,
      :amp => 0,
      :kelvin => 0,
      :candela => 0, 
      :mol => 0}] = :newton
  end
  def add_to_base_units(unit, dimension)
    unless @base_units[unit].nil?
      @base_units[unit] += dimension
    else
      si_units = conv_unit_to_base(unit, dimension)
      si_units.each do |conv_unit, conv_dimension|
        @base_units[conv_unit] += conv_dimension
      end
    end
  end
  def conv_unit_to_base(unit, dimension)
    si_units =  {
      :meter => 0,
      :kg => 0,
      :second => 0,
      :amp => 0,
      :kelvin => 0,
      :candela => 0, 
      :mol => 0}
    si_units[:meter] += dimension if unit == :m
    si_units
  end
  def +(units_object)
    assure_units(units_object)
    added_value = self.quantity + units_object.quantity
    BaseUnit.new(@base_units.merge({:quantity => added_value}))
  end
  def -(units_object)
    assure_units(units_object)
    subtracted_value = self.quantity - units_object.quantity
    BaseUnit.new(@base_units.merge({:quantity => subtracted_value}))    
  end
  def /(units_object)
    calculated_base_units = sub_units(units_object.base_units)
    devided_value = self.quantity / units_object.quantity
    BaseUnit.new(calculated_base_units.merge({:quantity => devided_value}))
  end
  def *(units_object)
    calculated_base_units = add_units(units_object.base_units)
    multiplied_value = self.quantity * units_object.quantity
    BaseUnit.new(calculated_base_units.merge({:quantity => multiplied_value}))
  end
  def assure_units(units_object)
    raise "need same units" unless units_object.base_units == self.base_units
  end
  def add_units(input_base_units)
    assembled_units = {}
    input_base_units.each do |unit, dimension|
      assembled_units[unit] = dimension + self.base_units[unit]
    end
    assembled_units
  end
  def sub_units(input_base_units)
    assembled_units = {}
    input_base_units.each do |unit, dimension|
      assembled_units[unit] = self.base_units[unit] - dimension
    end
    assembled_units
  end
  def base_to_s
    @units_string = @quantity.to_s + " "
    @base_units.each {|k,v| @units_string += k.to_s + "**" + v.to_s + " "  unless v == 0}
    @units_string.chomp(" ")
  end
  def to_s
    unless @unit_table[base_units].nil?
      @units_string = @quantity.to_s + " "
      @units_string += @unit_table[base_units].to_s
    else
      base_to_s
    end
  end
  def to_string
    self.to_s
  end
end


