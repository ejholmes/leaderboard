# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')   { "spec" }
  watch('config/environment.rb') { "spec" }
  watch('lib/leaderboard.rb') { "spec" }

  watch(%r{^lib/leaderboard/(.+)\.rb$})                 { |m| "spec/leaderboard/#{m[1]}_spec.rb" }
end
