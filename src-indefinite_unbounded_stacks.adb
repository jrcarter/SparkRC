-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Indefinite unbounded stacks
--
-- History:
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
package body SRC.Indefinite_Unbounded_Stacks is
   procedure Assign (To : in out Handle; From : in Handle) is
      -- Empty
   begin -- Assign
      Lists.Assign (Target => To.List, Source => From.List);
   end Assign;

   procedure Clear (Stack : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Container => Stack.List);
   end Clear;

   procedure Push (Onto : in out Handle; Item : in Element) is
      -- Empty
   begin -- Push
      Lists.Append (Container => Onto.List, New_Item => Item);
   end Push;

   procedure Remove_Top (From : in out Handle) is
      -- Empty
   begin -- Remove_Top
      Lists.Delete_Last (Container => From.List);
   end Remove_Top;

   procedure Iterate (Over : in out Handle) is
   begin -- Iterate
      All_Elements : for I in reverse 1 .. Lists.Last_Index (Over.List) loop
         Action (Item => Lists.Element (Container => Over.List, Index => I) );
      end loop All_Elements;
   end Iterate;
end SRC.Indefinite_Unbounded_Stacks;
