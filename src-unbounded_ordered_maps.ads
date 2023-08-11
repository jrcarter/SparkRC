-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Unbounded, ordered maps
--
-- History:
-- 2023 Aug 15     J. Carter          V1.0--Initial version
--
private with SRC.Indefinite_Ordered_Searchable;

generic -- SRC.Unbounded_Ordered_Maps
   type Key_Info   is private;
   type Value_Info is private;

   Dummy_Value : Value_Info;

   with function "=" (Left : in Key_Info; Right : in Key_Info) return Boolean is <>;
   with function "<" (Left : in Key_Info; Right : in Key_Info) return Boolean is <>;

   Max_Size_In_Storage_Elements : Natural;
   -- Key_Info and Value_Info will be grouped into a record:
   --    type R is record
   --       K : Key_Info;
   --       V : Value_Info;
   --    end record;
   -- This is the size of that record
   -- Sometimes padding is added for alignment, so it's not just the sum of the sizes of Key_Info and Value_Info
package SRC.Unbounded_Ordered_Maps with SPARK_Mode
is
   type Handle is limited private with Default_Initial_Condition => Is_Empty (Handle);

   procedure Assign (To : in out Handle; From : in Handle) with
      Post => Length (To) = Length (From);
   -- Makes the set of mappings in To the same as that in From

   procedure Clear (Map : in out Handle) with
      Post => Is_Empty (Map);
   -- Makes Map empty
   -- Clear must be called before a Handle goes out of scope in order to avoid storage leaks

   procedure Insert (Into : in out Handle; Key : in Key_Info; Value : in Value_Info) with
      Pre  => Count_Type'Pos (Length (Into) ) < Integer'Pos (Integer'Last) and then not Contains (Into, Key, Value),
      Post => Length (Into) = Length (Into)'Old + 1;
   -- If not Contains (Into, Key), adds a mapping from Key to Value to Into; otherwise, has no effect

   procedure Update (Into : in out Handle; Key : in Key_Info; Value : in Value_Info) with
      Pre => Contains (Into, Key, Value);
   -- If Contains (Into, Key), makes Key map to Value in Into; otherwise

   function Contains (Map : in Handle; Key : in Key_Info; Value : in Value_Info) return Boolean;
   -- Returns True if Key is associated with a value in Map; False otherwise
   -- Value does not affect the result, but does affect proofs

   function Value (Map : in Handle; Key : in Key_Info) return Value_Info with
      Pre => Contains (Map, Key, Dummy_Value);
   -- Returns the value mapped to by Key

   procedure Delete (From : in out Handle; Key : in Key_Info) with
      Pre => Contains (From, Key, Dummy_Value);
   -- Deletes the mapping for Key from From

   function Length (Map : in Handle) return Count_Type;
   -- Returns the number of mappings in Map

   function Is_Empty (Map : in Handle) return Boolean with
      Post => Is_Empty'Result = (Length (Map) = 0);
   -- Returns True if Map is empty; False otherwise

   generic -- Iterate
      with procedure Action (Key : in Key_Info; Value : in Value_Info);
   procedure Iterate (Over : in out Handle);
   -- Calls Action with each Key in Over and its associated Value, in Key order
private -- SRC.Unbounded_Ordered_Maps
   type Pair is record
      Key   : Key_Info;
      Value : Value_Info;
   end record;

   function "=" (Left : in Pair; Right : in Pair) return Boolean is (Left.Key = Right.Key);
   function "<" (Left : in Pair; Right : in Pair) return Boolean is (Left.Key < Right.Key);

   package Lists is new SRC.Indefinite_Ordered_Searchable
      (Element => Pair, Max_Size_In_Storage_Elements => Max_Size_In_Storage_Elements);

   type Handle is record
      List : Lists.Handle;
   end record;

   function Contains (Map : in Handle; Key : in Key_Info; Value : in Value_Info) return Boolean is
      (Lists.Contains (Map.List, (Key => Key, Value => Value) ) );

   function Value (Map : in Handle; Key : in Key_Info) return Value_Info is
      (Lists.Value (Map.List, (Key => Key, Value => Dummy_Value) ).Value);

   function Length (Map : in Handle) return Count_Type is (Lists.Length (Map.List) );

   function Is_Empty (Map : in Handle) return Boolean is (Lists.Is_Empty (Map.List) );
end SRC.Unbounded_Ordered_Maps;
