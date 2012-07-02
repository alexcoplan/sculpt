class Sculpture < ElementContainer
    #
    # This is a container class for elements.
    # It responds to all the method calls in a block that generates HTML.
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
        if text.is_a? String
            txt = text.unindent.lstrip # for multi-line strings
        else
            txt = text
        end
        add_tag Tag.new(:p, txt, attrs, &block)
    end
    
    def puts(text)
        @elements << Static.new(text.unindent.lstrip)
    end
    
    def pbr(text)
        # adds raw text plus a line break
        @elements << Static.new(text + '<br>')
    end
        
    # other constructors here

    def doctype
        @elements << Static.new('<!DOCTYPE html>') # enforce HTML5
    end
    
    # multi constructors below.
    # just a warning, multi constructors do NOT support funky classes.
    
    private
    def _js(src)
        attrs = {type:"text/javascript",src:src}
        add_tag Tag.new(:script, attrs)
    end

    def js(*args)
        if args[0].is_an? Array
            args[0].each {|script| _js script }
        else
            args.each {|script| _js script }
        end
    end
    
    private
    def _css(src)
        attrs = {type:"text/css", rel:"stylesheet", href:src}
        add_tag Tag.new(:link, attrs)
    end

    def css(*args)
        if args[0].is_an? Array
            args[0].each {|sheet| _css sheet}
        else
            args.each {|sheet| _css sheet}
        end
    end
    
    # special constructors below
        
    def a(text = '', href = '', ahash = {}, &block)
        # funky constructor for easier linking
        attrs = special_attr(:href, href, ahash)
        add_tag Tag.new(:a, text, attrs, &block)
    end
    
    def img(src = '', ahash = {})
        # funky img constructor
        attrs = special_attr(:src, src, ahash)
        add_tag Tag.new(:img, attrs)
    end
    
    private
    def _listgen(list_type, tarr, attrs, &block)
        # constructor for lists from arrays. e.g. => ul [1,2,3]
        tag = Tag.new(list_type)
        tag.attrs = attrs
        if tarr.is_an? Array or tarr.is_a? Range
            tarr.each do |item|
                tag.elements << Tag.new(:li, item)
            end
        elsif tarr.respond_to? :to_s and not tarr.empty?
            tag.text = tarr
        elsif block_given?
            tag.elements += elements_from_block(&block)
        end
        add_tag tag
    end
    
    def ul(tarr = '', attrs = {}, &block)
        _listgen(:ul, tarr, attrs, &block)
    end
    
    def ol(tarr, attrs = {}, &block)
        _listgen(:ol, tarr, attrs, &block)
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
        arg3 = args[2]
        
        m = method.to_s
        if m.end_with? '_s'
            # inline string methods
            meth = m[0..-3].to_sym
            case meth
            when :a
                attrs = special_attr(:href, arg2, arg3)
                tag = Tag.new(:a, arg1, attrs, &block)
            when :img
                attrs = special_attr(:src, arg1, arg2)
                tag = Tag.new(:img, attrs)
            else
                tag = Tag.new(meth, arg1, arg2, &block)
            end
            return tag.generate_html
        end
        add_tag Tag.new(method, arg1, arg2, &block)
    end
end