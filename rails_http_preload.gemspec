# frozen_string_literal: true

require_relative "lib/rails_http_preload/version"

Gem::Specification.new do |spec|
  spec.name = "rails_http_preload"
  spec.version = RailsHttpPreload::VERSION
  spec.authors = ["Nate Berkopec"]
  spec.email = ["nate.berkopec@gusto.com"]

  spec.summary = "Automatically add an HTTP header to Rails apps to use 103 Early Hints"
  spec.description = "Automatically add a `link` header directing clients to " \
                     "`preconnect` to your `asset_host` to HTML document responses in Rails."
  spec.homepage = "https://github.com/gusto/rails_http_preload"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/gusto/rails_http_preload"
  spec.metadata["changelog_uri"] = "https://github.com/Gusto/rails_http_preload/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "rails"
end
