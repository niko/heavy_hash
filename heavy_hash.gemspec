# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'tree/version'

Gem::Specification.new do |s|
  s.name         = "tree"
  s.version      = Tree::VERSION
  s.authors      = ["Niko Dittmann"]
  s.email        = "mail+git@niko-dittmann.com"
  s.homepage     = "http://github.com/niko/tree"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
