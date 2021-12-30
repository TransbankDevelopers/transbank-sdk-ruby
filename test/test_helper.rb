$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "minitest/autorun"
require 'pry'
require 'minitest/reporters'
Minitest::Reporters.use!
require 'webmock/minitest'
require 'transbank/sdk'

module Transbank
  module WebPayPlus
    class Test < Minitest::Test
      include WebMock::API
    end
  end
end

# Alias the 'continue, step, etc' commands to the shorter byebug versions
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end
