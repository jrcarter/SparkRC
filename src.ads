-- SPARK Reusable Components (SRC)
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com
-- **************************************************************************
--
-- Root package for SPARK Reusable Components
--
-- History:
-- 2025 Jul 01     J. Carter          V1.1--Use SPDX license format
-- 2023 Aug 01     J. Carter          V1.0--Initial version
--
with Ada.Containers;

package SRC with SPARK_Mode
is
   subtype Count_Type is Ada.Containers.Count_Type;
   use type Count_Type;
   subtype Positive_Count is Count_Type range 1 .. Count_Type'Last;
end SRC;
