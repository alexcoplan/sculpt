require 'sculpt'

def makes(str,&block)
    res = Sculpt.make(&block)
    res.should eql str
end

# these two methods help test file operations

def fstr(str)
	"spec/files/" + str
end

def fsym(str)
	fstr(str).to_sym
end

class Object
    def doctest(s)
        should == s.unindent.lstrip
    end
    
    def npptest(s)
        should == s.unindent.gsub("\n",'')
    end
end