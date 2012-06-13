# Sculpt

Sculpt is an HTML generation tool in Ruby.

It's still very early in development, so have a play around and try to break it.

## Installation

    gem install sculpt

## How it works

Sculpt leverages two powerful features of Ruby to make it work; dynamic methods, and blocks. In a Sculpt block, you add a tag by calling a method with the desired tag name. If Sculpt doesn't have a pre-defined method for the tag that you want to use, it will generate a tag for you anyway, based on the method you tried to call. To nest tags, you use blocks.

## Usage

Sculpt has four class methods which you can use to generate HTML. These are `make`, `make_doc`, `render` and `render_doc`.

`make` will take a block, and return HTML. `render` will output the result of `make`.

For example:

```ruby
html = Sculpt.make do
    p "A paragraph"
end

puts html # => <p>A paragraph</p>
```

`render` saves you time by calling puts in the method:

```ruby
Sculpt.render do
    p "A paragraph"
end
# => <p>A paragraph</p>
```

`make_doc` sets up a basic HTML document for you. As `render` is to `make`, `render_doc` is to `make_doc`:

```ruby
Sculpt.render_doc do
    p "Chunky bacon."
end
# => <!DOCTYPE html><html><p>Chunky bacon</p></html>
```

### Nesting Tags

Sculpt uses blocks to nest tags.

```ruby
Sculpt.render do
    # nest html with blocks
    div do
        p "A paragraph in a div"
    end
end
# => <div><p>A paragraph in a div</p></div>
```

### Adding attributes

```ruby
Sculpt.render do
    # add attributes before blocks
    div id: :mydiv do
        p "This is a blue paragraph inside #mydiv", style:"color:blue" # or on the end of lines
    end
end
# => <div id="mydiv"><p style="color:blue">This is a blue paragraph inside #mydiv</p></div>
```

### Handy Constructors

When you call a method that isn't otherwise defined inside a Sculpt block, the method name will be assumed to be a tag, and the arguments like so:

    tag_name( text, attributes, block )

What these arguments do can vary to make certain things easier, but most of the time this will be the argument format.

Sculpt has some convenient tag constructors, which make working with certain tags a lot easier. Here are some of them:

```ruby
Sculpt.render do
    # the img constructor takes two args. the src, and the other attributes as a hash.
    img "my_lolcat.jpg", some: "attributes"

    # the a constructor takes up to 4 (link text, href, attributes, and a block)
    a "Link text", "my_page.html", some: "attributes"

    # the js and css constructors load js/css files in for you by argument, e.g:
    js "file1.js", "file2.js", "file3.js"
    # => <script type="text/javascript" src="file1.js"></script> # etc
    css "very.css", "chunky.css", "bacon.css"
    # => <link rel="stylesheet" type="text/css" href="very.css"> # etc

    # lists take arrays (optionally):
    ul ["Apple","Orange","Banana"]
    # => <ul><li>Apple</li><li>Orange</li><li>Banana</li></ul>

    # Sculpt also has static elements
    # static elements are just text (useful inside a block)
    puts "Something" # creates a static element (plain text)
end
```
       
### Other ways of embedding tags

Inside a Sculpt block, you can call any normal method with `_s` appended to the end, and it will return that element as a string. This is useful if you want to combine multiple tags, but you want to do it in one line.

```ruby
Sculpt.render do
     p "A paragraph with an " + a_s("unexpected link","the_page.html")
end
# => <p>A paragraph with an <a href="the_page.html">unexpected link</a></p>
```

You can also call tag methods directly inside another. For example:

```ruby
Sculpt.render do
    div img "lolcat.png"
end
# => <div><img src="lolcat.png"></div>
```

As pretty as the no-bracket syntax is, sometimes you will need them (esp. when working with nested tags). For example, if you wanted to give the id "mydiv" to a div containing an img, you might do something like this:

```ruby
div img "lolcat.png", id: :mydiv
# actually gives: <div><img src="my_lolcat.png" id="mydiv"></div>
```

Ruby assumes you're still in the img method, and sends the hash to the img method instead of div, so we simply separate the img method with brackets:

```ruby
div img("da_pic.png"), id: :mydiv
# => <div id="mydiv"><img src="da_pic.png"></div>
```

## An example

This example shows off some of the basic features of Sculpt. You should be comfortable with how all this works after reading the above section on usage.


```ruby
require 'sculpt'

Sculpt.render_doc do
    head do
        title "Sculpt"
        js "js/jquery.js", "js/sculpt.js"
        css "css/main.css", "css/sculpt.css"
    end
    body do
        h1 "Sculpt is an awesome HTML generation tool"
        p "Thanks to Ruby, look how sweet the syntax is!"
       
        a "Link", "http://www.google.co.uk"
       
        ul ["Apple","Orange","Banana"]
        ol ["One","Two","Three"]
       
        p "Blue paragraph", style:"color:blue"
        div id: :mydiv do
            span "This span is in a div."
        end            
    end
end
```
The output:

```html
<!DOCTYPE html>
<html>
<head>
<title>Sculpt</title>
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/sculpt.js"></script>
<link type="text/css" rel="stylesheet" href="css/main.css">
<link type="text/css" rel="stylesheet" href="css/sculpt.css">
</head>
<body>
<h1>Sculpt is an awesome HTML generation tool</h1>
<p>Thanks to Ruby, look how sweet the syntax is!</p>
<a href="http://www.google.co.uk">Link</a>
<ul>
<li>Apple</li>
<li>Orange</li>
<li>Banana</li>
</ul>
<ol>
<li>One</li>
<li>Two</li>
<li>Three</li>
</ol>
<p style="color:blue">Blue paragraph</p>
<div id="mydiv">
<span>This span is in a div.</span>
</div>
</body>
</html>
```

## Options

The Sculpt class itself has one option: `Sculpt.pretty`. This determines whether or not to print the HTML with line-breaks (in sensible places), or without any line-breaks. By default, `pretty` is on, but you may wish to have it generate HTML in a compressed format, in which case leave it off.

## Dumping to HTML

You can convert your Sculpt code to HTMl very easily. Just use something like this:

    ruby my_sculpt_script.rb > my_html.html

And that will save the output of your script to the file `my_html.html`.

## Contributing

Currently, it's just [me](http://twitter.com/#!/alexcoplan), but if anyone would like to contribute, that would be great.

Just clone the repo in the normal way:

	git clone https://github.com/alexcoplan/sculpt.git

Then make sure you can get the tests to run (it uses [rspec](http://rspec.info/)).

	cd sculpt
	rspec
	
To run code against the source, you need to be inside the Sculpt directory, and add the option `-Ilib` to include the `lib` directory. You can then call `require 'sculpt'` from inside your script to load Sculpt.

For example, when inside the sculpt directory, you can run this to use sculpt in irb:

    irb -Ilib
    > require 'sculpt'

You can then run your own code against the source (and modify the source).

If you happen to find bugs (and they're not really obscure), I would recommend adding a test once you've fixed it. Also, for features, definitely add at least one test. If it's a big feature you're considering, just let me know before hand.

## Proper Documentation

I'm working on it...