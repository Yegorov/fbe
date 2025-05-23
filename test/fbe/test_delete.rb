# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Zerocracy
# SPDX-License-Identifier: MIT

require 'factbase'
require_relative '../../lib/fbe/delete'
require_relative '../test__helper'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Zerocracy
# License:: MIT
class TestDelete < Fbe::Test
  def test_deletes_one_property
    fb = Factbase.new
    f = fb.insert
    f.foo = 42
    f.hey = 4
    f._id = 555
    Fbe.delete(f, 'foo', 'bar', fb:)
    assert_equal(1, fb.size)
    assert_equal(1, fb.query('(exists hey)').each.to_a.size)
    assert_equal(4, fb.query('(exists hey)').each.first.hey)
  end

  def test_deletes_two_properties
    fb = Factbase.new
    f = fb.insert
    f.foo = 42
    f.hey = 4
    f._id = 555
    Fbe.delete(f, 'foo', 'hey', fb:)
    assert_equal(1, fb.size)
    assert_equal(0, fb.query('(exists hey)').each.to_a.size)
  end
end
