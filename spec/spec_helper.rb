require 'sculpt'

def makes(str,&block)
    res = Sculpt.make(&block)
    res.should eql str
end

class Object
    def doctest(s)
        should == s.unindent.lstrip
    end
    
    def npptest(s)
        should == s.unindent.gsub("\n",'')
    end
end