module SculptHelpers
    def elements_from_block(&block)
        result = Sculpture.new
        result.instance_eval(&block)
        result.elements
    end
    
    def is_singleton? tag
        [:area, :base, :br, :col, :command, :embed, :hr, :img, :input, :link, :meta, :param, :source].include? tag
    end
    
    def special_attr(att, val, extra)
        attrs = {att => val}
        return attrs.merge(extra) if extra.kind_of? Hash
        attrs
    end
end

# plus some string additions from mynyml/unindent on github

class String
  def unindent
    indent = self.split("\n").select {|line| !line.strip.empty? }.map {|line| line.index(/[^\s]/) }.compact.min || 0
    self.gsub(/^[[:blank:]]{#{indent}}/, '')
  end
  def unindent!
    self.replace(self.unindent)
  end
end