require "test/unit"

require "units.rb"

class TestUnits < Test::Unit::TestCase
  def test_does_not_blow_up
    assert(true, "Failure message.")
  end
  def test_that_it_can_init
    sample_unit = BaseUnit.new :meter => 1
    assert(sample_unit.is_a?(BaseUnit), "test cannot init")
  end
  def test_meter_exists
    input_units = {:meter => 1, :quantity => 3.5}
    sample_meter = BaseUnit.new(input_units)
    assert_equal(sample_meter.base_to_s, "3.5 meter**1")
  end
  def test_kg_exists
    input_units = {:kg => 1, :quantity => 3.5}
    sample_kg = BaseUnit.new(input_units)
    assert_equal(sample_kg.base_to_s, "3.5 kg**1")
  end
  def test_second_exists
    input_units = {:second => 1, :quantity => 3.5}
    sample_second = BaseUnit.new(input_units)
    assert_equal(sample_second.base_to_s, "3.5 second**1")
  end
  def test_amp_exists
    input_units = {:amp => 1, :quantity => 3.5}
    sample_amp = BaseUnit.new(input_units)
    assert_equal(sample_amp.base_to_s, "3.5 amp**1")
  end
  def test_kelvin_exists
    input_units = {:kelvin => 1, :quantity => 3.5}
    sample_kelvin = BaseUnit.new(input_units)
    assert_equal(sample_kelvin.base_to_s, "3.5 kelvin**1")
  end
  def test_candela_exists
    input_units = {:candela => 1, :quantity => 3.5}
    sample_candela = BaseUnit.new(input_units)
    assert_equal(sample_candela.base_to_s, "3.5 candela**1")
  end
  def test_mol_exists
    # mols still confuse me as to why they are 
    # standard units, I need a refresher before I can 
    # really test them
    input_units = {:mol => 1, :quantity => 3.5}
    sample_mol = BaseUnit.new(input_units)
    assert_equal(sample_mol.base_to_s, "3.5 mol**1")
  end
  def test_meter_shorthand_alone
    input_units = {:m => 2, :quantity => 12.5}
    expected_units = {:meter => 2, :quantity => 12.5}
    sample_m = BaseUnit.new(input_units)
    expected_m  = BaseUnit.new(expected_units)
    assert_equal((expected_m.quantity*10_000.0).round/10_000.0, (sample_m.quantity*10_000.0).round/10_000.0)
    assert_equal(expected_m.base_units, sample_m.base_units)
  end
  def test_meter_shorthand_in_concert
    input_units = {:m => 3, :second => -1, :quantity => 12.2}
    expected_units = {:meter => 3, :second => -1, :quantity => 12.2}
    sample_flow = BaseUnit.new(input_units)
    expected_flow = BaseUnit.new(expected_units)
    assert_equal((expected_flow.quantity*10_000).round/10_000, (sample_flow.quantity*10_000).round/10_000)
    assert_equal(expected_flow.base_units, sample_flow.base_units)
  end
  def test_raise_error_on_both_meter_and_meter_shorthand
  end
  def test_implicit_newton
    input_units = {:kg => 1, :meter => 1, :second => -2, :quantity => 3.5}
    sample_newton = BaseUnit.new(input_units)
    base_units_string = sample_newton.base_to_s
    assert((!base_units_string["kg**1"].nil? \
      and !base_units_string["meter**1"].nil? \
      and !base_units_string["second**-2"].nil? \
      and !base_units_string["3.5 "].nil?))
  end
  def test_explicit_newton
    input_units = {:kg => 1, :meter => 1, :second => -2, :quantity => 3.5}
    sample_newton = BaseUnit.new(input_units)
    units_string = sample_newton.to_s
    assert_equal("","")
  end
  def test_multiplication_value
    input_units = {:meter => 1}
    length = BaseUnit.new(input_units.merge({:quantity => 10.0}))
    width = BaseUnit.new(input_units.merge({:quantity => 5.0}))
    depth = BaseUnit.new(input_units.merge({:quantity => 0.01}))
    volume = (length * width * depth)
    desired_volume = BaseUnit.new({:meter => 3, :quantity => 0.5})
    assert_equal((desired_volume.quantity*10_000.0).round/10_000.0, (volume.quantity*10_000.0).round/10_000.0)
  end
  def test_multiplication_units
    input_units = {:meter => 1}
    length = BaseUnit.new(input_units.merge({:quantity => 10.0}))
    width = BaseUnit.new(input_units.merge({:quantity => 5.0}))
    depth = BaseUnit.new(input_units.merge({:quantity => 0.01}))
    volume = (length * width * depth)
    desired_volume = BaseUnit.new({:meter => 3, :quantity => 0.5})
    assert_equal(desired_volume.base_units, volume.base_units)
  end
  def test_division_value
    input_units = {:meter => 1, :second => -1}
    acc_input_units = {:meter => 1, :second => -2}
    velocity = BaseUnit.new(input_units.merge({:quantity => 10.25}))
    acceleration = BaseUnit.new(acc_input_units.merge({:quantity => 0.5}))
    time_to_velocity = velocity / acceleration
    desired_time_to_velocity = BaseUnit.new({:second => 1, :quantity => 20.50})
    assert_equal(((desired_time_to_velocity.quantity*10_000.0).round/10_000.0), \
      ((time_to_velocity.quantity*10_000).round/10_000.0))
  end
  def test_division_units
  
  end
  def test_addition_value
    input_units = {:kg => 1}
    first_kg = BaseUnit.new(input_units.merge({:quantity => 1.1}))
    second_kg = BaseUnit.new(input_units.merge({:quantity => 2.2}))
    added_kg = first_kg + second_kg
    desired_kg = BaseUnit.new(input_units.merge({:quantity => 3.3}))
    assert_equal((desired_kg.quantity*10_000.0).round/10_000.0, (added_kg.quantity*10_000.0).round/10_000.0)
  end
  def test_addition_units
    input_units = {:kg => 1}
    first_kg = BaseUnit.new(input_units.merge({:quantity => 1.1}))
    second_kg = BaseUnit.new(input_units.merge({:quantity => 2.2}))
    added_kg = first_kg + second_kg
    desired_kg = BaseUnit.new(input_units.merge({:quantity => 3.3}))
    assert_equal(desired_kg.base_units,added_kg.base_units)
  end
  def test_subtraction_value
    input_units = {:kg => 1}
    first_kg = BaseUnit.new(input_units.merge({:quantity => 1.1}))
    second_kg = BaseUnit.new(input_units.merge({:quantity => 2.2}))
    subtracted_kg = first_kg - second_kg
    desired_kg = BaseUnit.new(input_units.merge({:quantity => -1.1}))
    assert_equal((desired_kg.quantity*10_000.0).round/10_000.0, (subtracted_kg.quantity*10_000.0).round/10_000.0)
  end
  def test_subtraction_units
    input_units = {:kg => 1}
    first_kg = BaseUnit.new(input_units.merge({:quantity => 1.1}))
    second_kg = BaseUnit.new(input_units.merge({:quantity => 2.2}))
    subtracted_kg = first_kg - second_kg
    desired_kg = BaseUnit.new(input_units.merge({:quantity => -1.1}))
    assert_equal(desired_kg.base_units, subtracted_kg.base_units)
  end
  def test_unitless_float_multiplication_left_side
 
