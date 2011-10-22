# MakeSpinner

Generate spinners for the web in the form of animated, 24-bit PNG sprites.  Helpful in the cases where an animated GIF won't work because you have a non-opaque background and the 1-bit GIF transparency doesn't look so nice.

![Sample](http://fpotter-make-spinner-sprite.s3.amazonaws.com/defaults.png)

## Usage

We use **MakeSpinner** to create the sprite, which is just a big PNG with each frame of our animation.  Then, we use this PNG as the background of a __div__ and use Javascript to rapidly switch the frames by changing the background image's offset.

### Generate the spinner sprite

    $ ./MakeSpinner -output my-spinner.png -dashes 12 -dashWidth 1.8 \
         -radiusStart 5 -radiusEnd 10 -padding 3 -color 000000
    
    Options:
	
  	Dashes:         12
  	Dash Width:     1.80
  	Radius Start:   5.00
  	Radius End:     10.00
  	Padding:        3.00
  	Color:          rgba(0.00, 0.00, 0.00, 1.00)
  	BG Color:       transparent
  	Output File:    my-spinner.png
  	
  	Generating............
  	Done.

This will create a PNG that looks like:

![Sample](http://fpotter-make-spinner-sprite.s3.amazonaws.com/defaults.png)

### Add a DIV for the spinner

	<style>
		#spinner {
			width: 26px;
			height: 26px;
			background-image: url(http://fpotter-make-spinner-sprite.s3.amazonaws.com/defaults.png);
			background-position: 0px 0px;
		}
	</style>

	<div id="spinner"></div>

The **width** and **height** should be **2 * (radiusEnd + padding)**

### Animate with Javascript

The following example uses jQuery and the [jQuery.spritely](http://spritely.net/) plug-in, but you could do this in a number of ways.

Initial setup:
	
    $('#spinner').sprite({ fps: 10, no_of_frames: 12 }).spStop();

Start animating:

    $('#spinner').spStart();

Stop animating:
	
    $('#spinner').spStop();


## Examples

You can tweak the parameters to get some different styles.

### Small, black spinner with transparent background

	./MakeSpinner -output defaults.png -dashes 12 -dashWidth 1.8 \
		-radiusStart 5 -radiusEnd 10 -padding 3 -color 000000

![Sample](http://fpotter-make-spinner-sprite.s3.amazonaws.com/defaults.png)

### Or, white dots on black blackground

	./MakeSpinner -output white-dots-on-black.png -dashes 11 -dashWidth 5 \
		-radiusStart 10 -radiusEnd 15 -padding 2 -color ffffff \
		-backgroundColor 000000

![Sample2](http://fpotter-make-spinner-sprite.s3.amazonaws.com/white-dots-on-black.png)

### Or, a thicker, blue spinner on transparent background

	./MakeSpinner -output thick-blue-dashes.png -dashes 8 -dashWidth 6 \ 
		-radiusStart 10 -radiusEnd 22 -padding 2 -color 36648B

![Sample3](http://fpotter-make-spinner-sprite.s3.amazonaws.com/thick-blue-dashes.png)

----------------------

Inspired by [staaky/spinners](https://github.com/staaky/spinners), which creates spinners in the same style but using only the __canvas__ element.
