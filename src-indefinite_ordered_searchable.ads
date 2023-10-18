-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Indefinite, unbounded, ordered, O(logN)-searchable structure
--
-- History:
-- 2023 Nov 01     J. Carter          V1.1--Functional correctness proofs
-- 2023 Aug 15     J. Carter          V1.0--Initial version
--
private with Ada.Containers.Formal_Indefinite_Vectors;

generic -- SRC.Indefinite_Ordered_Searchable
   type Element (<>) is private;

   with function "=" (Left : in Element; Right : in Element) return Boolean is <>;
   with function "<" (Left : in Element; Right : in Element) return Boolean is <>;

   Max_Size_In_Storage_Elements : Natural;
   -- Maximum size of an Element
package SRC.Indefinite_Ordered_Searchable with SPARK_Mode
is
   type Handle is limited private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Assign (To : in out Handle; From : in Handle) with
      Post => Length (To) = Length (From);
   -- Makes the sequence of Elements in To, in order, the same as the sequence in From

   procedure Clear (Set : in out Handle) with
      Post => Is_Empty (Set);
   -- Makes Set empty
   -- Clear must be called before a Handle goes out of scope in order to avoid storage leaks

   procedure Insert (Into : in out Handle; Item : in Element) with
      Pre  => Count_Type'Pos (Length (Into) ) < Integer'Pos (Integer'Last) and then not Contains (Into, Item),
      Post => Length (Into) = Length (Into)'Old + 1 and Contains (Into, Item);
   -- Inserts Item into Into, in order;

   procedure Update (Into : in out Handle; Item : in Element) with
      Pre  => Contains (Into, Item),
      Post => Contains (Into, Item);
   -- Replaces the Element in Into that is = Item with Item

   function Contains (Set : in Handle; Item : in Element) return Boolean;
   -- Returns True if Set has an Element = Item; False otherwise

   function Value (Set : in Handle; Item : in Element) return Element with
      Pre  => Contains (Set, Item),
      Post => Value'Result = Item;
   -- Returns the Element in Into that is = Item

   procedure Delete (From : in out Handle; Item : in Element) with
      Pre  => Contains (From, Item),
      Post => Length (From) = Length (From)'Old - 1 and not Contains (From, Item);
   -- Deletes the Element in Into that is = Item

   function Length (Set : in Handle) return Count_Type;
   -- Returns the number of Elements in Set

   function Is_Empty (Set : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Set) = 0);
   -- Returns True if Set is empty; False otherwise

   generic -- Iterate
      with procedure Action (Item : in Element);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Element in Over in order
private -- Indefinite_Ordered_Searchable
   package Lists is new Ada.Containers.Formal_Indefinite_Vectors (Index_Type                   => Positive,
                                                                  Element_Type                 => Element,
                                                                  Max_Size_In_Storage_Elements => Max_Size_In_Storage_Elements,
                                                                  Bounded                      => False);

   type Handle is record
      List : Lists.Vector (Capacity => 1);
   end record with
      Dynamic_Predicate => Count_Type'Pos (Lists.Length (Handle.List) ) = Integer'Pos (Lists.Last_Index (Handle.List) );

   function Length (Set : in Handle) return Count_Type is (Lists.Length (Set.List) );

   function Is_Empty (Set : in Handle) return Boolean is (Lists.Is_Empty (Set.List) );
end SRC.Indefinite_Ordered_Searchable;
