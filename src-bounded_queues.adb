-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering.  All rights reserved.
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses
-- **************************************************************************
--
-- Bounded queues
--
-- History:
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
package body SRC.Bounded_Queues is
   procedure Clear (Queue : in out Handle) is
      -- Empty
   begin -- Clear
      Lists.Clear (Container => Queue.List);
   end Clear;

   procedure Put (Onto : in out Handle; Item : in Element) is
      -- Empty
   begin -- Put
      Lists.Append (Container => Onto.List, New_Item => Item);
   end Put;

   procedure Get (From : in out Handle; Item : out Element) is
      -- Empty
   begin -- Get
      Item := Lists.First_Element (From.List);
      Lists.Delete_First (Container => From.List);
   end Get;

   procedure Iterate (Over : in out Handle) is
      Position : Lists.Cursor := Lists.First (Over.List);

      use type Lists.Cursor;
   begin -- Iterate
      All_Elements : loop
         exit All_Elements when Position = Lists.No_Element;

         Action (Item => Lists.Element (Container => Over.List, Position => Position) );
         Lists.Next (Container => Over.List, Position => Position);
      end loop All_Elements;
   end Iterate;
end SRC.Bounded_Queues;
