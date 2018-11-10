
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "monotonic_tick_count/version"

Gem::Specification.new do |spec|
  spec.name          = "monotonic_tick_count"
  spec.version       = MonotonicTickCount::VERSION
  spec.authors       = ["Colin Kelley"]
  spec.email         = ["colindkelley@gmail.com"]

  spec.summary       = "PORO to hold a monotonic tick count. Useful for measuring time differences."
  spec.description   = "PORO to hold a monotonic tick count. Useful for measuring time differences."
  spec.homepage      = "https://github.com/invoca/monotonic_tick_count"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 4.2"
end
