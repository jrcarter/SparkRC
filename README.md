# SparkRC
SPARK Reusable Components

A couple of useful components to complement the Ada.Containers.Formal_* components: queues, stacks, an O(logN)-searchable ordered structure, and an example of using the searchable structure, maps. Most of these can be fully proven correct and free of run-time errors.

The unbounded versions are limited to Integer'Last Elements due to the use of Positive for the index of the underlying vector. This should be adequate for most uses. The index subtype may be changed if a larger limit is needed.

The indefinite forms are a little more difficult to use than the definite forms, due to the need for a function to return an object of an indefinite type (an **out** parameter may have the wrong constraint for the returned value) and a procedure to remove the object returned by the function (a SPARK function cannot have **in out** parameters). See the comments in the package specifications.

The searchable structure is not automatically fully proven functionally correct. There is no proof that the underlying vector is ordered, nor that the index returned by the binary search maintains that ordering when used to insert a value. These should be possible, but are proving beyond my abilities with SPARK at present. However, comments and assertions in the package body form a manual proof of this.

The map structure shows the use of the searchable structure; the map is correct if the searchable structure is. It also shows a pitfall of not using the searchable structure directly.

prove.ads contains some instantiations of the components for proving.

gnatprove.out contains the results of proving prove.ads with

gnatprove -P src
