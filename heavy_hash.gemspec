# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'heavy_hash/version'

Gem::Specification.new do |s|
  s.name         = "heavy_hash"
  s.version      = HeavyHash::VERSION
  s.authors      = ["Niko Dittmann"]
  s.email        = "mail+git@niko-dittmann.com"
  s.homepage     = "http://github.com/niko/heavy_hash"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
