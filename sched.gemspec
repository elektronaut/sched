# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "sched/version"

Gem::Specification.new do |s|
  s.name        = "sched"
  s.version     = Sched::VERSION
  s.summary     = "Sched API client library for Ruby"
  s.description = "Sched (https://sched.com) API client library for Ruby"
  s.authors     = ["Inge Jørgensen"]
  s.email       = "inge@anyone.no"
  s.homepage    = "https://github.com/elektronaut/sched"
  s.license     = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  s.files = Dir[
    "{app,config,db,lib,vendor}/**/*",
    "Rakefile",
    "README.md"
  ]
  s.require_paths = ["lib"]

  s.add_dependency "curb"
  s.metadata["rubygems_mfa_required"] = "true"
end
