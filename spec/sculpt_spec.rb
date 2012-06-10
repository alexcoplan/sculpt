require 'spec_helper'

## this spec is for testing generic sculpt features
## for tag speces see sculpture_spec

describe Sculpt do
    context "with pretty print enabled" do
        before do
            Sculpt.pretty = true
        end
        
        it "should create a pretty bare bones HTML doc" do
            res = Sculpt.make_doc do
                p "test"
            end
            res.should eq "<!DOCTYPE html>\n<html>\n<p>test</p>\n</html>"
        end
    end
    
    context "without pretty print enabled" do
        before do
            Sculpt.pretty = false
        end
        
        it "should create a bare bones doc with no newlines" do
            res = Sculpt.make_doc do
                p "test"
            end
            res.should eq "<!DOCTYPE html><html><p>test</p></html>"
        end
    end
end