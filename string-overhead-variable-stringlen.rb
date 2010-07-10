# encoding: UTF-8
require 'better-benchmark'

# Linux
# ENV['R_HOME']='/usr/local/lib/R'

# Mac OS X
ENV['R_HOME']='/Library/Frameworks/R.framework/Resources'

STRING = 'A'

START = 1
MAX   = 50
STEP  = 1

ITERATIONS = 10
INNER_ITER = 200000

options = {
  :iterations       => ITERATIONS,
  :inner_iterations => INNER_ITER,
  :verbose          => true
}

###################################################################################################

puts <<-EOS
Tests the overhead of single-quoted versus double-quoted Strings.  Each subsequent test increases
the size of the String's value.

Testing against ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} with #{STRING.encoding.name} encoded Strings

EOS

puts <<-EOS
Starting with test cases of #{STRING.bytesize * START}-byte Strings
Incrementing up to test cases of #{STRING.bytesize * MAX}-byte Strings
In steps of #{STRING.bytesize * STEP} byte(s)

EOS

for size in (START..MAX).step(STEP)
  test_string  = STRING * size
  test_literal = "'#{test_string}'"
  test_process = "\"#{test_string}\""

  puts <<-EOS
---------------------------------------------------------------------------------------------------
Set 1: #{test_string.bytesize}-byte Single-quoted Strings
Set 2: #{test_string.bytesize}-byte Double-quoted Strings
Testing with #{ITERATIONS} passes of #{INNER_ITER} iterations
  EOS

  result = Benchmark.compare_realtime(options) { eval(test_literal) }.with { eval(test_process) }
  Benchmark.report_on(result)
end
