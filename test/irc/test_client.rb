# frozen_string_literal: true

require "test_helper"

module Irc
  class TestClient < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Irc::Client::VERSION
    end
  end
end
