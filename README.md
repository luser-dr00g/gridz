# gridz
Postscript program for grid layout.

This program expands upon the idea of performing a zipWith by mapping
over the left array with the right array stuffed in an iterator.  We
apply this to the task of placing objects in a grid by dividing up the
space and zipping the content into it. The code applies some fp
concepts like lambdas, closures, currying, memoization to make it all
happen.  Generating a procedure with embedded bound variables is
accomplished by executing the string representation of the
procedure. `({//myvar}) cvx exec` The PostScript tokenizer will
perform the desired automatic substitution of names decorated with the
double-slant `//immediately-loaded-name`. We merely have to do this
within the `begin ... end` sequence where our variables are defined.
The `to-each` function creates a curried iterator if the argument is
an array or a curried sparse-array iterator if the argument is a dict
with a `/default` key and any number of integer-keyed values,
otherwise it just creates a curried proc the reuses the same argument
whenever its called. So the right argument to the zip doesn't even
need to be an array or array-like.

Depending upon the formatter used, it can divide evenly by the number
of data rows or subtract off fixed-length segments.  Then this process
is repeated to divide the row into cells. 

Amusingly, since the zipping is performed by a combination of a map
with an iterator, we can tweak the iterator to provide extra magic.
In particular it can smooth over differences in length between the two
arrays being zipped.  If the data is specified as a normal array, the
elements will be cyclically repeated to fill additional spaces
required by the array of regions.  Or if you use the sparse array
definition it will naturally produce infinite elements.  The iterator
constructor is cached or memo-ized so when a row is repeated the
subsequent instantiations will continue from the position where the
previous iteration left off.

So the actual usage portion -- down at the bottom -- becomes nice and
short and very lenient.

To start with you define the space we're working with as an array of
four numbers `[x y X Y]` aka `[min_x min_y max_x max_y]` aka
`[LL_x LL_y UR_x UR_y]`.  For a US letter size page it's this:

    [0 0 612 792]
    
Or for landscape mode, swap the lengths and translate and rotate the
coordinate system:

    [0 0 792 612] 0 792 translate -90 rotate
    
Then you can reduce the space by adding a margin which generates an
array `[n n -n -n]` and adds it componentwise to the region.

    18 margin +

Then you put your data on the stack and call one of the layout
functions with its arguments.  As described the data can be whatever
length, but it must match the depth expected by the layout function.
(Update: it doesn't need to match the depth anymore. It will do
something different but won't complain.) All of these expect to layout
cells within rows, so the data must have two sets of brackets.

    [ [ (cell1) (cell2) (cell3) ]
      <</default(green) 2(blue)>> ]
    4 3 nbym  % both rows repeat but only one (blue) will occur
    showpage

I had to write the simpler formatters `fourby`, `byfour`, and `fourbysix` first
in order to figure out how to write `nbym`.
