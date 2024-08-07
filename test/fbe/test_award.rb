# frozen_string_literal: true

# MIT License
#
# Copyright (c) 2024 Zerocracy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'loog'
require_relative '../test__helper'
require_relative '../../lib/fbe/award'

# Test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class TestAward < Minitest::Test
  def test_simple
    a = Fbe::Award.new(
      '
      (award
        (explain "When a bug is resolved by the person who was assigned to it, a reward is granted to this person")
        (in hours "hours passed between bug reported and closed")
        (let max 36)
        (let basis 30)
        (give basis "as a basis")
        (let fee 10)
        (aka
          (set b1
            (if
              (and
                (lt hours max)
                (not (eq hours 0)))
              fee 0))
          (give b1 "for resolving the bug in ${hours} (<${max}) hours")
          "add ${+fee} if it was resolved in less than ${max} hours")
        (set days (div hours 24))
        (set b2 (times days -1))
        (let worst -20)
        (set b2 (max b2 worst))
        (let at_least -5)
        (set b2 (if (lt b2 at_least) b2 0))
        (set b2 (between b2 3 120))
        (give b2 "for holding the bug open for too long (${days} days)"))
      ',
      judge: '', global: {}, loog: Loog::NULL, options: nil
    )
    b = a.bill(hours: 10)
    assert(b.points <= 100)
    assert(b.points >= 5)
    assert_equal(40, b.points)
    g = b.greeting
    [
      'You\'ve earned +40 points for this',
      '+10 for resolving the bug in 10',
      'bug in 10 (<36) hours',
      '+30 as a basis'
    ].each { |t| assert(g.include?(t), g) }
    md = a.policy.markdown
    [
      'First, assume that _hours_ is hours',
      ', and award _b₂_'
    ].each { |t| assert(md.include?(t), md) }
  end

  def test_some_terms
    {
      '(let x 25)' => 0,
      '(award (give (times 5 0.25 "fun")))' => 1,
      '(award (give 25 "for being a good boy"))' => 25,
      '(award (give (between 42 -10 -50) "empty"))' => -10,
      '(award (give (between -3 -10 -50) "empty"))' => 0,
      '(award (give (between -100 -50 -10) "empty"))' => -50
    }.each do |q, v|
      a = Fbe::Award.new(q)
      assert_equal(v, a.bill.points, q)
    end
  end

  def test_some_greetings
    {
      '(award (give (times 5 0.25 "fun")))' => 'You\'ve earned +1 points. ',
      '(award (give 25 "for being a good boy"))' => 'You\'ve earned +25 points. ',
      '(award (let x 0.1) (set b (times x 14)) (give b "fun"))' => 'You\'ve earned +1 points. '
    }.each do |q, v|
      a = Fbe::Award.new(q)
      assert_equal(v, a.bill.greeting, q)
    end
  end

  def test_must_not_give_anything_when_too_small_value
    {
      '(award (give (between 0 5 20)))' => 0,
      '(award (give (between 13 5 20)))' => 13,
      '(award (give (between 3 5 20)))' => 0,
      '(award (give (between 25 5 20)))' => 20,
      '(award (give (between 0 -10 -30)))' => 0,
      '(award (give (between -2 -10 -30)))' => 0,
      '(award (give (between -15 -10 -30)))' => -15,
      '(award (give (between -50 -10 -30)))' => -30
    }.each do |q, v|
      a = Fbe::Award.new(q)
      assert_equal(v, a.bill.points, q)
    end
  end

  def test_some_policies
    {
      '(award (let x_a 25) (set z (plus x_a 1)) (give z "..."))' =>
        'First, let _x-a_ be equal to **25**. Then, set _z_ to _x-a_ + **1**, and award _z_.',
      '(award (aka (let x 17) (give x "hey") "add ${x} when necessary"))' =>
        'Just add **17** when necessary'
    }.each do |q, t|
      md = Fbe::Award.new(q).policy.markdown
      assert(md.include?(t), md)
    end
  end

  def test_shorten_when_one_number
    g = Fbe::Award.new('(award (give 23 "for love"))').bill.greeting
    assert_equal('You\'ve earned +23 points. ', g, g)
  end

  def test_shorten_when_nothing
    g = Fbe::Award.new('(award (give 0 "for none"))').bill.greeting
    assert_equal('You\'ve earned nothing. ', g, g)
  end
end
