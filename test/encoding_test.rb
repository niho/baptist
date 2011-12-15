# encoding: ISO-8859-1

require 'test/unit'
require 'baptist'

class BaptistTest < Test::Unit::TestCase

  def test_forces_utf_8
    assert_equal 'Tr%C3%A4d-Gr%C3%A4s-och-Stenar', Baptist.generate('Träd Gräs och Stenar')
  end

end
