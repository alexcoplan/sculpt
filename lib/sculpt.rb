#
# Sculpt
#
# An HTMl5 generator in Ruby.
# Syntax is everything.
#

module SculptHelpers
    def elements_from_block(&block)
        result = Sculpture.new
        result.instance_eval(&block)
        result.elements
    end
    
    def is_singleton? tag
        [:area, :base, :br, :col, :command, :embed, :hr, :img, :input, :link, :meta, :param, :source].include? tag
    end
end

# Some string additions from mynyml/unindent on github

class String
  def unindent
    indent = self.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min || 0
    self.gsub(/^[[:blank:]]{#{indent}}/, '')
  end
  def unindent!
    self.replace(self.unindent)
  end
end

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

class ElementContainer
    attr_accessor :elements
    
    def initialize
        @elements = []
    end
end

class Sculpture < ElementContainer
    #
    # This is a container class for elements.
    # It responds to all the method calls in a block that generates HTMl.
    #
    
    include SculptHelpers
     
    def generate_html
        @elements.map(&:generate_html).join('')
    end
     
    def add_tag(tag)
        @elements << tag
        @elements.delete(tag.inline) if tag.inline # dupe prevention
        tag
    end
    
    #
    # block methods
    # use these to make elements
    #
    
    # kenrnel overrides here
    
    def p(text='',attrs = {},&block)
        # necessary to override the Kernel#p method
        add_tag Tag.new(:p, text, attrs, &block)
    end
    
    def puts(text)
        @elements << Static.new(text.unindent)
    end
        
    # other constructors here

    def doctype
        @elements << Static.new('<!DOCTYPE html>') # enforce HTML5
    end

    def js(*args)
        args.each do |arg|
            attrs = {type:"text/javascript", href:arg}
            add_tag Tag.new(:script, attrs)
        end
    end

    def stylesheet(name)
        attrs = {type:"text/css", rel:"stylesheet", href:name}
        add_tag Tag.new(:link, attrs)
    end

    def stylesheets(*args)
        if args[0].respond_to? :to_a
            args[0].each {|sheet| stylesheet sheet}
        end
        args.each {|sheet| stylesheet sheet}
    end
        
    def a(text, href = '', ahash = {}, &block)
        # funky constructor for easier linking
        attrs = {href: href}
        attrs.merge!(ahash) if ahash.kind_of?(Hash)
        add_tag Tag.new(:a, text, attrs, &block)
    end
    
    def img(src, ahash = {})
        # funky img constructor
        attrs = {src: src}
        attrs.merge!(ahash) if ahash.kind_of?(Hash)
        add_tag Tag.new(:img, attrs)
    end
    
    def method_missing(method, *args, &block)
        #
        # general tag constructor
        # custom tag initialisation here
        #
        
        arg1 = args[0]
        arg1 = '' unless arg1
        arg2 = args[1]
        arg2 = {} unless arg2
        
        add_tag Tag.new(method, arg1, arg2, &block)
    end
end

#
# internal structues below
# should not deal with blocks etc.
# but only data and rendering of HTML
#

class Static
    attr_accessor :string
    
    def initialize(string)
        @string = string
    end
    
    def generate_html
        return @string+"\n" if Sculpt.pretty?
        @string
    end
end

class Tag < ElementContainer
    include SculptHelpers
    
    attr_accessor :name, :text, :attrs, :singelton, :inline
    
    def initialize(name,text = '', attrs = {},&block)
        @name = name
        @attrs = {}
        @elements = []
        @inline = false
        
        if text.kind_of?(Hash)
            if attrs.kind_of? Tag
                @inline = attrs
                @elements << attrs
                return self
            else
                @attrs = attrs
                @attrs.merge!(text)
                @text = '' # otherwise stays nil
            end
        elsif text.kind_of?(Tag)
            @inline = text
            @elements << text
            @text = ''
            return self
        else
            @text = text
            @attrs = attrs
        end
        
        if block_given?
            @elements += elements_from_block(&block)
        end
        @singleton = is_singleton? name
    end
    
    def generate_html                
        n = @name.to_s
        open = "<#{n}"
        @attrs.each do |k, v|
            open += " #{k}=\"#{v}\""
        end
        open += '>'
        return open if @singleton
        close = "</#{n}>"
        return open + @text + close unless @elements.any?
        html = ''
        @elements.each do |element|
            html += element.generate_html
            html += "\n" if Sculpt.pretty? and not inline
        end
        return "#{open}\n#{html}#{close}" if Sculpt.pretty? and not inline
        return open + html + close
    end
end