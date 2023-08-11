-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Indefinite, unbounded, ordered, O(logN)-searchable structure
--
-- History:
-- 2023 Aug 15     J. Carter          V1.0--Initial version
--
package body SRC.Indefinite_Ordered_Searchable is
   -- A Handle's list is maintained in ascending "<" order (sorted)
   -- An empty list is sorted
   -- A list of length 1 is sorted
   -- For an Element not in a list, Find returns
   --    Unfound.At_End if Item should be appended to the list to keep the list sorted, or
   --    Unfound.Before if Item should be inserted into the list before Before to keep the list sorted
   -- Deleting an Element from a sorted list keeps the list sorted
   -- So proof that a list is always sorted becomes proof that Find is correct
   -- Assertions and comments in Find provide such a (manual) proof

   type Unfound_Location (At_End : Boolean := False) is record
      case At_End is
      when False =>
         Before : Positive;
      when True =>
         null;
      end case;
   end record;

   type Find_Result (Found : Boolean := False) is record
      case Found is
      when False =>
         Unfound : Unfound_Location;
      when True =>
         Index : Positive;
      end case;
   end record;

   function Find (List : in Lists.Vector; Item : in Element) return Find_Result with
      Post => (if Find'Result.Found then
                  Find'Result.Index in 1 .. Lists.Last_Index (List)
               elsif not Find'Result.Unfound.At_End then
                  Find'Result.Unfound.Before in 1 .. Lists.Last_Index (List)
               else
                  True);
   -- Binary search in List for Item
   -- If List contains Item, returns Found => True and Index is the index in List that is = Item
   -- Otherwise, returns Found => False and
   --    If Unfound.At_End, Item should be appended to List to keep it sorted;
   --    Otherwise, item should be inserted in List before Unfound.Before to keep it sorted

   procedure Assign (To : in out Handle; From : in Handle) is
      -- Empty
   begin -- Assign
      Lists.Assign (Target => To.List, Source => From.List);
   end Assign;

   procedure Clear (Set : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Container => Set.List);
   end Clear;

   procedure Insert (Into : in out Handle; Item : in Element) is
      Found : constant Find_Result := Find (Into.List, Item);
   begin -- Insert
      -- Into.List is sorted
      if Found.Unfound.At_End then
         Lists.Append (Container => Into.List, New_Item => Item);
          -- Into.List is sorted

         return;
      end if;

      Lists.Insert (Container => Into.List, Before => Found.Unfound.Before, New_Item => Item);
      -- Into.List is sorted
   end Insert;

   procedure Update (Into : in out Handle; Item : in Element) is
      Found : constant Find_Result := Find (Into.List, Item);
   begin -- Update
      Lists.Replace_Element (Container => Into.List, Index => Found.Index, New_Item => Item);
   end Update;

   function Contains (Set : in Handle; Item : in Element) return Boolean is (Find (Set.List, Item).Found);

   function Value (Set : in Handle; Item : in Element) return Element is (Lists.Element (Set.List, Find (Set.List, Item).Index) );

   procedure Delete (From : in out Handle; Item : in Element) is
      Found : constant Find_Result := Find (From.List, Item);
   begin -- Delete
      -- From.List is sorted
      Lists.Delete (Container => From.List, Index => Found.Index);
      -- From.List is sorted
   end Delete;

   procedure Iterate (Over : in out Handle) is
      -- Empty
   begin -- Iterate
      All_Elements : for I in 1 .. Lists.Last_Index (Over.List) loop
         Action (Item => Lists.Element (Container => Over.List, Index => I) );
      end loop All_Elements;
   end Iterate;

   function Find (List : in Lists.Vector; Item : in Element) return Find_Result is
      Low  : Positive := 1;
      High : Natural  := Lists.Last_Index (List);
      Mid  : Positive;
   begin -- Find
      if High = 0 then
         return (Found => False, Unfound => (At_End => True) );
      end if;

      pragma Assert (High in Positive);

      if Item < Lists.Element (List, 1) then
         return (Found => False, Unfound => (At_End => False, Before => 1) );
      end if;

      pragma Assert (High = Lists.Last_Index (List) );

      if Lists.Element (List, High) < Item then
         return (Found => False, Unfound => (At_End => True) );
      end if;

      pragma Assert (Low <= High);

      Search : loop
         exit Search when Low in High - 1 .. High;

         pragma Assert (Low < High);
         -- List (Low) <= Item <= List (High)

         Mid := Low + (High - Low) / 2;

         pragma Loop_Invariant (Low  in 1 .. Lists.Last_Index (List) and
                                High in 1 .. Lists.Last_Index (List) and
                                Mid  in Low .. High);

         if Item = Lists.Element (List, Mid) then
            return (Found => True, Index => Mid);
         end if;

         if Item < Lists.Element (List, Mid) then
            High := Mid;
         else
            Low := Mid;
         end if;
      end loop Search;
      -- Low = High <=> Length (List) = 1 and List (1) = Item

      if Item = Lists.Element (List, Low) then
         return (Found => True, Index => Low);
      end if;

      if Low < High and then Item = Lists.Element (List, High) then
         return (Found => True, Index => High);
      end if;
      -- Low = High - 1 and List (Low) < Item < List (High)

      return (Found => False, Unfound => (At_End => False, Before => High) );
   end Find;
end SRC.Indefinite_Ordered_Searchable;
