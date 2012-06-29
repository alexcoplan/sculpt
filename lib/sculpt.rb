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
        
        def pretty? # just because that looks nicer
            @pretty
        end
        
        def render_doc(str = '', &block)
            puts self.make_doc(str,&block)
        end

        def make_doc(str = '', &block)
            if str.length > 0
                proc = str.to_proc
            else
                proc = block
            end

            self.make do
                doctype
                html(&proc) 
            end
        end

        def render(str = '', &block)
            puts self.make(str,&block)
        end

        def make(str = '', &block)
            if str.length > 0
                proc = str.to_proc
            else
                proc = block
            end

            result = Sculpture.new
            result.instance_eval(&proc)
            result.generate_html
        end
    end
end

Sculpt.pretty = true # pretty print by default