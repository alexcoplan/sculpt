require 'spec_helper'

# this spec is for testing generic sculpt features
# for tag specs see sculpture_spec

describe Sculpt do
    context "with pretty print enabled" do
        before do
            Sculpt.pretty = true
        end
        
        stdres = "<!DOCTYPE html>\n<html>\n<p>test</p>\n</html>"
        
        it "should create a bare bones HTML doc from a block" do
            Sculpt.doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones HTML doc from a string of code" do
            Sculpt.doc('p "test"').should eq stdres
        end

        it "should load a file with sculpt shortcut" do
            sculpt(fsym "p.rb").should == "<p>in a file</p>"
        end

        it "should load a file with Sculpt.load" do
            Sculpt.load(fstr "load.rb").doctest "
            <!DOCTYPE html>
            <html>
            <head>
            <title>sculpt does files</title>
            </head>
            <body>
            <div class=\"sarcasm\">
            <p class=\"bro\">Have you heard?!</p>
            <p class=\"brah\">What?</p>
            <p class=\"bro\">Sculpt does files!</p>
            <p class=\"brah\">No way man!</p>
            <p class=\"bro\">Yeah brah, totally rad!</p>
            </div>
            </body>
            </html>"
        end
    end
    
    context "without pretty print enabled" do
        before do
            Sculpt.pretty = false
        end
        
        stdres = "<!DOCTYPE html><html><p>test</p></html>"
        
        it "should create a bare bones doc" do
            Sculpt.doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones doc from a string of code" do
            Sculpt.doc('p "test"').should eq stdres
        end
    end
    
    context "with smart attrs disabled" do
        before do
            Sculpt.smart_attrs = false
        end
        
        it "should not replace symbols with underscores with dashes" do
            Sculpt.make do
                p "This paragraph", data_is: :notsome
            end.should eq "<p data_is=\"notsome\">This paragraph</p>"
        end
    end
    
    context "with smart attrs enabled" do
        before do
            Sculpt.smart_attrs = true
        end
        
        it "should replace symbols with underscores with dashes" do
            Sculpt.make do
                p "This paragraph", data_is: :awesome
            end.should eq "<p data-is=\"awesome\">This paragraph</p>"
        end
        
        it "should not replace underscores in values, just keys" do
            Sculpt.make do
                p "Quack", data_said_by: :a_duck
            end.should eq "<p data-said-by=\"a_duck\">Quack</p>"
        end
    end
end