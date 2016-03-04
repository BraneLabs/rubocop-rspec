# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks if test is focused.
      #
      # @example
      #   # bad
      #   describe MyClass, focus: true do
      #   end
      #
      #   # good
      #   describe MyClass do
      #   end
      class Focus < Cop
        MESSAGE = 'Focused spec found.'.freeze
        FOCUSABLE_BLOCKS = [
          :describe, :context, :it, :feature, :scenario
        ].freeze
        FOCUS_TRUE_PAIR = s(:pair, s(:sym, :focus), s(:true))

        def on_send(node)
          _receiver, method_name, *_args = *node
          @focusable_block = FOCUSABLE_BLOCKS.include?(method_name)
        end

        def on_hash(node)
          return unless @focusable_block

          return if node.children.any? do |n|
            add_offense(n, :expression, MESSAGE) if [FOCUS_TRUE_PAIR].include?(n)
          end
        end
      end
    end
  end
end
