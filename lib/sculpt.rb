#
# Sculpt
#
# An HTMl5 generator in Ruby.
# Syntax is everything.
#

class ElementContainer
    attr_accessor :elements
    
    def initialize
        @elements = []
    end
end

require_relative 'sculpt/sculpt_helpers'
require_relative 'sculpt/elements'
require_relative 'sculpt/sculpture'

class Sculpt
    #
    # The Sculpt class is used externally.
    # Most of the time this is the only class users will play with.
    #

    class << self
        attr_accessor :pretty
    end

    def self.pretty?
        @pretty
    end

    def self.render_doc(&block)
        puts self.make_doc(&block)
    end

    def self.make_doc(&block)
        self.make do
            doctype
            html(&block) 
        end
    end

    def self.render(&block)
        puts self.make(&block)
    end

    def self.make(&block)
        result = Sculpture.new
        result.instance_eval(&block)
        result.generate_html
    end
end

Sculpt.pretty = true # pretty print by default