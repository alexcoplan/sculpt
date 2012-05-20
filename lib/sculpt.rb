class Sculpt
    class << self
        attr_accessor :pretty
    end
    
    def self.pretty?
        @pretty
    end
    
    def self.make(&block)
        result = Sculpture.new
        result.instance_eval(&block)
        puts result.generate_html
    end
end

Sculpt.pretty = true

class ElementContainer
    attr_accessor :elements
    
    def initialize
        @elements = []
    end
end

class Sculpture < ElementContainer
    def p(text,&block)
        tag = Paragraph.new(text)
        @elements << tag
    end
    
    def a(text, link, &block)
        tag = Anchor.new(text, link, &block)
        @elements << tag
    end
    
    def generate_html
        @elements.map(&:generate_html).join('')
    end
    
    def method_missing(method, *args, &block)
        tag = Tag.new(method)
        if args.any?
            contents = args[0]
            if contents.respond_to?(:to_a)
                contents.each do |item|
                    tag.elements << Tag.new(:li,item.to_s)
                end
                @elements << tag
                return # ignore block if list given 
            end
            tag.text = contents
        end
        
        if block_given?
            result = Sculpture.new
            result.instance_eval(&block)
            tag.elements += result.elements
        end
        @elements << tag
    end
end

#
# internal structues below
# should not deal with blocks etc.
# but only data and rendering of HTML
#

class Tag < ElementContainer
    attr_accessor :name, :text
    
    def initialize(name,text = '')
        @name = name
        @elements = []
        @text = text
    end
    
    def generate_html
        n = @name.to_s
        open = "<#{n}>"
        close = "</#{n}>"
        return open + @text + close unless @elements.any?
        html = ''
        @elements.each do |element|
            html += element.generate_html
            html += "\n" if Sculpt.pretty?
        end
        return "#{open}\n#{html}#{close}" if Sculpt.pretty?
        return open + html + close
        ret 
    end
end

class Paragraph < Tag
    def initialize(text = '')
         @name = :p
         @text = text
         @elements = []
    end
end

class Anchor < Tag
    attr_accessor :href
    
    def initialize(text = '', href='', &block)
         @name = :a
         @text = text
         @href = href
    end
    
    def generate_html
        open = '<a'
        open += " href=\"#{href}\"" unless href.empty?
        open += '>'
        return open + text + "</a>"
    end    
end