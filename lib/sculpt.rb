#
# Sculpt
#
# An HTML generator in Ruby.
# Syntax is everything.
#

module Sculpt
    class ElementContainer
        attr_accessor :elements
    
        def initialize
            @elements = []
        end
    end
end

require_relative 'sculpt/sculpt_helpers'
require_relative 'sculpt/elements'
require_relative 'sculpt/sculpture'
require_relative 'sculpt/sculpt_template'

module Sculpt
    class << self
        include Helpers

        attr_accessor :pretty, :smart_attrs
        
        def pretty? # just because that looks nicer
            @pretty
        end
        
        def smart_attrs? # and here
            @smart_attrs
        end

        def make(a = '', &block)
            if a.is_a? String and a.length > 0
                proc = a.to_proc
            else
                proc = block
            end

            result = Sculpture.new
            result.instance_eval(&proc)
            result.generate_html
        end

        def render(str = '', &block)
            puts self.make(str,&block)
        end

        def doc(str = '', &block)
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

        def render_doc(str = '', &block)
            puts self.doc(str, &block)
        end

        def load(sym)
            Sculpt.make sc_read(sym)
        end

        def template(&p)
            Sculpt::Templating::Template.new(doc: false, &p)
        end

        def template_doc(&p)
            Sculpt::Templating::Template.new(doc: true, &p)
        end
    end
end

# a few shortcut methods

def sculpt(a = '', &block)
    return Sculpt.load(a) if a.is_a? Symbol unless block_given?
    Sculpt.make(a, &block)
end

def template(&p)
    Sculpt.template(&p)
end

def template_doc(&p)
    Sculpt.template_doc(&p)
end

Sculpt.pretty = true # pretty print by default
Sculpt.smart_attrs = true # replace underscores in syms acting as attr keys (iss#2)