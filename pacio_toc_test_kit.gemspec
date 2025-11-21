require_relative 'lib/pacio_toc_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'pacio_toc_test_kit'
  spec.version       = PacioTOCTestKit::VERSION
  spec.authors       = ['tstrassner']
  # spec.email         = ['TODO']
  spec.summary       = 'Pacio Toc Test Kit'
  # spec.description   = <<~DESCRIPTION
  #   This is a big markdown description of the test kit.
  # DESCRIPTION
  # spec.homepage      = 'TODO'
  spec.license       = 'Apache-2.0'
  spec.add_dependency 'inferno_core', '~> 1.0.6'
  spec.add_dependency 'tls_test_kit', '~> 1.0'
  spec.add_dependency 'us_core_test_kit', '~> 1.0.0'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  spec.metadata['inferno_test_kit'] = 'true'
  # spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = 'TODO'
  spec.files         = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")

  spec.require_paths = ['lib']
end
