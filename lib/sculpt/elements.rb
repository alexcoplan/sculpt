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
    
    def generate_html(ugly = false)
        pp = Sculpt.pretty and not ugly  
                      
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
            html += "\n" if pp unless inline or element.kind_of? Static
        end
        return "#{open}\n#{html}#{close}" if pp and not inline
        return open + html + close
    end
end

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