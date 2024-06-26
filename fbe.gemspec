# frozen_string_literal: true

# Copyright (c) 2024 Zerocracy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative 'lib/fbe'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=3.0'
  s.name = 'fbe'
  s.version = Fbe::VERSION
  s.license = 'MIT'
  s.summary = 'FactBase Extended (FBE), a collection of utility classes for Zerocracy judges'
  s.description =
    'A collection of extensions for a factbase, helping the judges of Zerocracy ' \
    'manipulate the facts and create new ones'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'http://github.com/zerocracy/fbe'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_runtime_dependency 'backtrace', '~>0.3'
  s.add_runtime_dependency 'decoor', '~>0.0'
  s.add_runtime_dependency 'factbase', '~>0.0'
  s.add_runtime_dependency 'faraday', '2.9.1'
  s.add_runtime_dependency 'faraday-http-cache', '2.5.1'
  s.add_runtime_dependency 'faraday-multipart', '1.0.4'
  s.add_runtime_dependency 'faraday-retry', '2.2.1'
  s.add_runtime_dependency 'json', '~>2.7'
  s.add_runtime_dependency 'judges', '~>0.0'
  s.add_runtime_dependency 'loog', '~>0.2'
  s.add_runtime_dependency 'nokogiri', '~>1.10'
  s.add_runtime_dependency 'obk', '~>0.0'
  s.add_runtime_dependency 'octokit', '~>9.1.0'
  s.add_runtime_dependency 'others', '~>0.0'
  s.add_runtime_dependency 'tago', '~>0.0'
  s.add_runtime_dependency 'verbose', '~>0.0'
  s.add_runtime_dependency 'yaml', '~>0.3'
  s.metadata['rubygems_mfa_required'] = 'true'
end
