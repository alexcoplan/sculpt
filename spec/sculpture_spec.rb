require 'spec_helper'

# here we keep the spec for tags

describe Sculpture do
    before do
        Sculpt.pretty = false # makes it less fiddly for testing tags.
    end
    
    it "should create simple <br> tags" do
        makes "<br>" do
            br
        end
    end
    
    it "should handle a custom anchor constructor" do
        makes "<a href=\"url\">text</a>" do
            a "text", "url"
        end
    end
    
    it "should handle a custom img constructor" do
        makes "<img src=\"my_lolcat.jpg\">" do
            img "my_lolcat.jpg"
        end
    end
    
    it "should override the kernel for paragraphs" do
        makes "<p>chunky bacon</p>" do
            p "chunky bacon"
        end
    end
    
    it "should handle js files as arguments" do
        gen = "<script type=\"text/javascript\" src=\""
        str = gen+"chunky.js\"></script>" + gen+"bacon.js\"></script>"
        makes str do
            js "chunky.js", "bacon.js"
        end
    end
    
    it "should handle js files as an array" do
        gen = "<script type=\"text/javascript\" src=\""
        str = gen+"chunky.js\"></script>" + gen+"bacon.js\"></script>"
        makes str do
            js ["chunky.js", "bacon.js"]
        end
    end
    
    it "should handle css files as arguments" do
        gen = "<link type=\"text/css\" rel=\"stylesheet\" href=\""
        str = gen +"shiny.css\">" + gen + "styles.css\">"
        makes str do
            css "shiny.css", "styles.css"
        end
    end
    
    it "should handle css files as an array" do
        gen = "<link type=\"text/css\" rel=\"stylesheet\" href=\""
        str = gen +"shiny.css\">" + gen + "styles.css\">"
        makes str do
            css ["shiny.css", "styles.css"]
        end
    end
    
    it "should turn an array into an unordered list" do
        makes "<ul><li>very</li><li>chunky</li><li>bacon</li></ul>" do
            ul ["very","chunky","bacon"]
        end
    end
    
    it "should turn an array into an ordered list" do
        makes "<ol><li>ein</li><li>zwei</li><li>drei</li></ol>" do
            ol ["ein","zwei","drei"]
        end
    end
    
    it "should set attributes from a hash before a block" do
        makes "<div id=\"ducks\"><span>quack</span></div>" do
            div id: :ducks do
                span "quack"
            end
        end
    end
    
    it "should set attributes from a hash after a method" do
        makes "<div class=\"classy\">an amusing test case</div>" do
            div "an amusing test case", class: :classy
        end
    end 
    
    it "should accept _s methods to create strings" do
        makes "<span>an unexpected <a href=\"url\">link</a></span>" do
            span do
                puts "an unexpected " + a_s("link","url")
            end
        end
    end
    
    it "should unindent multi-line statics" do
        makes "multi-line\nstatic" do
            puts "
            multi-line
            static"
        end
    end
    
    it "should unindent multi-line paragraphs" do
        makes "<p>multi-line\nparagraph</p>" do
            p "
            multi-line
            paragraph"
        end
    end
    
    it "should support funky classes" do
        makes "<div class=\"header\">Content</div>" do
            div.header "Content"
        end
    end
    
    it "should support funky classes with anchors" do
        makes "<a href=\"here.html\" class=\"big\">Follow me</a>" do
            a.big "Follow me", "here.html"
        end
    end
    
    it "should support funky classes with images" do
        makes "<img src=\"klobig_speck.png\" class=\"framed\">" do
            img.framed "klobig_speck.png"
        end
    end
    
    it "should support lists with funky classes and attributes" do
        makes "<ul class=\"nav\" width=\"300\"><li>Home</li><li>About</li><li>Contact</li></ul>" do
            ul.nav ["Home","About","Contact"], width: 300
        end
    end
    
    # these test cases are the result of previous bugs:
    
    it "should handle attributes with methods that use special_attr (like img)" do
        makes "<img src=\"my_lolcat.png\" id=\"lulz\">" do
            img "my_lolcat.png", id: :lulz
        end
    end
    
    it "should let you use attributes with inline tags (tag passed as argument)" do
        makes "<div id=\"mydiv\"><img src=\"da_pic.png\"></div>" do
            div img("da_pic.png"), id: :mydiv
        end
    end
end