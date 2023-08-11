# SparkRC
SPARK Reusable Components

A few useful components to complement the Ada.Containers.Formal_* components: queues, stacks, an O(logN)-searchable ordered structure, and an example of using the searchable structure, maps. Most of these can be fully proven to correctly implement their contracts and to be free of run-time errors.

The unbounded versions are limited to Integer'Last Elements due to the use of Positive for the index of the underlying vector. This should be adequate for most uses. The index subtype may be changed if a larger limit is needed.

The indefinite forms are a little more difficult to use than the definite forms, due to the need for a function to return an object of an indefinite type (an **out** parameter may have the wrong constraint for the returned value) and a procedure to remove the object returned by the function (a SPARK function cannot have **in out** parameters). See the comments in the package specifications.

None of the components are automatically fully proven functionally correct; this is especially true of the searhable structure. These proofs should be possible, but are proving beyond my abilities with SPARK at present. Manual proofs are possible, and are simple for the queues, stacks, and maps.

For the searchable structure, there is no automatic proof that the underlying vector is ordered, nor that the index returned by the binary search maintains that ordering when used to insert a value. Comments and assertions in the package body form a manual proof of this.

The map structure shows the use of the searchable structure; it's simple to proove that the map is correct if the searchable structure is. It also shows a pitfall of not using the searchable structure directly.

prove.ads contains some instantiations of the components for proving.

gnatprove.out contains the results of proving prove.ads with

`gnatprove -P src`
