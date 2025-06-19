
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "transbank/sdk/version"

Gem::Specification.new do |spec|
  spec.name          = "transbank-sdk"
  spec.version       = Transbank::Sdk::VERSION
  spec.authors       = ["Transbank Developers"]
  spec.email         = ["transbankdevelopers@continuum.cl"]

  spec.summary       = %q{Transbank SDK for Ruby}
  spec.homepage      = "https://www.transbankdevelopers.cl/"
  spec.license       = "BSD-3-Clause"
  spec.required_ruby_version = ">= 2.7"
  spec.required_rubygems_version = ">= 3.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 2.6"
  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.2"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency 'minitest-reporters', '~> 1.6'
  spec.add_development_dependency 'byebug', "~> 11.1"
  spec.add_development_dependency 'pry-byebug', "~> 3.9"
  spec.add_development_dependency 'webmock', "~> 3.19"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "simplecov_json_formatter", "~> 0.1.4"
end
