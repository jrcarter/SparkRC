-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Bounded stacks
--
-- History:
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
package body SRC.Bounded_Stacks is
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

   procedure Pop (From : in out Handle; Item : out Element) is
      -- Empty
   begin -- Pop
      Item := Lists.Last_Element (From.List);
      Lists.Delete_Last (Container => From.List);
   end Pop;

   procedure Iterate (Over : in out Handle) is
      Position : Lists.Cursor := Lists.Last (Over.List);

      use type Lists.Cursor;
   begin -- Iterate
      All_Elements : loop
         exit All_Elements when Position = Lists.No_Element;

         Action (Item => Lists.Element (Container => Over.List, Position => Position) );
         Lists.Previous (Container => Over.List, Position => Position);
      end loop All_Elements;
   end Iterate;
end SRC.Bounded_Stacks;
