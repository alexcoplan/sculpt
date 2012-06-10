require 'spec_helper'

# here we keep the spec for tags

describe Sculpture do
    before do
        Sculpt.pretty = false # makes it less fiddly for testing tags.
    end
    
    it "should create simple <br> tags" do
        res = Sculpt.make do
            br
        end
        res.should eql "<br>"
    end
    
    it "should handle a custom anchor constructor" do
        r = Sculpt.make do
            a "text", "url"
        end
        r.should eql "<a href=\"url\">text</a>"
    end
    
    it "should handle a custom img constructor" do
        r = Sculpt.make do
            img "my_lolcat.jpg"
        end
        r.should eql "<img src=\"my_lolcat.jpg\">"
    end
    
    it "should override the kernel for paragraphs" do
        r = Sculpt.make do
            p "chunky bacon"
        end
        r.should eql "<p>chunky bacon</p>"
    end
    
    it "should handle js files as arguments" do
        r = Sculpt.make do
            js "chunky", "bacon"
        end
        gen = "<script type=\"text/javascript\" src=\""
        r.should eql gen+"chunky\"></script>" + gen+"bacon\"></script>"
    end
    
    it "should turn an array into an unordered list" do
        r = Sculpt.make do
            ul ["very","chunky","bacon"]
        end
        r.should eql "<ul><li>very</li><li>chunky</li><li>bacon</li></ul>"
    end
    
    it "should turn an array into an ordered list" do
        r = Sculpt.make do
            ol ["ein","zwei","drei"]
        end
        r.should eql "<ol><li>ein</li><li>zwei</li><li>drei</li></ol>"
    end
    
    it "should set attributes from a hash before a block" do
        r = Sculpt.make do
            div id: :ducks do
                span "quack"
            end
        end
        r.should eql "<div id=\"ducks\"><span>quack</span></div>"
    end
    
    it "should set attributes from a hash after a method" do
        r = Sculpt.make do
            div "an amusing test case", class: :classy
        end
        r.should eql "<div class=\"classy\">an amusing test case</div>"
    end 
    
    it "should accept _s methods to create strings" do
        r = Sculpt.make do
            span do
                puts "an unexpected " + a_s("link","url")
            end
        end
        r.should eql "<span>an unexpected <a href=\"url\">link</a></span>"
    end
end