=begin
    647 520 6344
    4 536 4043
    767 duff
    on east side
    n duff
    just past lindsey 
    input_units = {:meter => 1, :second => -2}
    first_acc = BaseUnit.new(input_units.merge({:quantity => 10.4}))
    factor = 0.5
    final_acc = factor * first_acc
    desired_acc = BaseUnit.new(input_units.merger({:quantity => 5.2}))
    assert_equal(desired_acc.quantity, final_acc.quantity)
=end
  end
  def test_unitless_float_multiplication_right_side
  
  end
  def test_moment_arm_calculations
  end
  def test_raises_error_on_units_mismatch
    input_units = {:kg => 1}
    wrong_units = {:kg => 2}
    first_kg = BaseUnit.new(input_units.merge({:quantity => 1.1}))
    second_kg = BaseUnit.new(wrong_units.merge({:quantity => 2.2}))
    # figure out syntax
    #assert_raise(Exception, "need same units") { added_kg = first_kg + second_kg }
  end
  def test_handles_non_standard_units_with_flag
  end
  def test_raises_error_on_non_standard_units_without_flag
  end
  def test_handles_large_numbers_correctly
  end
  def test_sends_warning_when_input_numbers_are_ints
  end
  def test_takes_in_shorthand_strings
  end
  def test_shorthand_strings_with_double_asterix_exp
  end
  def test_shorthand_strings_with_carret_exp
  end
  
  def test_exponentiation
    # side_of_square ** 2 => 9.0 meter**2
  end
  def test_fractional_exponentiation
    # square_area ** 0.5 => 3.0 meter**1
  end
  def test_negative_exponentiation
    # hz_of_note ** -1 => beats_oer
  end
  
  # input unit helpers
  def test_hz_helper
  end
  def test_lb_helper
  end
  def test_in_helper
  end
  def test_mile_helper
  end
  def test_mm_helper
  end
  def test_cm_helper
  end
  def test_km_helper
  end
  def test_newton_helper
  end
  def test_other_units
  end



end
