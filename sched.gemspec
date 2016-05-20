# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "sched/version"

Gem::Specification.new do |s|
  s.name        = 'sched'
  s.version     = Sched::VERSION
  s.date        = '2014-01-20'
  s.summary     = "SCHED* (http://sched.org) API client library for Ruby"
  s.description = "SCHED* (http://sched.org) API client library for Ruby"
  s.authors     = ["Inge Jørgensen"]
  s.email       = 'inge@manualdesign.no'
  s.homepage    = 'http://github.com/elektronaut/sched'
  s.license     = 'MIT'
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'curb'
end
