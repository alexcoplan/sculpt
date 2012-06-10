require 'sculpt'

def makes(str,&block)
    res = Sculpt.make(&block)
    res.should eql str
end