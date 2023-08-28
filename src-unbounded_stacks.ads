-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Unbounded stacks
--
-- History:
-- 2023 Sep 01     J. Carter          V1.0--Initial version
--
private with Ada.Containers.Formal_Indefinite_Vectors;

generic -- SRC.Unbounded_Stacks
   type Element is private;

   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;

   Max_Size_In_Storage_Elements : Natural;
   -- Maximum size of an Element
package SRC.Unbounded_Stacks with SPARK_Mode
is
   type Handle is limited private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Assign (To : in out Handle; From : in Handle) with
      Post => Length (To) = Length (From);
   -- Makes the sequence of Elements in To, from top to bottom, the same as the sequence in From

   procedure Clear (Stack : in out Handle) with
      Post => Is_Empty (Stack);
   -- Makes Stack empty
   -- Clear must be called before a Handle goes out of scope in order to avoid storage leaks

   procedure Push (Onto : in out Handle; Item : in Element) with
      Pre  => Count_Type'Pos (Length (Onto) ) < Integer'Pos (Integer'Last),
      Post => Length (Onto) = Length (Onto)'Old + 1;
   -- Adds Item to the top of Onto

   procedure Pop (From : in out Handle; Item : out Element) with
      Pre  => not Is_Empty (From),
      Post => Length (From) = Length (From)'Old - 1;

   function Length (Stack : in Handle) return Count_Type;
   -- Returns the number of Elements in Stack

   function Is_Empty (Stack : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Stack) = 0);
   -- Returns True if Stack is empty; False otherwise

   function Peek (Stack : in Handle) return Element with
      Pre => not Is_Empty (Stack);
   -- Return the Element at the top of Stack without altering Stack

   generic -- Iterate
      with procedure Action (Item : in Element);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Element in Over in turn, from top to bottom
private -- SRC.Unbounded_Stacks
   package Lists is new Ada.Containers.Formal_Indefinite_Vectors (Index_Type                   => Positive,
                                                                  Element_Type                 => Element,
                                                                  Max_Size_In_Storage_Elements => Max_Size_In_Storage_Elements,
                                                                  Bounded                      => False);

   type Handle is record
      List : Lists.Vector (Capacity => 1);
   end record with
      Dynamic_Predicate => Count_Type'Pos (Lists.Length (Handle.List) ) = Integer'Pos (Lists.Last_Index (Handle.List) );

   function Length (Stack : in Handle) return Count_Type is (Lists.Length (Stack.List) );

   function Is_Empty (Stack : in Handle) return Boolean is (Lists.Is_Empty (Stack.List) );

   function Peek (Stack : in Handle) return Element is (Lists.Last_Element (Stack.List) );
end SRC.Unbounded_Stacks;
