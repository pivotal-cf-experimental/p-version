SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.join('..', 'lib', SPEC_ROOT))

Dir.glob(File.join(SPEC_ROOT, 'support', '*.rb')).each { |support| require support }
