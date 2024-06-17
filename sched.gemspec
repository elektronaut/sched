# encoding: utf-8

$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "sched/version"

Gem::Specification.new do |s|
  s.name        = "sched"
  s.version     = Sched::VERSION
  s.summary     = "Sched API client library for Ruby"
  s.description = "Sched (https://sched.com) API client library for Ruby"
  s.authors     = ["Inge Jørgensen"]
  s.email       = "inge@kord.no"
  s.homepage    = "https://github.com/elektronaut/sched"
  s.license     = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  s.files = Dir[
    "{app,config,db,lib,vendor}/**/*",
    "Rakefile",
    "README.md"
  ]
  s.test_files = Dir["{test,spec}/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "curb"
end
