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
            Sculpt.make_doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones HTML doc from a string of code" do
            Sculpt.make_doc('p "test"').should eq stdres
        end
    end
    
    context "without pretty print enabled" do
        before do
            Sculpt.pretty = false
        end
        
        stdres = "<!DOCTYPE html><html><p>test</p></html>"
        
        it "should create a bare bones doc" do
            Sculpt.make_doc do
                p "test"
            end.should eq stdres
        end
        
        it "should create a bare bones doc from a string of code" do
            Sculpt.make_doc('p "test"').should eq stdres
        end
    end
end