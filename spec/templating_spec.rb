require 'spec_helper'

describe Sculpt::Templating do    
    context "with pretty print enabled" do
        before do
            Sculpt.pretty = true
        end

        it "should create and render a single template" do
            t = template do
                div.templated do
                    render
                end
            end

            t.make do
                p "hi"
            end.doctest "
            <div class=\"templated\">
            <p>hi</p>
            </div>"
        end

        it "should create and render a single template doc" do        
            t = template_doc do
                head do
                    css "the_zen_of.css"
                    js "not_your_mothers.js"
                end
                body do
                    div.content do
                        render
                    end
                end
            end

            t.make do
                p "Only the chunkiest bacon you've ever seen."
            end.doctest "
            <!DOCTYPE html>
            <html>
            <head>
            <link type=\"text/css\" rel=\"stylesheet\" href=\"the_zen_of.css\">
            <script type=\"text/javascript\" src=\"not_your_mothers.js\"></script>
            </head>
            <body>
            <div class=\"content\">
            <p>Only the chunkiest bacon you've ever seen.</p>
            </div>
            </body>
            </html>"
        end
        
        it "should create and render a template with multiple sections" do
            t = template_doc do |includes, content|
                head do
                    css "main.css"
                    render includes
                end
                body do
                    div id: :main do
                        render content
                    end
                end
            end
            
            t.make do
                includes { css "test.css" }
                content do
                    h1 "an amusing"
                    p "test case"
                end
            end.doctest "
            <!DOCTYPE html>
            <html>
            <head>
            <link type=\"text/css\" rel=\"stylesheet\" href=\"main.css\">
            <link type=\"text/css\" rel=\"stylesheet\" href=\"test.css\">
            </head>
            <body>
            <div id=\"main\">
            <h1>an amusing</h1>
            <p>test case</p>
            </div>
            </body>
            </html>"
        end
        
        it "should support single inline template rendering" do
            t = template do
                div.templated render
            end
            t.make do
                p "dat content"
            end.doctest "
            <div class=\"templated\">
            <p>dat content</p>
            </div>"
        end
        
        it "should support multiple inline template rendering" do
            t = template do |multiple, parts|
                div render multiple
                span render parts
            end
            t.make do
                multiple { p "hi" }
                parts { p "bye" }
            end.doctest "
            <div>
            <p>hi</p>
            </div>
            <span>
            <p>bye</p>
            </span>"
        end

        it "should inject a file into a single part template" do
            t = template do
                div.bacon do
                    render
                end
            end

            t.load(fsym "p.rb").doctest "
            <div class=\"bacon\">
            <p>in a file</p>
            </div>"
        end

        it "should inject a file into a multi part template" do
            t = template do |a, b|
                div.bret render a
                span.jemaine render b
            end

            t.load(fstr "multi.rb").doctest "
            <div class=\"bret\">
            <p>the humans are</p>
            </div>
            <span class=\"jemaine\">
            <p>dead</p>
            </span>"
        end

        it "should create a single part template from a file" do
            t = template fsym("temp")
            t.make { p "bar" }.doctest "
            <div class=\"this_is\">
            <span class=\"in_a_file\">
            <p>bar</p>
            </span>
            </div>"
        end
    end
    
    context "without pretty print enabled" do
        # fewer specs without pretty print enabled
        # since most likely to fail on the pp option.
        
        before do
            Sculpt.pretty = false
        end
        
        it "should create and render a single template" do
            t = template do
                div.templated do
                    render
                end
            end

            t.make do
                p "hi"
            end.should eq "<div class=\"templated\"><p>hi</p></div>"
        end
        
        it "should create and render a signle template doc" do        
            t = template_doc do
                head do
                    css "the_zen_of.css"
                    js "not_your_mothers.js"
                end
                body do
                    div.content do
                        render
                    end
                end
            end

            t.make do
                p "Only the chunkiest bacon you've ever seen."
            end.npptest "
            <!DOCTYPE html>
            <html>
            <head>
            <link type=\"text/css\" rel=\"stylesheet\" href=\"the_zen_of.css\">
            <script type=\"text/javascript\" src=\"not_your_mothers.js\"></script>
            </head>
            <body>
            <div class=\"content\">
            <p>Only the chunkiest bacon you've ever seen.</p>
            </div>
            </body>
            </html>"
        end
    end
end  