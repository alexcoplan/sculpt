module Sculpt
    module Templating                
        class THandler
            include Sculpt::Helpers
            
            attr_accessor :sculpture
            
            def initialize
                @sculpture = Sculpture.new
            end
            
            def render(p = :_single)
                ph = placehold(p)
                @sculpture.elements << ph
                ph # inline rendering
            end
            
            std = [:head, :p]
            std.each do |s|
                define_method(s) do |*args, &block|
                    @sculpture.send(s, *args, &block)
                end
            end
            
            def method_missing(sym, *args, &block)
                nargs = args + [self]
                @sculpture.send(sym, *nargs, &block)
            end
        end
        
        class SHandler
            # another sculpture wrapper for individaul template assignments
            def initialize(sections,sculpture)
                @sculpture = Marshal.load(Marshal.dump(sculpture)) # deep copy
                @sections = {}
                sections.each do |s|
                    @sections[s] = Section.new
                end
            end
            
            std = [:head, :p]
            std.each do |s|
                define_method(s) do |*args, &block|
                    method_missing(s, *args, &block)
                end
            end
            
            def method_missing(sym, *args, &block)
                if @sections.include? sym
                    @sections[sym].content = Sculpt.make(&block)
                    @sections[sym].content += "\n" if Sculpt.pretty?
                else
                    @sections[:_single].sculpture.send(sym, *args, &block)
                end
            end
            
            def generate_html
                if @sections.include? :_single
                    @sections[:_single].content = @sections[:_single].sculpture.generate_html
                    @sections[:_single].content += "\n" if Sculpt.pretty?
                end
                @sculpture.elements = replace_placeholders(@sculpture.elements)
                @sculpture.generate_html
            end
            
            def replace_placeholders(elements)
                elements.map do |e|
                    if e.respond_to?(:elements) and e.elements.any?
                        e.elements = replace_placeholders(e.elements)
                        e
                    elsif e.is_a? Placeholder
                        Static.new(@sections[e.name].content)
                    else
                        e
                    end
                end
            end         
        end
        
        class Section
            attr_accessor :content, :sculpture
            
            def initialize
                @content = ''
                @sculpture = Sculpture.new
            end
        end
        
        class Placeholder
            attr_accessor :name
            
            def initialize(n)
                @name = n
            end
        end
        
        class Template
            def initialize(opts = {}, &proc)
                @sections = []
                params = proc.parameters.collect { |p| p[1] }
                if params.count > 1
                    params.each { |p| @sections << p }
                else
                    @sections << :_single
                end
                
                placeholders = []
                @sections.each { |s| placeholders << Placeholder.new(s) }
                
                h = THandler.new
                h.instance_exec(*placeholders,&proc)
                @sculpture = h.sculpture
                @doc = opts[:doc]
            end

            def make(&block)
                h = SHandler.new(@sections,@sculpture.clone)
                h.instance_exec(&block)
                out = h.generate_html
                if @doc
                    out += "\n" if Sculpt.pretty?
                    Sculpt.doc { puts out }
                else
                    out
                end
            end
        end 
    end
end