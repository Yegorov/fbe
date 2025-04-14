# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2025 Zerocracy
# SPDX-License-Identifier: MIT

require 'factbase'
require_relative '../../lib/fbe/overwrite'
require_relative '../test__helper'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2025 Zerocracy
# License:: MIT
class TestOverwrite < Fbe::Test
  def test_simple_overwrite
    fb = Factbase.new
    f = fb.insert
    f._id = 1
    f.foo = 42
    f.bar = 'hey you друг'
    f.many = 3
    f.many = 3.14
    Fbe.overwrite(f, 'foo', 55, fb:)
    assert_equal(55, fb.query('(always)').each.to_a.first['foo'].first)
    assert_equal('hey you друг', fb.query('(always)').each.to_a.first['bar'].first)
    assert_equal(2, fb.query('(always)').each.to_a.first['many'].size)
  end

  def test_overwrite_twice
    fb = Factbase.new
    f = fb.insert
    f._id = 1
    f2 = Fbe.overwrite(f, 'foo', 42, fb:)
    Fbe.overwrite(f2, 'bar', 7, fb:)
    assert_equal(42, fb.query('(exists foo)').each.to_a.first.foo)
  end

  def test_no_need_to_overwrite
    fb = Factbase.new
    f = fb.insert
    f._id = 1
    f.foo = 42
    fb.insert._id = 2
    Fbe.overwrite(f, 'foo', 42, fb:)
    assert_equal(1, fb.query('(always)').each.to_a.first._id)
  end

  def test_simple_insert
    fb = Factbase.new
    f = fb.insert
    f._id = 1
    Fbe.overwrite(f, 'foo', 42, fb:)
    assert_equal(42, fb.query('(always)').each.to_a.first['foo'].first)
  end

  def test_without_id
    fb = Factbase.new
    f = fb.insert
    assert_raises(StandardError) do
      Fbe.overwrite(f, 'foo', 42, fb:)
    end
  end

  def test_safe_insert
    fb = Factbase.new
    f1 = fb.insert
    f1.bar = 'a'
    f2 = fb.insert
    f2.bar = 'b'
    f2._id = 2
    f3 = fb.insert
    f3._id = 1
    Fbe.overwrite(f3, 'foo', 42, fb:)
    assert_equal(3, fb.size)
  end
end
