# gridz
Postscript program for grid layout

This program expands upon the idea of placing objects in a grid by
dividing up the space and zipping the content into it.

Depending upon the formatter used, it can divide evenly by the number
of data rows or subtract off fixed-length segments. Then this process
is repeated to divide the row into cells. 

Amusingly, since the zipping is performed by a combination of a map
with an iterator, we can tweak the iterator to provide extra magic.
In particular it can smooth over differences in length between the two
arrays being zipped. If the data is specified as a normal array, the
elements will by cyclically repeated to fill additional spaces
required by the array of cells. Or if you use the sparse array definition
it will naturally produce infinite elements.

So the actual usage portion -- down at the bottom -- becomes nice and
short and very lenient.

To start with you define the space we're working with. For a US letter
size page it's this:

    [0 0 612 792]
    
Or for landscape mode, swap the lengths and translate and rotate the
coordinate system:

    [0 0 792 612] 0 792 translate -90 rotate
    
Then you can reduce the space by adding a margin which generates a
array `[n n -n -n]` and adds it componentwise to the region.

    18 margin +

Then you put your data and call one of the layout functions with its
arguments.  As described the data can be whatever length, but it must
match the depth expected by the layout function. All of these expect
to layout cells within rows, so the data must have two sets of
brackets.

    [ [ (cell1) (cell2) (cell3) ]
      <</default(green) 2(blue)>> ]
    4 3 nbym
    showpage
