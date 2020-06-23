
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "monotonic_tick_count/version"

Gem::Specification.new do |spec|
  spec.name          = "monotonic_tick_count"
  spec.version       = MonotonicTickCount::VERSION
  spec.authors       = ["Invoca Development"]
  spec.email         = ["development@invoca.com"]

  spec.summary       = "PORO to hold a monotonic tick count. Useful for measuring time differences."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/invoca/monotonic_tick_count"
  spec.license       = "MIT"

  spec.metadata = {
   "allowed_push_host" => "https://rubygems.org"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.2"
end
