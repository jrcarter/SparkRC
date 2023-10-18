# SparkRC
SPARK Reusable Components

A few useful components to complement the Ada.Containers.Formal_* components, primarily to learn about proofs and functional correctness: queues, stacks, an O(logN)-searchable ordered structure, and an example of using the searchable structure, maps. These can be fully proven to correctly implement their contracts and to be free of run-time errors.

The unbounded versions are limited to Integer'Last Elements due to the use of Positive for the index of the underlying vector. This should be adequate for most uses. The index subtype may be changed if a larger limit is needed.

The indefinite forms are a little more difficult to use than the definite forms, due to the need for a function to return an object of an indefinite type (an **out** parameter may have the wrong constraint for the returned value) and a procedure to remove the object returned by the function (a SPARK function cannot have **in out** parameters). See the comments in the package specifications.

The components have various levels of automatically fully proven functional correctness. The searchable structure seems to be almost fully proven correct, if one accepts the many assumptions used in the process. Manual proofs of the unproven aspects of correctness seem pretty simple.

The map structure shows the use of the searchable structure; it's simple to proove that the map is correct if the searchable structure is. It also shows a pitfall of not using the searchable structure directly.

prove.ads contains some instantiations of the components for proving.

gnatprove.out contains the results of proving prove.ads with

`gnatprove -P src -j 0 --level=4 --prover=all`
