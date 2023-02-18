--------------------------------------------------------------------------------
--IntConstMult_377_258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177_F400_uid2
-- VHDL generated for Kintex7 @ 400MHz
-- This operator is part of the Infinite Virtual Library FloPoCoLib
-- All rights reserved 
-- Authors: Florent de Dinechin, Antoine Martinet (2007-2013)
--------------------------------------------------------------------------------
-- Pipeline depth: 21 cycles
-- Clock period (ns): 2.5
-- Target frequency (MHz): 400
-- Input signals: X
-- Output signals: R

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;
library work;

entity IntConstMult_377 is
    port (clk : in std_logic;
          X : in  std_logic_vector(376 downto 0);
          R : out  std_logic_vector(753 downto 0)
          );
end entity;

architecture arch of IntConstMult_377 is
signal M1X, M1X_d1, M1X_d2 :  std_logic_vector(377 downto 0);
signal P7X_High_L, P7X_High_L_d1, P7X_High_L_d2 :  std_logic_vector(376 downto 0);
signal P7X_High_R, P7X_High_R_d1, P7X_High_R_d2 :  std_logic_vector(376 downto 0);
signal P7X, P7X_d1, P7X_d2 :  std_logic_vector(379 downto 0);
signal M9X_High_L, M9X_High_L_d1, M9X_High_L_d2 :  std_logic_vector(378 downto 0);
signal M9X_High_R, M9X_High_R_d1, M9X_High_R_d2 :  std_logic_vector(378 downto 0);
signal M9X, M9X_d1, M9X_d2 :  std_logic_vector(381 downto 0);
signal P215X_High_L, P215X_High_L_d1, P215X_High_L_d2 :  std_logic_vector(379 downto 0);
signal P215X_High_R, P215X_High_R_d1, P215X_High_R_d2 :  std_logic_vector(379 downto 0);
signal P215X :  std_logic_vector(384 downto 0);
signal P9X_High_L, P9X_High_L_d1, P9X_High_L_d2 :  std_logic_vector(377 downto 0);
signal P9X_High_R, P9X_High_R_d1, P9X_High_R_d2 :  std_logic_vector(377 downto 0);
signal P9X, P9X_d1, P9X_d2 :  std_logic_vector(380 downto 0);
signal P233X_High_L, P233X_High_L_d1, P233X_High_L_d2 :  std_logic_vector(379 downto 0);
signal P233X_High_R, P233X_High_R_d1, P233X_High_R_d2 :  std_logic_vector(379 downto 0);
signal P233X, P233X_d1, P233X_d2, P233X_d3 :  std_logic_vector(384 downto 0);
signal P440553X_High_L, P440553X_High_L_d1, P440553X_High_L_d2, P440553X_High_L_d3 :  std_logic_vector(384 downto 0);
signal P440553X_High_R, P440553X_High_R_d1, P440553X_High_R_d2, P440553X_High_R_d3 :  std_logic_vector(384 downto 0);
signal P440553X :  std_logic_vector(395 downto 0);
signal P3X_High_L, P3X_High_L_d1, P3X_High_L_d2 :  std_logic_vector(377 downto 0);
signal P3X_High_R, P3X_High_R_d1, P3X_High_R_d2 :  std_logic_vector(377 downto 0);
signal P3X, P3X_d1, P3X_d2, P3X_d3 :  std_logic_vector(378 downto 0);
signal P195X_High_L, P195X_High_L_d1, P195X_High_L_d2 :  std_logic_vector(378 downto 0);
signal P195X_High_R, P195X_High_R_d1, P195X_High_R_d2 :  std_logic_vector(378 downto 0);
signal P195X :  std_logic_vector(384 downto 0);
signal M15X_High_L, M15X_High_L_d1, M15X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M15X_High_R, M15X_High_R_d1, M15X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M15X :  std_logic_vector(381 downto 0);
signal P17X_High_L, P17X_High_L_d1, P17X_High_L_d2 :  std_logic_vector(377 downto 0);
signal P17X_High_R, P17X_High_R_d1, P17X_High_R_d2 :  std_logic_vector(377 downto 0);
signal P17X, P17X_d1, P17X_d2 :  std_logic_vector(381 downto 0);
signal M943X_High_L, M943X_High_L_d1, M943X_High_L_d2 :  std_logic_vector(381 downto 0);
signal M943X_High_R, M943X_High_R_d1, M943X_High_R_d2 :  std_logic_vector(381 downto 0);
signal M943X, M943X_d1, M943X_d2, M943X_d3 :  std_logic_vector(387 downto 0);
signal P6388817X_High_L, P6388817X_High_L_d1, P6388817X_High_L_d2, P6388817X_High_L_d3 :  std_logic_vector(384 downto 0);
signal P6388817X_High_R, P6388817X_High_R_d1, P6388817X_High_R_d2, P6388817X_High_R_d3 :  std_logic_vector(384 downto 0);
signal P6388817X, P6388817X_d1, P6388817X_d2, P6388817X_d3 :  std_logic_vector(399 downto 0);
signal P29565017750609X_High_L, P29565017750609X_High_L_d1, P29565017750609X_High_L_d2, P29565017750609X_High_L_d3 :  std_logic_vector(395 downto 0);
signal P29565017750609X_High_R, P29565017750609X_High_R_d1, P29565017750609X_High_R_d2, P29565017750609X_High_R_d3 :  std_logic_vector(395 downto 0);
signal P29565017750609X :  std_logic_vector(421 downto 0);
signal P15X_High_L, P15X_High_L_d1, P15X_High_L_d2 :  std_logic_vector(376 downto 0);
signal P15X_High_R, P15X_High_R_d1, P15X_High_R_d2 :  std_logic_vector(376 downto 0);
signal P15X, P15X_d1, P15X_d2 :  std_logic_vector(380 downto 0);
signal M5X_High_L, M5X_High_L_d1, M5X_High_L_d2 :  std_logic_vector(378 downto 0);
signal M5X_High_R, M5X_High_R_d1, M5X_High_R_d2 :  std_logic_vector(378 downto 0);
signal M5X, M5X_d1, M5X_d2, M5X_d3 :  std_logic_vector(380 downto 0);
signal P235X_High_L, P235X_High_L_d1, P235X_High_L_d2 :  std_logic_vector(380 downto 0);
signal P235X_High_R, P235X_High_R_d1, P235X_High_R_d2 :  std_logic_vector(380 downto 0);
signal P235X :  std_logic_vector(384 downto 0);
signal M7X_High_L, M7X_High_L_d1, M7X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M7X_High_R, M7X_High_R_d1, M7X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M7X, M7X_d1, M7X_d2 :  std_logic_vector(380 downto 0);
signal M231X_High_L, M231X_High_L_d1, M231X_High_L_d2 :  std_logic_vector(380 downto 0);
signal M231X_High_R, M231X_High_R_d1, M231X_High_R_d2 :  std_logic_vector(380 downto 0);
signal M231X, M231X_d1, M231X_d2, M231X_d3 :  std_logic_vector(385 downto 0);
signal P240409X_High_L, P240409X_High_L_d1, P240409X_High_L_d2, P240409X_High_L_d3 :  std_logic_vector(384 downto 0);
signal P240409X_High_R, P240409X_High_R_d1, P240409X_High_R_d2, P240409X_High_R_d3 :  std_logic_vector(384 downto 0);
signal P240409X :  std_logic_vector(394 downto 0);
signal M637X_High_L, M637X_High_L_d1, M637X_High_L_d2 :  std_logic_vector(380 downto 0);
signal M637X_High_R, M637X_High_R_d1, M637X_High_R_d2 :  std_logic_vector(380 downto 0);
signal M637X :  std_logic_vector(387 downto 0);
signal M127X_High_L, M127X_High_L_d1, M127X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M127X_High_R, M127X_High_R_d1, M127X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M127X :  std_logic_vector(384 downto 0);
signal M4069X_High_L, M4069X_High_L_d1, M4069X_High_L_d2, M4069X_High_L_d3 :  std_logic_vector(384 downto 0);
signal M4069X_High_R, M4069X_High_R_d1, M4069X_High_R_d2, M4069X_High_R_d3 :  std_logic_vector(384 downto 0);
signal M4069X, M4069X_d1, M4069X_d2 :  std_logic_vector(389 downto 0);
signal M20877285X_High_L, M20877285X_High_L_d1, M20877285X_High_L_d2, M20877285X_High_L_d3 :  std_logic_vector(387 downto 0);
signal M20877285X_High_R, M20877285X_High_R_d1, M20877285X_High_R_d2 :  std_logic_vector(387 downto 0);
signal M20877285X, M20877285X_d1, M20877285X_d2, M20877285X_d3 :  std_logic_vector(402 downto 0);
signal P64534278664219X_High_L, P64534278664219X_High_L_d1, P64534278664219X_High_L_d2, P64534278664219X_High_L_d3 :  std_logic_vector(394 downto 0);
signal P64534278664219X_High_R, P64534278664219X_High_R_d1, P64534278664219X_High_R_d2, P64534278664219X_High_R_d3 :  std_logic_vector(394 downto 0);
signal P64534278664219X, P64534278664219X_d1, P64534278664219X_d2, P64534278664219X_d3 :  std_logic_vector(422 downto 0);
signal P33287250731211262594121822235X_High_L, P33287250731211262594121822235X_High_L_d1, P33287250731211262594121822235X_High_L_d2, P33287250731211262594121822235X_High_L_d3 :  std_logic_vector(421 downto 0);
signal P33287250731211262594121822235X_High_R, P33287250731211262594121822235X_High_R_d1, P33287250731211262594121822235X_High_R_d2, P33287250731211262594121822235X_High_R_d3 :  std_logic_vector(421 downto 0);
signal P33287250731211262594121822235X :  std_logic_vector(471 downto 0);
signal P5X_High_L, P5X_High_L_d1, P5X_High_L_d2 :  std_logic_vector(377 downto 0);
signal P5X_High_R, P5X_High_R_d1, P5X_High_R_d2 :  std_logic_vector(377 downto 0);
signal P5X, P5X_d1, P5X_d2 :  std_logic_vector(379 downto 0);
signal P645X_High_L, P645X_High_L_d1, P645X_High_L_d2 :  std_logic_vector(379 downto 0);
signal P645X_High_R, P645X_High_R_d1, P645X_High_R_d2 :  std_logic_vector(379 downto 0);
signal P645X :  std_logic_vector(386 downto 0);
signal P591X_High_L, P591X_High_L_d1, P591X_High_L_d2 :  std_logic_vector(380 downto 0);
signal P591X_High_R, P591X_High_R_d1, P591X_High_R_d2 :  std_logic_vector(380 downto 0);
signal P591X, P591X_d1, P591X_d2, P591X_d3 :  std_logic_vector(386 downto 0);
signal P2642511X_High_L, P2642511X_High_L_d1, P2642511X_High_L_d2, P2642511X_High_L_d3 :  std_logic_vector(386 downto 0);
signal P2642511X_High_R, P2642511X_High_R_d1, P2642511X_High_R_d2, P2642511X_High_R_d3 :  std_logic_vector(386 downto 0);
signal P2642511X :  std_logic_vector(398 downto 0);
signal M3X_High_L, M3X_High_L_d1, M3X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M3X_High_R, M3X_High_R_d1, M3X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M3X, M3X_d1, M3X_d2, M3X_d3 :  std_logic_vector(379 downto 0);
signal M115X_High_L, M115X_High_L_d1, M115X_High_L_d2 :  std_logic_vector(380 downto 0);
signal M115X_High_R, M115X_High_R_d1, M115X_High_R_d2 :  std_logic_vector(380 downto 0);
signal M115X :  std_logic_vector(384 downto 0);
signal P279X_High_L, P279X_High_L_d1, P279X_High_L_d2 :  std_logic_vector(380 downto 0);
signal P279X_High_R, P279X_High_R_d1, P279X_High_R_d2 :  std_logic_vector(380 downto 0);
signal P279X, P279X_d1, P279X_d2, P279X_d3 :  std_logic_vector(385 downto 0);
signal M470761X_High_L, M470761X_High_L_d1, M470761X_High_L_d2, M470761X_High_L_d3 :  std_logic_vector(384 downto 0);
signal M470761X_High_R, M470761X_High_R_d1, M470761X_High_R_d2, M470761X_High_R_d3 :  std_logic_vector(384 downto 0);
signal M470761X, M470761X_d1, M470761X_d2, M470761X_d3 :  std_logic_vector(396 downto 0);
signal P5541746757911X_High_L, P5541746757911X_High_L_d1, P5541746757911X_High_L_d2, P5541746757911X_High_L_d3 :  std_logic_vector(398 downto 0);
signal P5541746757911X_High_R, P5541746757911X_High_R_d1, P5541746757911X_High_R_d2, P5541746757911X_High_R_d3 :  std_logic_vector(398 downto 0);
signal P5541746757911X :  std_logic_vector(419 downto 0);
signal M387X_High_L, M387X_High_L_d1, M387X_High_L_d2 :  std_logic_vector(379 downto 0);
signal M387X_High_R, M387X_High_R_d1, M387X_High_R_d2 :  std_logic_vector(379 downto 0);
signal M387X :  std_logic_vector(386 downto 0);
signal M255X_High_L, M255X_High_L_d1, M255X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M255X_High_R, M255X_High_R_d1, M255X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M255X :  std_logic_vector(385 downto 0);
signal M16323X_High_L, M16323X_High_L_d1, M16323X_High_L_d2, M16323X_High_L_d3 :  std_logic_vector(385 downto 0);
signal M16323X_High_R, M16323X_High_R_d1, M16323X_High_R_d2, M16323X_High_R_d3 :  std_logic_vector(385 downto 0);
signal M16323X, M16323X_d1, M16323X_d2 :  std_logic_vector(391 downto 0);
signal M25378755X_High_L, M25378755X_High_L_d1, M25378755X_High_L_d2, M25378755X_High_L_d3 :  std_logic_vector(386 downto 0);
signal M25378755X_High_R, M25378755X_High_R_d1, M25378755X_High_R_d2 :  std_logic_vector(386 downto 0);
signal M25378755X :  std_logic_vector(402 downto 0);
signal P551X_High_L, P551X_High_L_d1, P551X_High_L_d2 :  std_logic_vector(381 downto 0);
signal P551X_High_R, P551X_High_R_d1, P551X_High_R_d2 :  std_logic_vector(381 downto 0);
signal P551X :  std_logic_vector(386 downto 0);
signal P31X_High_L, P31X_High_L_d1, P31X_High_L_d2 :  std_logic_vector(376 downto 0);
signal P31X_High_R, P31X_High_R_d1, P31X_High_R_d2 :  std_logic_vector(376 downto 0);
signal P31X, P31X_d1, P31X_d2 :  std_logic_vector(381 downto 0);
signal P3871X_High_L, P3871X_High_L_d1, P3871X_High_L_d2 :  std_logic_vector(380 downto 0);
signal P3871X_High_R, P3871X_High_R_d1, P3871X_High_R_d2 :  std_logic_vector(380 downto 0);
signal P3871X, P3871X_d1, P3871X_d2, P3871X_d3 :  std_logic_vector(388 downto 0);
signal P18059039X_High_L, P18059039X_High_L_d1, P18059039X_High_L_d2, P18059039X_High_L_d3 :  std_logic_vector(386 downto 0);
signal P18059039X_High_R, P18059039X_High_R_d1, P18059039X_High_R_d2, P18059039X_High_R_d3 :  std_logic_vector(386 downto 0);
signal P18059039X, P18059039X_d1, P18059039X_d2, P18059039X_d3 :  std_logic_vector(401 downto 0);
signal M1703139399725281X_High_L, M1703139399725281X_High_L_d1, M1703139399725281X_High_L_d2, M1703139399725281X_High_L_d3 :  std_logic_vector(402 downto 0);
signal M1703139399725281X_High_R, M1703139399725281X_High_R_d1, M1703139399725281X_High_R_d2, M1703139399725281X_High_R_d3 :  std_logic_vector(402 downto 0);
signal M1703139399725281X, M1703139399725281X_d1, M1703139399725281X_d2, M1703139399725281X_d3 :  std_logic_vector(428 downto 0);
signal P49915617267817564672632262431X_High_L, P49915617267817564672632262431X_High_L_d1, P49915617267817564672632262431X_High_L_d2, P49915617267817564672632262431X_High_L_d3 :  std_logic_vector(419 downto 0);
signal P49915617267817564672632262431X_High_R, P49915617267817564672632262431X_High_R_d1, P49915617267817564672632262431X_High_R_d2, P49915617267817564672632262431X_High_R_d3 :  std_logic_vector(419 downto 0);
signal P49915617267817564672632262431X, P49915617267817564672632262431X_d1, P49915617267817564672632262431X_d2, P49915617267817564672632262431X_d3 :  std_logic_vector(472 downto 0);
signal P10549150842341881266512781758037029254081539873411274346271X_High_L, P10549150842341881266512781758037029254081539873411274346271X_High_L_d1, P10549150842341881266512781758037029254081539873411274346271X_High_L_d2, P10549150842341881266512781758037029254081539873411274346271X_High_L_d3 :  std_logic_vector(471 downto 0);
signal P10549150842341881266512781758037029254081539873411274346271X_High_R, P10549150842341881266512781758037029254081539873411274346271X_High_R_d1, P10549150842341881266512781758037029254081539873411274346271X_High_R_d2, P10549150842341881266512781758037029254081539873411274346271X_High_R_d3 :  std_logic_vector(471 downto 0);
signal P10549150842341881266512781758037029254081539873411274346271X :  std_logic_vector(569 downto 0);
signal M101X_High_L, M101X_High_L_d1, M101X_High_L_d2 :  std_logic_vector(379 downto 0);
signal M101X_High_R, M101X_High_R_d1, M101X_High_R_d2 :  std_logic_vector(379 downto 0);
signal M101X :  std_logic_vector(384 downto 0);
signal M65X_High_L, M65X_High_L_d1, M65X_High_L_d2 :  std_logic_vector(378 downto 0);
signal M65X_High_R, M65X_High_R_d1, M65X_High_R_d2 :  std_logic_vector(378 downto 0);
signal M65X, M65X_d1, M65X_d2, M65X_d3 :  std_logic_vector(384 downto 0);
signal P2239X_High_L, P2239X_High_L_d1, P2239X_High_L_d2, P2239X_High_L_d3 :  std_logic_vector(380 downto 0);
signal P2239X_High_R, P2239X_High_R_d1, P2239X_High_R_d2, P2239X_High_R_d3 :  std_logic_vector(380 downto 0);
signal P2239X, P2239X_d1, P2239X_d2 :  std_logic_vector(388 downto 0);
signal M3307329X_High_L, M3307329X_High_L_d1, M3307329X_High_L_d2, M3307329X_High_L_d3 :  std_logic_vector(384 downto 0);
signal M3307329X_High_R, M3307329X_High_R_d1, M3307329X_High_R_d2 :  std_logic_vector(384 downto 0);
signal M3307329X :  std_logic_vector(399 downto 0);
signal M1527X_High_L, M1527X_High_L_d1, M1527X_High_L_d2 :  std_logic_vector(379 downto 0);
signal M1527X_High_R, M1527X_High_R_d1, M1527X_High_R_d2 :  std_logic_vector(379 downto 0);
signal M1527X :  std_logic_vector(388 downto 0);
signal P589827X_High_L, P589827X_High_L_d1, P589827X_High_L_d2, P589827X_High_L_d3 :  std_logic_vector(380 downto 0);
signal P589827X_High_R, P589827X_High_R_d1, P589827X_High_R_d2, P589827X_High_R_d3 :  std_logic_vector(380 downto 0);
signal P589827X, P589827X_d1, P589827X_d2 :  std_logic_vector(396 downto 0);
signal M3201761277X_High_L, M3201761277X_High_L_d1, M3201761277X_High_L_d2, M3201761277X_High_L_d3 :  std_logic_vector(388 downto 0);
signal M3201761277X_High_R, M3201761277X_High_R_d1, M3201761277X_High_R_d2 :  std_logic_vector(388 downto 0);
signal M3201761277X, M3201761277X_d1, M3201761277X_d2, M3201761277X_d3 :  std_logic_vector(409 downto 0);
signal M113638962338660349X_High_L, M113638962338660349X_High_L_d1, M113638962338660349X_High_L_d2, M113638962338660349X_High_L_d3 :  std_logic_vector(399 downto 0);
signal M113638962338660349X_High_R, M113638962338660349X_High_R_d1, M113638962338660349X_High_R_d2, M113638962338660349X_High_R_d3 :  std_logic_vector(399 downto 0);
signal M113638962338660349X :  std_logic_vector(434 downto 0);
signal M489X_High_L, M489X_High_L_d1, M489X_High_L_d2 :  std_logic_vector(381 downto 0);
signal M489X_High_R, M489X_High_R_d1, M489X_High_R_d2 :  std_logic_vector(381 downto 0);
signal M489X :  std_logic_vector(386 downto 0);
signal M139X_High_L, M139X_High_L_d1, M139X_High_L_d2 :  std_logic_vector(381 downto 0);
signal M139X_High_R, M139X_High_R_d1, M139X_High_R_d2 :  std_logic_vector(381 downto 0);
signal M139X, M139X_d1, M139X_d2, M139X_d3 :  std_logic_vector(385 downto 0);
signal M250507X_High_L, M250507X_High_L_d1, M250507X_High_L_d2, M250507X_High_L_d3 :  std_logic_vector(386 downto 0);
signal M250507X_High_R, M250507X_High_R_d1, M250507X_High_R_d2, M250507X_High_R_d3 :  std_logic_vector(386 downto 0);
signal M250507X :  std_logic_vector(395 downto 0);
signal M536870911X_High_L, M536870911X_High_L_d1, M536870911X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M536870911X_High_R, M536870911X_High_R_d1, M536870911X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M536870911X, M536870911X_d1, M536870911X_d2, M536870911X_d3 :  std_logic_vector(406 downto 0);
signal P35970351105X_High_L, P35970351105X_High_L_d1, P35970351105X_High_L_d2, P35970351105X_High_L_d3 :  std_logic_vector(381 downto 0);
signal P35970351105X_High_R, P35970351105X_High_R_d1, P35970351105X_High_R_d2, P35970351105X_High_R_d3 :  std_logic_vector(381 downto 0);
signal P35970351105X :  std_logic_vector(412 downto 0);
signal P1289X_High_L, P1289X_High_L_d1, P1289X_High_L_d2 :  std_logic_vector(379 downto 0);
signal P1289X_High_R, P1289X_High_R_d1, P1289X_High_R_d2 :  std_logic_vector(379 downto 0);
signal P1289X, P1289X_d1, P1289X_d2, P1289X_d3 :  std_logic_vector(387 downto 0);
signal P1178676465009929X_High_L, P1178676465009929X_High_L_d1, P1178676465009929X_High_L_d2 :  std_logic_vector(412 downto 0);
signal P1178676465009929X_High_R, P1178676465009929X_High_R_d1, P1178676465009929X_High_R_d2, P1178676465009929X_High_R_d3 :  std_logic_vector(412 downto 0);
signal P1178676465009929X, P1178676465009929X_d1, P1178676465009929X_d2, P1178676465009929X_d3 :  std_logic_vector(427 downto 0);
signal M4512731748738338355959X_High_L, M4512731748738338355959X_High_L_d1, M4512731748738338355959X_High_L_d2, M4512731748738338355959X_High_L_d3 :  std_logic_vector(395 downto 0);
signal M4512731748738338355959X_High_R, M4512731748738338355959X_High_R_d1, M4512731748738338355959X_High_R_d2, M4512731748738338355959X_High_R_d3 :  std_logic_vector(395 downto 0);
signal M4512731748738338355959X, M4512731748738338355959X_d1, M4512731748738338355959X_d2, M4512731748738338355959X_d3 :  std_logic_vector(449 downto 0);
signal M4293158615169404361210477293766073875191X_High_L, M4293158615169404361210477293766073875191X_High_L_d1, M4293158615169404361210477293766073875191X_High_L_d2, M4293158615169404361210477293766073875191X_High_L_d3 :  std_logic_vector(434 downto 0);
signal M4293158615169404361210477293766073875191X_High_R, M4293158615169404361210477293766073875191X_High_R_d1, M4293158615169404361210477293766073875191X_High_R_d2, M4293158615169404361210477293766073875191X_High_R_d3 :  std_logic_vector(434 downto 0);
signal M4293158615169404361210477293766073875191X :  std_logic_vector(509 downto 0);
signal M70368744177663X_High_L, M70368744177663X_High_L_d1, M70368744177663X_High_L_d2 :  std_logic_vector(377 downto 0);
signal M70368744177663X_High_R, M70368744177663X_High_R_d1, M70368744177663X_High_R_d2 :  std_logic_vector(377 downto 0);
signal M70368744177663X, M70368744177663X_d1, M70368744177663X_d2, M70368744177663X_d3, M70368744177663X_d4, M70368744177663X_d5, M70368744177663X_d6, M70368744177663X_d7, M70368744177663X_d8, M70368744177663X_d9, M70368744177663X_d10, M70368744177663X_d11, M70368744177663X_d12, M70368744177663X_d13, M70368744177663X_d14, M70368744177663X_d15 :  std_logic_vector(423 downto 0);
signal M1208416721219960257327842652931743545312307085007912959X_High_L, M1208416721219960257327842652931743545312307085007912959X_High_L_d1, M1208416721219960257327842652931743545312307085007912959X_High_L_d2, M1208416721219960257327842652931743545312307085007912959X_High_L_d3, M1208416721219960257327842652931743545312307085007912959X_High_L_d4 :  std_logic_vector(509 downto 0);
signal M1208416721219960257327842652931743545312307085007912959X_High_R, M1208416721219960257327842652931743545312307085007912959X_High_R_d1, M1208416721219960257327842652931743545312307085007912959X_High_R_d2, M1208416721219960257327842652931743545312307085007912959X_High_R_d3, M1208416721219960257327842652931743545312307085007912959X_High_R_d4, M1208416721219960257327842652931743545312307085007912959X_High_R_d5, M1208416721219960257327842652931743545312307085007912959X_High_R_d6, M1208416721219960257327842652931743545312307085007912959X_High_R_d7, M1208416721219960257327842652931743545312307085007912959X_High_R_d8, M1208416721219960257327842652931743545312307085007912959X_High_R_d9, M1208416721219960257327842652931743545312307085007912959X_High_R_d10, M1208416721219960257327842652931743545312307085007912959X_High_R_d11, M1208416721219960257327842652931743545312307085007912959X_High_R_d12, M1208416721219960257327842652931743545312307085007912959X_High_R_d13, M1208416721219960257327842652931743545312307085007912959X_High_R_d14, M1208416721219960257327842652931743545312307085007912959X_High_R_d15 :  std_logic_vector(509 downto 0);
signal M1208416721219960257327842652931743545312307085007912959X, M1208416721219960257327842652931743545312307085007912959X_d1, M1208416721219960257327842652931743545312307085007912959X_d2, M1208416721219960257327842652931743545312307085007912959X_d3, M1208416721219960257327842652931743545312307085007912959X_d4 :  std_logic_vector(557 downto 0);
signal P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d1, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d2, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d3, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d4, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d5 :  std_logic_vector(569 downto 0);
signal P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d1, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d2, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d3, P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d4 :  std_logic_vector(569 downto 0);
signal P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X :  std_logic_vector(753 downto 0);
signal X_d1, X_d2 :  std_logic_vector(376 downto 0);
begin
   process(clk)
      begin
         if clk'event and clk = '1' then
            M1X_d1 <=  M1X;
            M1X_d2 <=  M1X_d1;
            P7X_High_L_d1 <=  P7X_High_L;
            P7X_High_L_d2 <=  P7X_High_L_d1;
            P7X_High_R_d1 <=  P7X_High_R;
            P7X_High_R_d2 <=  P7X_High_R_d1;
            P7X_d1 <=  P7X;
            P7X_d2 <=  P7X_d1;
            M9X_High_L_d1 <=  M9X_High_L;
            M9X_High_L_d2 <=  M9X_High_L_d1;
            M9X_High_R_d1 <=  M9X_High_R;
            M9X_High_R_d2 <=  M9X_High_R_d1;
            M9X_d1 <=  M9X;
            M9X_d2 <=  M9X_d1;
            P215X_High_L_d1 <=  P215X_High_L;
            P215X_High_L_d2 <=  P215X_High_L_d1;
            P215X_High_R_d1 <=  P215X_High_R;
            P215X_High_R_d2 <=  P215X_High_R_d1;
            P9X_High_L_d1 <=  P9X_High_L;
            P9X_High_L_d2 <=  P9X_High_L_d1;
            P9X_High_R_d1 <=  P9X_High_R;
            P9X_High_R_d2 <=  P9X_High_R_d1;
            P9X_d1 <=  P9X;
            P9X_d2 <=  P9X_d1;
            P233X_High_L_d1 <=  P233X_High_L;
            P233X_High_L_d2 <=  P233X_High_L_d1;
            P233X_High_R_d1 <=  P233X_High_R;
            P233X_High_R_d2 <=  P233X_High_R_d1;
            P233X_d1 <=  P233X;
            P233X_d2 <=  P233X_d1;
            P233X_d3 <=  P233X_d2;
            P440553X_High_L_d1 <=  P440553X_High_L;
            P440553X_High_L_d2 <=  P440553X_High_L_d1;
            P440553X_High_L_d3 <=  P440553X_High_L_d2;
            P440553X_High_R_d1 <=  P440553X_High_R;
            P440553X_High_R_d2 <=  P440553X_High_R_d1;
            P440553X_High_R_d3 <=  P440553X_High_R_d2;
            P3X_High_L_d1 <=  P3X_High_L;
            P3X_High_L_d2 <=  P3X_High_L_d1;
            P3X_High_R_d1 <=  P3X_High_R;
            P3X_High_R_d2 <=  P3X_High_R_d1;
            P3X_d1 <=  P3X;
            P3X_d2 <=  P3X_d1;
            P3X_d3 <=  P3X_d2;
            P195X_High_L_d1 <=  P195X_High_L;
            P195X_High_L_d2 <=  P195X_High_L_d1;
            P195X_High_R_d1 <=  P195X_High_R;
            P195X_High_R_d2 <=  P195X_High_R_d1;
            M15X_High_L_d1 <=  M15X_High_L;
            M15X_High_L_d2 <=  M15X_High_L_d1;
            M15X_High_R_d1 <=  M15X_High_R;
            M15X_High_R_d2 <=  M15X_High_R_d1;
            P17X_High_L_d1 <=  P17X_High_L;
            P17X_High_L_d2 <=  P17X_High_L_d1;
            P17X_High_R_d1 <=  P17X_High_R;
            P17X_High_R_d2 <=  P17X_High_R_d1;
            P17X_d1 <=  P17X;
            P17X_d2 <=  P17X_d1;
            M943X_High_L_d1 <=  M943X_High_L;
            M943X_High_L_d2 <=  M943X_High_L_d1;
            M943X_High_R_d1 <=  M943X_High_R;
            M943X_High_R_d2 <=  M943X_High_R_d1;
            M943X_d1 <=  M943X;
            M943X_d2 <=  M943X_d1;
            M943X_d3 <=  M943X_d2;
            P6388817X_High_L_d1 <=  P6388817X_High_L;
            P6388817X_High_L_d2 <=  P6388817X_High_L_d1;
            P6388817X_High_L_d3 <=  P6388817X_High_L_d2;
            P6388817X_High_R_d1 <=  P6388817X_High_R;
            P6388817X_High_R_d2 <=  P6388817X_High_R_d1;
            P6388817X_High_R_d3 <=  P6388817X_High_R_d2;
            P6388817X_d1 <=  P6388817X;
            P6388817X_d2 <=  P6388817X_d1;
            P6388817X_d3 <=  P6388817X_d2;
            P29565017750609X_High_L_d1 <=  P29565017750609X_High_L;
            P29565017750609X_High_L_d2 <=  P29565017750609X_High_L_d1;
            P29565017750609X_High_L_d3 <=  P29565017750609X_High_L_d2;
            P29565017750609X_High_R_d1 <=  P29565017750609X_High_R;
            P29565017750609X_High_R_d2 <=  P29565017750609X_High_R_d1;
            P29565017750609X_High_R_d3 <=  P29565017750609X_High_R_d2;
            P15X_High_L_d1 <=  P15X_High_L;
            P15X_High_L_d2 <=  P15X_High_L_d1;
            P15X_High_R_d1 <=  P15X_High_R;
            P15X_High_R_d2 <=  P15X_High_R_d1;
            P15X_d1 <=  P15X;
            P15X_d2 <=  P15X_d1;
            M5X_High_L_d1 <=  M5X_High_L;
            M5X_High_L_d2 <=  M5X_High_L_d1;
            M5X_High_R_d1 <=  M5X_High_R;
            M5X_High_R_d2 <=  M5X_High_R_d1;
            M5X_d1 <=  M5X;
            M5X_d2 <=  M5X_d1;
            M5X_d3 <=  M5X_d2;
            P235X_High_L_d1 <=  P235X_High_L;
            P235X_High_L_d2 <=  P235X_High_L_d1;
            P235X_High_R_d1 <=  P235X_High_R;
            P235X_High_R_d2 <=  P235X_High_R_d1;
            M7X_High_L_d1 <=  M7X_High_L;
            M7X_High_L_d2 <=  M7X_High_L_d1;
            M7X_High_R_d1 <=  M7X_High_R;
            M7X_High_R_d2 <=  M7X_High_R_d1;
            M7X_d1 <=  M7X;
            M7X_d2 <=  M7X_d1;
            M231X_High_L_d1 <=  M231X_High_L;
            M231X_High_L_d2 <=  M231X_High_L_d1;
            M231X_High_R_d1 <=  M231X_High_R;
            M231X_High_R_d2 <=  M231X_High_R_d1;
            M231X_d1 <=  M231X;
            M231X_d2 <=  M231X_d1;
            M231X_d3 <=  M231X_d2;
            P240409X_High_L_d1 <=  P240409X_High_L;
            P240409X_High_L_d2 <=  P240409X_High_L_d1;
            P240409X_High_L_d3 <=  P240409X_High_L_d2;
            P240409X_High_R_d1 <=  P240409X_High_R;
            P240409X_High_R_d2 <=  P240409X_High_R_d1;
            P240409X_High_R_d3 <=  P240409X_High_R_d2;
            M637X_High_L_d1 <=  M637X_High_L;
            M637X_High_L_d2 <=  M637X_High_L_d1;
            M637X_High_R_d1 <=  M637X_High_R;
            M637X_High_R_d2 <=  M637X_High_R_d1;
            M127X_High_L_d1 <=  M127X_High_L;
            M127X_High_L_d2 <=  M127X_High_L_d1;
            M127X_High_R_d1 <=  M127X_High_R;
            M127X_High_R_d2 <=  M127X_High_R_d1;
            M4069X_High_L_d1 <=  M4069X_High_L;
            M4069X_High_L_d2 <=  M4069X_High_L_d1;
            M4069X_High_L_d3 <=  M4069X_High_L_d2;
            M4069X_High_R_d1 <=  M4069X_High_R;
            M4069X_High_R_d2 <=  M4069X_High_R_d1;
            M4069X_High_R_d3 <=  M4069X_High_R_d2;
            M4069X_d1 <=  M4069X;
            M4069X_d2 <=  M4069X_d1;
            M20877285X_High_L_d1 <=  M20877285X_High_L;
            M20877285X_High_L_d2 <=  M20877285X_High_L_d1;
            M20877285X_High_L_d3 <=  M20877285X_High_L_d2;
            M20877285X_High_R_d1 <=  M20877285X_High_R;
            M20877285X_High_R_d2 <=  M20877285X_High_R_d1;
            M20877285X_d1 <=  M20877285X;
            M20877285X_d2 <=  M20877285X_d1;
            M20877285X_d3 <=  M20877285X_d2;
            P64534278664219X_High_L_d1 <=  P64534278664219X_High_L;
            P64534278664219X_High_L_d2 <=  P64534278664219X_High_L_d1;
            P64534278664219X_High_L_d3 <=  P64534278664219X_High_L_d2;
            P64534278664219X_High_R_d1 <=  P64534278664219X_High_R;
            P64534278664219X_High_R_d2 <=  P64534278664219X_High_R_d1;
            P64534278664219X_High_R_d3 <=  P64534278664219X_High_R_d2;
            P64534278664219X_d1 <=  P64534278664219X;
            P64534278664219X_d2 <=  P64534278664219X_d1;
            P64534278664219X_d3 <=  P64534278664219X_d2;
            P33287250731211262594121822235X_High_L_d1 <=  P33287250731211262594121822235X_High_L;
            P33287250731211262594121822235X_High_L_d2 <=  P33287250731211262594121822235X_High_L_d1;
            P33287250731211262594121822235X_High_L_d3 <=  P33287250731211262594121822235X_High_L_d2;
            P33287250731211262594121822235X_High_R_d1 <=  P33287250731211262594121822235X_High_R;
            P33287250731211262594121822235X_High_R_d2 <=  P33287250731211262594121822235X_High_R_d1;
            P33287250731211262594121822235X_High_R_d3 <=  P33287250731211262594121822235X_High_R_d2;
            P5X_High_L_d1 <=  P5X_High_L;
            P5X_High_L_d2 <=  P5X_High_L_d1;
            P5X_High_R_d1 <=  P5X_High_R;
            P5X_High_R_d2 <=  P5X_High_R_d1;
            P5X_d1 <=  P5X;
            P5X_d2 <=  P5X_d1;
            P645X_High_L_d1 <=  P645X_High_L;
            P645X_High_L_d2 <=  P645X_High_L_d1;
            P645X_High_R_d1 <=  P645X_High_R;
            P645X_High_R_d2 <=  P645X_High_R_d1;
            P591X_High_L_d1 <=  P591X_High_L;
            P591X_High_L_d2 <=  P591X_High_L_d1;
            P591X_High_R_d1 <=  P591X_High_R;
            P591X_High_R_d2 <=  P591X_High_R_d1;
            P591X_d1 <=  P591X;
            P591X_d2 <=  P591X_d1;
            P591X_d3 <=  P591X_d2;
            P2642511X_High_L_d1 <=  P2642511X_High_L;
            P2642511X_High_L_d2 <=  P2642511X_High_L_d1;
            P2642511X_High_L_d3 <=  P2642511X_High_L_d2;
            P2642511X_High_R_d1 <=  P2642511X_High_R;
            P2642511X_High_R_d2 <=  P2642511X_High_R_d1;
            P2642511X_High_R_d3 <=  P2642511X_High_R_d2;
            M3X_High_L_d1 <=  M3X_High_L;
            M3X_High_L_d2 <=  M3X_High_L_d1;
            M3X_High_R_d1 <=  M3X_High_R;
            M3X_High_R_d2 <=  M3X_High_R_d1;
            M3X_d1 <=  M3X;
            M3X_d2 <=  M3X_d1;
            M3X_d3 <=  M3X_d2;
            M115X_High_L_d1 <=  M115X_High_L;
            M115X_High_L_d2 <=  M115X_High_L_d1;
            M115X_High_R_d1 <=  M115X_High_R;
            M115X_High_R_d2 <=  M115X_High_R_d1;
            P279X_High_L_d1 <=  P279X_High_L;
            P279X_High_L_d2 <=  P279X_High_L_d1;
            P279X_High_R_d1 <=  P279X_High_R;
            P279X_High_R_d2 <=  P279X_High_R_d1;
            P279X_d1 <=  P279X;
            P279X_d2 <=  P279X_d1;
            P279X_d3 <=  P279X_d2;
            M470761X_High_L_d1 <=  M470761X_High_L;
            M470761X_High_L_d2 <=  M470761X_High_L_d1;
            M470761X_High_L_d3 <=  M470761X_High_L_d2;
            M470761X_High_R_d1 <=  M470761X_High_R;
            M470761X_High_R_d2 <=  M470761X_High_R_d1;
            M470761X_High_R_d3 <=  M470761X_High_R_d2;
            M470761X_d1 <=  M470761X;
            M470761X_d2 <=  M470761X_d1;
            M470761X_d3 <=  M470761X_d2;
            P5541746757911X_High_L_d1 <=  P5541746757911X_High_L;
            P5541746757911X_High_L_d2 <=  P5541746757911X_High_L_d1;
            P5541746757911X_High_L_d3 <=  P5541746757911X_High_L_d2;
            P5541746757911X_High_R_d1 <=  P5541746757911X_High_R;
            P5541746757911X_High_R_d2 <=  P5541746757911X_High_R_d1;
            P5541746757911X_High_R_d3 <=  P5541746757911X_High_R_d2;
            M387X_High_L_d1 <=  M387X_High_L;
            M387X_High_L_d2 <=  M387X_High_L_d1;
            M387X_High_R_d1 <=  M387X_High_R;
            M387X_High_R_d2 <=  M387X_High_R_d1;
            M255X_High_L_d1 <=  M255X_High_L;
            M255X_High_L_d2 <=  M255X_High_L_d1;
            M255X_High_R_d1 <=  M255X_High_R;
            M255X_High_R_d2 <=  M255X_High_R_d1;
            M16323X_High_L_d1 <=  M16323X_High_L;
            M16323X_High_L_d2 <=  M16323X_High_L_d1;
            M16323X_High_L_d3 <=  M16323X_High_L_d2;
            M16323X_High_R_d1 <=  M16323X_High_R;
            M16323X_High_R_d2 <=  M16323X_High_R_d1;
            M16323X_High_R_d3 <=  M16323X_High_R_d2;
            M16323X_d1 <=  M16323X;
            M16323X_d2 <=  M16323X_d1;
            M25378755X_High_L_d1 <=  M25378755X_High_L;
            M25378755X_High_L_d2 <=  M25378755X_High_L_d1;
            M25378755X_High_L_d3 <=  M25378755X_High_L_d2;
            M25378755X_High_R_d1 <=  M25378755X_High_R;
            M25378755X_High_R_d2 <=  M25378755X_High_R_d1;
            P551X_High_L_d1 <=  P551X_High_L;
            P551X_High_L_d2 <=  P551X_High_L_d1;
            P551X_High_R_d1 <=  P551X_High_R;
            P551X_High_R_d2 <=  P551X_High_R_d1;
            P31X_High_L_d1 <=  P31X_High_L;
            P31X_High_L_d2 <=  P31X_High_L_d1;
            P31X_High_R_d1 <=  P31X_High_R;
            P31X_High_R_d2 <=  P31X_High_R_d1;
            P31X_d1 <=  P31X;
            P31X_d2 <=  P31X_d1;
            P3871X_High_L_d1 <=  P3871X_High_L;
            P3871X_High_L_d2 <=  P3871X_High_L_d1;
            P3871X_High_R_d1 <=  P3871X_High_R;
            P3871X_High_R_d2 <=  P3871X_High_R_d1;
            P3871X_d1 <=  P3871X;
            P3871X_d2 <=  P3871X_d1;
            P3871X_d3 <=  P3871X_d2;
            P18059039X_High_L_d1 <=  P18059039X_High_L;
            P18059039X_High_L_d2 <=  P18059039X_High_L_d1;
            P18059039X_High_L_d3 <=  P18059039X_High_L_d2;
            P18059039X_High_R_d1 <=  P18059039X_High_R;
            P18059039X_High_R_d2 <=  P18059039X_High_R_d1;
            P18059039X_High_R_d3 <=  P18059039X_High_R_d2;
            P18059039X_d1 <=  P18059039X;
            P18059039X_d2 <=  P18059039X_d1;
            P18059039X_d3 <=  P18059039X_d2;
            M1703139399725281X_High_L_d1 <=  M1703139399725281X_High_L;
            M1703139399725281X_High_L_d2 <=  M1703139399725281X_High_L_d1;
            M1703139399725281X_High_L_d3 <=  M1703139399725281X_High_L_d2;
            M1703139399725281X_High_R_d1 <=  M1703139399725281X_High_R;
            M1703139399725281X_High_R_d2 <=  M1703139399725281X_High_R_d1;
            M1703139399725281X_High_R_d3 <=  M1703139399725281X_High_R_d2;
            M1703139399725281X_d1 <=  M1703139399725281X;
            M1703139399725281X_d2 <=  M1703139399725281X_d1;
            M1703139399725281X_d3 <=  M1703139399725281X_d2;
            P49915617267817564672632262431X_High_L_d1 <=  P49915617267817564672632262431X_High_L;
            P49915617267817564672632262431X_High_L_d2 <=  P49915617267817564672632262431X_High_L_d1;
            P49915617267817564672632262431X_High_L_d3 <=  P49915617267817564672632262431X_High_L_d2;
            P49915617267817564672632262431X_High_R_d1 <=  P49915617267817564672632262431X_High_R;
            P49915617267817564672632262431X_High_R_d2 <=  P49915617267817564672632262431X_High_R_d1;
            P49915617267817564672632262431X_High_R_d3 <=  P49915617267817564672632262431X_High_R_d2;
            P49915617267817564672632262431X_d1 <=  P49915617267817564672632262431X;
            P49915617267817564672632262431X_d2 <=  P49915617267817564672632262431X_d1;
            P49915617267817564672632262431X_d3 <=  P49915617267817564672632262431X_d2;
            P10549150842341881266512781758037029254081539873411274346271X_High_L_d1 <=  P10549150842341881266512781758037029254081539873411274346271X_High_L;
            P10549150842341881266512781758037029254081539873411274346271X_High_L_d2 <=  P10549150842341881266512781758037029254081539873411274346271X_High_L_d1;
            P10549150842341881266512781758037029254081539873411274346271X_High_L_d3 <=  P10549150842341881266512781758037029254081539873411274346271X_High_L_d2;
            P10549150842341881266512781758037029254081539873411274346271X_High_R_d1 <=  P10549150842341881266512781758037029254081539873411274346271X_High_R;
            P10549150842341881266512781758037029254081539873411274346271X_High_R_d2 <=  P10549150842341881266512781758037029254081539873411274346271X_High_R_d1;
            P10549150842341881266512781758037029254081539873411274346271X_High_R_d3 <=  P10549150842341881266512781758037029254081539873411274346271X_High_R_d2;
            M101X_High_L_d1 <=  M101X_High_L;
            M101X_High_L_d2 <=  M101X_High_L_d1;
            M101X_High_R_d1 <=  M101X_High_R;
            M101X_High_R_d2 <=  M101X_High_R_d1;
            M65X_High_L_d1 <=  M65X_High_L;
            M65X_High_L_d2 <=  M65X_High_L_d1;
            M65X_High_R_d1 <=  M65X_High_R;
            M65X_High_R_d2 <=  M65X_High_R_d1;
            M65X_d1 <=  M65X;
            M65X_d2 <=  M65X_d1;
            M65X_d3 <=  M65X_d2;
            P2239X_High_L_d1 <=  P2239X_High_L;
            P2239X_High_L_d2 <=  P2239X_High_L_d1;
            P2239X_High_L_d3 <=  P2239X_High_L_d2;
            P2239X_High_R_d1 <=  P2239X_High_R;
            P2239X_High_R_d2 <=  P2239X_High_R_d1;
            P2239X_High_R_d3 <=  P2239X_High_R_d2;
            P2239X_d1 <=  P2239X;
            P2239X_d2 <=  P2239X_d1;
            M3307329X_High_L_d1 <=  M3307329X_High_L;
            M3307329X_High_L_d2 <=  M3307329X_High_L_d1;
            M3307329X_High_L_d3 <=  M3307329X_High_L_d2;
            M3307329X_High_R_d1 <=  M3307329X_High_R;
            M3307329X_High_R_d2 <=  M3307329X_High_R_d1;
            M1527X_High_L_d1 <=  M1527X_High_L;
            M1527X_High_L_d2 <=  M1527X_High_L_d1;
            M1527X_High_R_d1 <=  M1527X_High_R;
            M1527X_High_R_d2 <=  M1527X_High_R_d1;
            P589827X_High_L_d1 <=  P589827X_High_L;
            P589827X_High_L_d2 <=  P589827X_High_L_d1;
            P589827X_High_L_d3 <=  P589827X_High_L_d2;
            P589827X_High_R_d1 <=  P589827X_High_R;
            P589827X_High_R_d2 <=  P589827X_High_R_d1;
            P589827X_High_R_d3 <=  P589827X_High_R_d2;
            P589827X_d1 <=  P589827X;
            P589827X_d2 <=  P589827X_d1;
            M3201761277X_High_L_d1 <=  M3201761277X_High_L;
            M3201761277X_High_L_d2 <=  M3201761277X_High_L_d1;
            M3201761277X_High_L_d3 <=  M3201761277X_High_L_d2;
            M3201761277X_High_R_d1 <=  M3201761277X_High_R;
            M3201761277X_High_R_d2 <=  M3201761277X_High_R_d1;
            M3201761277X_d1 <=  M3201761277X;
            M3201761277X_d2 <=  M3201761277X_d1;
            M3201761277X_d3 <=  M3201761277X_d2;
            M113638962338660349X_High_L_d1 <=  M113638962338660349X_High_L;
            M113638962338660349X_High_L_d2 <=  M113638962338660349X_High_L_d1;
            M113638962338660349X_High_L_d3 <=  M113638962338660349X_High_L_d2;
            M113638962338660349X_High_R_d1 <=  M113638962338660349X_High_R;
            M113638962338660349X_High_R_d2 <=  M113638962338660349X_High_R_d1;
            M113638962338660349X_High_R_d3 <=  M113638962338660349X_High_R_d2;
            M489X_High_L_d1 <=  M489X_High_L;
            M489X_High_L_d2 <=  M489X_High_L_d1;
            M489X_High_R_d1 <=  M489X_High_R;
            M489X_High_R_d2 <=  M489X_High_R_d1;
            M139X_High_L_d1 <=  M139X_High_L;
            M139X_High_L_d2 <=  M139X_High_L_d1;
            M139X_High_R_d1 <=  M139X_High_R;
            M139X_High_R_d2 <=  M139X_High_R_d1;
            M139X_d1 <=  M139X;
            M139X_d2 <=  M139X_d1;
            M139X_d3 <=  M139X_d2;
            M250507X_High_L_d1 <=  M250507X_High_L;
            M250507X_High_L_d2 <=  M250507X_High_L_d1;
            M250507X_High_L_d3 <=  M250507X_High_L_d2;
            M250507X_High_R_d1 <=  M250507X_High_R;
            M250507X_High_R_d2 <=  M250507X_High_R_d1;
            M250507X_High_R_d3 <=  M250507X_High_R_d2;
            M536870911X_High_L_d1 <=  M536870911X_High_L;
            M536870911X_High_L_d2 <=  M536870911X_High_L_d1;
            M536870911X_High_R_d1 <=  M536870911X_High_R;
            M536870911X_High_R_d2 <=  M536870911X_High_R_d1;
            M536870911X_d1 <=  M536870911X;
            M536870911X_d2 <=  M536870911X_d1;
            M536870911X_d3 <=  M536870911X_d2;
            P35970351105X_High_L_d1 <=  P35970351105X_High_L;
            P35970351105X_High_L_d2 <=  P35970351105X_High_L_d1;
            P35970351105X_High_L_d3 <=  P35970351105X_High_L_d2;
            P35970351105X_High_R_d1 <=  P35970351105X_High_R;
            P35970351105X_High_R_d2 <=  P35970351105X_High_R_d1;
            P35970351105X_High_R_d3 <=  P35970351105X_High_R_d2;
            P1289X_High_L_d1 <=  P1289X_High_L;
            P1289X_High_L_d2 <=  P1289X_High_L_d1;
            P1289X_High_R_d1 <=  P1289X_High_R;
            P1289X_High_R_d2 <=  P1289X_High_R_d1;
            P1289X_d1 <=  P1289X;
            P1289X_d2 <=  P1289X_d1;
            P1289X_d3 <=  P1289X_d2;
            P1178676465009929X_High_L_d1 <=  P1178676465009929X_High_L;
            P1178676465009929X_High_L_d2 <=  P1178676465009929X_High_L_d1;
            P1178676465009929X_High_R_d1 <=  P1178676465009929X_High_R;
            P1178676465009929X_High_R_d2 <=  P1178676465009929X_High_R_d1;
            P1178676465009929X_High_R_d3 <=  P1178676465009929X_High_R_d2;
            P1178676465009929X_d1 <=  P1178676465009929X;
            P1178676465009929X_d2 <=  P1178676465009929X_d1;
            P1178676465009929X_d3 <=  P1178676465009929X_d2;
            M4512731748738338355959X_High_L_d1 <=  M4512731748738338355959X_High_L;
            M4512731748738338355959X_High_L_d2 <=  M4512731748738338355959X_High_L_d1;
            M4512731748738338355959X_High_L_d3 <=  M4512731748738338355959X_High_L_d2;
            M4512731748738338355959X_High_R_d1 <=  M4512731748738338355959X_High_R;
            M4512731748738338355959X_High_R_d2 <=  M4512731748738338355959X_High_R_d1;
            M4512731748738338355959X_High_R_d3 <=  M4512731748738338355959X_High_R_d2;
            M4512731748738338355959X_d1 <=  M4512731748738338355959X;
            M4512731748738338355959X_d2 <=  M4512731748738338355959X_d1;
            M4512731748738338355959X_d3 <=  M4512731748738338355959X_d2;
            M4293158615169404361210477293766073875191X_High_L_d1 <=  M4293158615169404361210477293766073875191X_High_L;
            M4293158615169404361210477293766073875191X_High_L_d2 <=  M4293158615169404361210477293766073875191X_High_L_d1;
            M4293158615169404361210477293766073875191X_High_L_d3 <=  M4293158615169404361210477293766073875191X_High_L_d2;
            M4293158615169404361210477293766073875191X_High_R_d1 <=  M4293158615169404361210477293766073875191X_High_R;
            M4293158615169404361210477293766073875191X_High_R_d2 <=  M4293158615169404361210477293766073875191X_High_R_d1;
            M4293158615169404361210477293766073875191X_High_R_d3 <=  M4293158615169404361210477293766073875191X_High_R_d2;
            M70368744177663X_High_L_d1 <=  M70368744177663X_High_L;
            M70368744177663X_High_L_d2 <=  M70368744177663X_High_L_d1;
            M70368744177663X_High_R_d1 <=  M70368744177663X_High_R;
            M70368744177663X_High_R_d2 <=  M70368744177663X_High_R_d1;
            M70368744177663X_d1 <=  M70368744177663X;
            M70368744177663X_d2 <=  M70368744177663X_d1;
            M70368744177663X_d3 <=  M70368744177663X_d2;
            M70368744177663X_d4 <=  M70368744177663X_d3;
            M70368744177663X_d5 <=  M70368744177663X_d4;
            M70368744177663X_d6 <=  M70368744177663X_d5;
            M70368744177663X_d7 <=  M70368744177663X_d6;
            M70368744177663X_d8 <=  M70368744177663X_d7;
            M70368744177663X_d9 <=  M70368744177663X_d8;
            M70368744177663X_d10 <=  M70368744177663X_d9;
            M70368744177663X_d11 <=  M70368744177663X_d10;
            M70368744177663X_d12 <=  M70368744177663X_d11;
            M70368744177663X_d13 <=  M70368744177663X_d12;
            M70368744177663X_d14 <=  M70368744177663X_d13;
            M70368744177663X_d15 <=  M70368744177663X_d14;
            M1208416721219960257327842652931743545312307085007912959X_High_L_d1 <=  M1208416721219960257327842652931743545312307085007912959X_High_L;
            M1208416721219960257327842652931743545312307085007912959X_High_L_d2 <=  M1208416721219960257327842652931743545312307085007912959X_High_L_d1;
            M1208416721219960257327842652931743545312307085007912959X_High_L_d3 <=  M1208416721219960257327842652931743545312307085007912959X_High_L_d2;
            M1208416721219960257327842652931743545312307085007912959X_High_L_d4 <=  M1208416721219960257327842652931743545312307085007912959X_High_L_d3;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d1 <=  M1208416721219960257327842652931743545312307085007912959X_High_R;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d2 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d1;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d3 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d2;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d4 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d3;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d5 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d4;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d6 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d5;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d7 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d6;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d8 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d7;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d9 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d8;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d10 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d9;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d11 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d10;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d12 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d11;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d13 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d12;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d14 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d13;
            M1208416721219960257327842652931743545312307085007912959X_High_R_d15 <=  M1208416721219960257327842652931743545312307085007912959X_High_R_d14;
            M1208416721219960257327842652931743545312307085007912959X_d1 <=  M1208416721219960257327842652931743545312307085007912959X;
            M1208416721219960257327842652931743545312307085007912959X_d2 <=  M1208416721219960257327842652931743545312307085007912959X_d1;
            M1208416721219960257327842652931743545312307085007912959X_d3 <=  M1208416721219960257327842652931743545312307085007912959X_d2;
            M1208416721219960257327842652931743545312307085007912959X_d4 <=  M1208416721219960257327842652931743545312307085007912959X_d3;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d1 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d2 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d1;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d3 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d2;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d4 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d3;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d5 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d4;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d1 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d2 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d1;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d3 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d2;
            P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d4 <=  P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d3;
            X_d1 <=  X;
            X_d2 <=  X_d1;
         end if;
      end process;
   M1X <= (377 downto 0 => '0') - X;

   -- P7X <-  X<<3  + M1X
   P7X_High_L <= X(376 downto 0) ;
   P7X_High_R <=  (379 downto 378 => M1X(377)) & M1X(377 downto 3); 
   P7X(379 downto 3) <= P7X_High_R_d2 + P7X_High_L_d2;   -- sum of higher bits
   P7X(2 downto 0) <= M1X_d2(2 downto 0);   -- lower bits untouched

   -- M9X <-  M1X<<3  + M1X
   M9X_High_L <=  (381 downto 381 => M1X(377)) & M1X(377 downto 0) ;
   M9X_High_R <=  (381 downto 378 => M1X(377)) & M1X(377 downto 3); 
   M9X(381 downto 3) <= M9X_High_R_d2 + M9X_High_L_d2;   -- sum of higher bits
   M9X(2 downto 0) <= M1X_d2(2 downto 0);   -- lower bits untouched

   -- P215X <-  P7X<<5  + M9X
   P215X_High_L <= P7X(379 downto 0) ;
   P215X_High_R <=  (384 downto 382 => M9X(381)) & M9X(381 downto 5); 
   P215X(384 downto 5) <= P215X_High_R_d2 + P215X_High_L_d2;   -- sum of higher bits
   P215X(4 downto 0) <= M9X_d2(4 downto 0);   -- lower bits untouched

   -- P9X <-  X<<3  + X
   P9X_High_L <=  (380 downto 380 => '0') & X(376 downto 0) ;
   P9X_High_R <=  (380 downto 377 => '0') & X(376 downto 3); 
   P9X(380 downto 3) <= P9X_High_R_d2 + P9X_High_L_d2;   -- sum of higher bits
   P9X(2 downto 0) <= X_d2(2 downto 0);   -- lower bits untouched

   -- P233X <-  P7X<<5  + P9X
   P233X_High_L <= P7X(379 downto 0) ;
   P233X_High_R <=  (384 downto 381 => '0') & P9X(380 downto 5); 
   P233X(384 downto 5) <= P233X_High_R_d2 + P233X_High_L_d2;   -- sum of higher bits
   P233X(4 downto 0) <= P9X_d2(4 downto 0);   -- lower bits untouched

   -- P440553X <-  P215X<<11  + P233X
   P440553X_High_L <= P215X(384 downto 0) ;
   P440553X_High_R <=  (395 downto 385 => '0') & P233X(384 downto 11); 
   P440553X(395 downto 11) <= P440553X_High_R_d3 + P440553X_High_L_d3;   -- sum of higher bits
   P440553X(10 downto 0) <= P233X_d3(10 downto 0);   -- lower bits untouched

   -- P3X <-  X<<1  + X
   P3X_High_L <=  (378 downto 378 => '0') & X(376 downto 0) ;
   P3X_High_R <=  (378 downto 377 => '0') & X(376 downto 1); 
   P3X(378 downto 1) <= P3X_High_R_d2 + P3X_High_L_d2;   -- sum of higher bits
   P3X(0 downto 0) <= X_d2(0 downto 0);   -- lower bits untouched

   -- P195X <-  P3X<<6  + P3X
   P195X_High_L <= P3X(378 downto 0) ;
   P195X_High_R <=  (384 downto 379 => '0') & P3X(378 downto 6); 
   P195X(384 downto 6) <= P195X_High_R_d2 + P195X_High_L_d2;   -- sum of higher bits
   P195X(5 downto 0) <= P3X_d2(5 downto 0);   -- lower bits untouched

   -- M15X <-  M1X<<4  + X
   M15X_High_L <= M1X(377 downto 0) ;
   M15X_High_R <=  (381 downto 377 => '0') & X(376 downto 4); 
   M15X(381 downto 4) <= M15X_High_R_d2 + M15X_High_L_d2;   -- sum of higher bits
   M15X(3 downto 0) <= X_d2(3 downto 0);   -- lower bits untouched

   -- P17X <-  X<<4  + X
   P17X_High_L <=  (381 downto 381 => '0') & X(376 downto 0) ;
   P17X_High_R <=  (381 downto 377 => '0') & X(376 downto 4); 
   P17X(381 downto 4) <= P17X_High_R_d2 + P17X_High_L_d2;   -- sum of higher bits
   P17X(3 downto 0) <= X_d2(3 downto 0);   -- lower bits untouched

   -- M943X <-  M15X<<6  + P17X
   M943X_High_L <= M15X(381 downto 0) ;
   M943X_High_R <=  (387 downto 382 => '0') & P17X(381 downto 6); 
   M943X(387 downto 6) <= M943X_High_R_d2 + M943X_High_L_d2;   -- sum of higher bits
   M943X(5 downto 0) <= P17X_d2(5 downto 0);   -- lower bits untouched

   -- P6388817X <-  P195X<<15  + M943X
   P6388817X_High_L <= P195X(384 downto 0) ;
   P6388817X_High_R <=  (399 downto 388 => M943X(387)) & M943X(387 downto 15); 
   P6388817X(399 downto 15) <= P6388817X_High_R_d3 + P6388817X_High_L_d3;   -- sum of higher bits
   P6388817X(14 downto 0) <= M943X_d3(14 downto 0);   -- lower bits untouched

   -- P29565017750609X <-  P440553X<<26  + P6388817X
   P29565017750609X_High_L <= P440553X(395 downto 0) ;
   P29565017750609X_High_R <=  (421 downto 400 => '0') & P6388817X(399 downto 26); 
   P29565017750609X(421 downto 26) <= P29565017750609X_High_R_d3 + P29565017750609X_High_L_d3;   -- sum of higher bits
   P29565017750609X(25 downto 0) <= P6388817X_d3(25 downto 0);   -- lower bits untouched

   -- P15X <-  X<<4  + M1X
   P15X_High_L <= X(376 downto 0) ;
   P15X_High_R <=  (380 downto 378 => M1X(377)) & M1X(377 downto 4); 
   P15X(380 downto 4) <= P15X_High_R_d2 + P15X_High_L_d2;   -- sum of higher bits
   P15X(3 downto 0) <= M1X_d2(3 downto 0);   -- lower bits untouched

   -- M5X <-  M1X<<2  + M1X
   M5X_High_L <=  (380 downto 380 => M1X(377)) & M1X(377 downto 0) ;
   M5X_High_R <=  (380 downto 378 => M1X(377)) & M1X(377 downto 2); 
   M5X(380 downto 2) <= M5X_High_R_d2 + M5X_High_L_d2;   -- sum of higher bits
   M5X(1 downto 0) <= M1X_d2(1 downto 0);   -- lower bits untouched

   -- P235X <-  P15X<<4  + M5X
   P235X_High_L <= P15X(380 downto 0) ;
   P235X_High_R <=  (384 downto 381 => M5X(380)) & M5X(380 downto 4); 
   P235X(384 downto 4) <= P235X_High_R_d2 + P235X_High_L_d2;   -- sum of higher bits
   P235X(3 downto 0) <= M5X_d2(3 downto 0);   -- lower bits untouched

   -- M7X <-  M1X<<3  + X
   M7X_High_L <= M1X(377 downto 0) ;
   M7X_High_R <=  (380 downto 377 => '0') & X(376 downto 3); 
   M7X(380 downto 3) <= M7X_High_R_d2 + M7X_High_L_d2;   -- sum of higher bits
   M7X(2 downto 0) <= X_d2(2 downto 0);   -- lower bits untouched

   -- M231X <-  M7X<<5  + M7X
   M231X_High_L <= M7X(380 downto 0) ;
   M231X_High_R <=  (385 downto 381 => M7X(380)) & M7X(380 downto 5); 
   M231X(385 downto 5) <= M231X_High_R_d2 + M231X_High_L_d2;   -- sum of higher bits
   M231X(4 downto 0) <= M7X_d2(4 downto 0);   -- lower bits untouched

   -- P240409X <-  P235X<<10  + M231X
   P240409X_High_L <= P235X(384 downto 0) ;
   P240409X_High_R <=  (394 downto 386 => M231X(385)) & M231X(385 downto 10); 
   P240409X(394 downto 10) <= P240409X_High_R_d3 + P240409X_High_L_d3;   -- sum of higher bits
   P240409X(9 downto 0) <= M231X_d3(9 downto 0);   -- lower bits untouched

   -- M637X <-  M5X<<7  + P3X
   M637X_High_L <= M5X(380 downto 0) ;
   M637X_High_R <=  (387 downto 379 => '0') & P3X(378 downto 7); 
   M637X(387 downto 7) <= M637X_High_R_d2 + M637X_High_L_d2;   -- sum of higher bits
   M637X(6 downto 0) <= P3X_d2(6 downto 0);   -- lower bits untouched

   -- M127X <-  M1X<<7  + X
   M127X_High_L <= M1X(377 downto 0) ;
   M127X_High_R <=  (384 downto 377 => '0') & X(376 downto 7); 
   M127X(384 downto 7) <= M127X_High_R_d2 + M127X_High_L_d2;   -- sum of higher bits
   M127X(6 downto 0) <= X_d2(6 downto 0);   -- lower bits untouched

   -- M4069X <-  M127X<<5  + M5X
   M4069X_High_L <= M127X(384 downto 0) ;
   M4069X_High_R <=  (389 downto 381 => M5X(380)) & M5X(380 downto 5); 
   M4069X(389 downto 5) <= M4069X_High_R_d3 + M4069X_High_L_d3;   -- sum of higher bits
   M4069X(4 downto 0) <= M5X_d3(4 downto 0);   -- lower bits untouched

   -- M20877285X <-  M637X<<15  + M4069X
   M20877285X_High_L <= M637X(387 downto 0) ;
   M20877285X_High_R <=  (402 downto 390 => M4069X(389)) & M4069X(389 downto 15); 
   M20877285X(402 downto 15) <= M20877285X_High_R_d2 + M20877285X_High_L_d3;   -- sum of higher bits
   M20877285X(14 downto 0) <= M4069X_d2(14 downto 0);   -- lower bits untouched

   -- P64534278664219X <-  P240409X<<28  + M20877285X
   P64534278664219X_High_L <= P240409X(394 downto 0) ;
   P64534278664219X_High_R <=  (422 downto 403 => M20877285X(402)) & M20877285X(402 downto 28); 
   P64534278664219X(422 downto 28) <= P64534278664219X_High_R_d3 + P64534278664219X_High_L_d3;   -- sum of higher bits
   P64534278664219X(27 downto 0) <= M20877285X_d3(27 downto 0);   -- lower bits untouched

   -- P33287250731211262594121822235X <-  P29565017750609X<<50  + P64534278664219X
   P33287250731211262594121822235X_High_L <= P29565017750609X(421 downto 0) ;
   P33287250731211262594121822235X_High_R <=  (471 downto 423 => '0') & P64534278664219X(422 downto 50); 
   P33287250731211262594121822235X(471 downto 50) <= P33287250731211262594121822235X_High_R_d3 + P33287250731211262594121822235X_High_L_d3;   -- sum of higher bits
   P33287250731211262594121822235X(49 downto 0) <= P64534278664219X_d3(49 downto 0);   -- lower bits untouched

   -- P5X <-  X<<2  + X
   P5X_High_L <=  (379 downto 379 => '0') & X(376 downto 0) ;
   P5X_High_R <=  (379 downto 377 => '0') & X(376 downto 2); 
   P5X(379 downto 2) <= P5X_High_R_d2 + P5X_High_L_d2;   -- sum of higher bits
   P5X(1 downto 0) <= X_d2(1 downto 0);   -- lower bits untouched

   -- P645X <-  P5X<<7  + P5X
   P645X_High_L <= P5X(379 downto 0) ;
   P645X_High_R <=  (386 downto 380 => '0') & P5X(379 downto 7); 
   P645X(386 downto 7) <= P645X_High_R_d2 + P645X_High_L_d2;   -- sum of higher bits
   P645X(6 downto 0) <= P5X_d2(6 downto 0);   -- lower bits untouched

   -- P591X <-  P9X<<6  + P15X
   P591X_High_L <= P9X(380 downto 0) ;
   P591X_High_R <=  (386 downto 381 => '0') & P15X(380 downto 6); 
   P591X(386 downto 6) <= P591X_High_R_d2 + P591X_High_L_d2;   -- sum of higher bits
   P591X(5 downto 0) <= P15X_d2(5 downto 0);   -- lower bits untouched

   -- P2642511X <-  P645X<<12  + P591X
   P2642511X_High_L <= P645X(386 downto 0) ;
   P2642511X_High_R <=  (398 downto 387 => '0') & P591X(386 downto 12); 
   P2642511X(398 downto 12) <= P2642511X_High_R_d3 + P2642511X_High_L_d3;   -- sum of higher bits
   P2642511X(11 downto 0) <= P591X_d3(11 downto 0);   -- lower bits untouched

   -- M3X <-  M1X<<2  + X
   M3X_High_L <= M1X(377 downto 0) ;
   M3X_High_R <=  (379 downto 377 => '0') & X(376 downto 2); 
   M3X(379 downto 2) <= M3X_High_R_d2 + M3X_High_L_d2;   -- sum of higher bits
   M3X(1 downto 0) <= X_d2(1 downto 0);   -- lower bits untouched

   -- M115X <-  M7X<<4  + M3X
   M115X_High_L <= M7X(380 downto 0) ;
   M115X_High_R <=  (384 downto 380 => M3X(379)) & M3X(379 downto 4); 
   M115X(384 downto 4) <= M115X_High_R_d2 + M115X_High_L_d2;   -- sum of higher bits
   M115X(3 downto 0) <= M3X_d2(3 downto 0);   -- lower bits untouched

   -- P279X <-  P9X<<5  + M9X
   P279X_High_L <= P9X(380 downto 0) ;
   P279X_High_R <=  (385 downto 382 => M9X(381)) & M9X(381 downto 5); 
   P279X(385 downto 5) <= P279X_High_R_d2 + P279X_High_L_d2;   -- sum of higher bits
   P279X(4 downto 0) <= M9X_d2(4 downto 0);   -- lower bits untouched

   -- M470761X <-  M115X<<12  + P279X
   M470761X_High_L <= M115X(384 downto 0) ;
   M470761X_High_R <=  (396 downto 386 => '0') & P279X(385 downto 12); 
   M470761X(396 downto 12) <= M470761X_High_R_d3 + M470761X_High_L_d3;   -- sum of higher bits
   M470761X(11 downto 0) <= P279X_d3(11 downto 0);   -- lower bits untouched

   -- P5541746757911X <-  P2642511X<<21  + M470761X
   P5541746757911X_High_L <= P2642511X(398 downto 0) ;
   P5541746757911X_High_R <=  (419 downto 397 => M470761X(396)) & M470761X(396 downto 21); 
   P5541746757911X(419 downto 21) <= P5541746757911X_High_R_d3 + P5541746757911X_High_L_d3;   -- sum of higher bits
   P5541746757911X(20 downto 0) <= M470761X_d3(20 downto 0);   -- lower bits untouched

   -- M387X <-  M3X<<7  + M3X
   M387X_High_L <= M3X(379 downto 0) ;
   M387X_High_R <=  (386 downto 380 => M3X(379)) & M3X(379 downto 7); 
   M387X(386 downto 7) <= M387X_High_R_d2 + M387X_High_L_d2;   -- sum of higher bits
   M387X(6 downto 0) <= M3X_d2(6 downto 0);   -- lower bits untouched

   -- M255X <-  M1X<<8  + X
   M255X_High_L <= M1X(377 downto 0) ;
   M255X_High_R <=  (385 downto 377 => '0') & X(376 downto 8); 
   M255X(385 downto 8) <= M255X_High_R_d2 + M255X_High_L_d2;   -- sum of higher bits
   M255X(7 downto 0) <= X_d2(7 downto 0);   -- lower bits untouched

   -- M16323X <-  M255X<<6  + M3X
   M16323X_High_L <= M255X(385 downto 0) ;
   M16323X_High_R <=  (391 downto 380 => M3X(379)) & M3X(379 downto 6); 
   M16323X(391 downto 6) <= M16323X_High_R_d3 + M16323X_High_L_d3;   -- sum of higher bits
   M16323X(5 downto 0) <= M3X_d3(5 downto 0);   -- lower bits untouched

   -- M25378755X <-  M387X<<16  + M16323X
   M25378755X_High_L <= M387X(386 downto 0) ;
   M25378755X_High_R <=  (402 downto 392 => M16323X(391)) & M16323X(391 downto 16); 
   M25378755X(402 downto 16) <= M25378755X_High_R_d2 + M25378755X_High_L_d3;   -- sum of higher bits
   M25378755X(15 downto 0) <= M16323X_d2(15 downto 0);   -- lower bits untouched

   -- P551X <-  P17X<<5  + P7X
   P551X_High_L <= P17X(381 downto 0) ;
   P551X_High_R <=  (386 downto 380 => '0') & P7X(379 downto 5); 
   P551X(386 downto 5) <= P551X_High_R_d2 + P551X_High_L_d2;   -- sum of higher bits
   P551X(4 downto 0) <= P7X_d2(4 downto 0);   -- lower bits untouched

   -- P31X <-  X<<5  + M1X
   P31X_High_L <= X(376 downto 0) ;
   P31X_High_R <=  (381 downto 378 => M1X(377)) & M1X(377 downto 5); 
   P31X(381 downto 5) <= P31X_High_R_d2 + P31X_High_L_d2;   -- sum of higher bits
   P31X(4 downto 0) <= M1X_d2(4 downto 0);   -- lower bits untouched

   -- P3871X <-  P15X<<8  + P31X
   P3871X_High_L <= P15X(380 downto 0) ;
   P3871X_High_R <=  (388 downto 382 => '0') & P31X(381 downto 8); 
   P3871X(388 downto 8) <= P3871X_High_R_d2 + P3871X_High_L_d2;   -- sum of higher bits
   P3871X(7 downto 0) <= P31X_d2(7 downto 0);   -- lower bits untouched

   -- P18059039X <-  P551X<<15  + P3871X
   P18059039X_High_L <= P551X(386 downto 0) ;
   P18059039X_High_R <=  (401 downto 389 => '0') & P3871X(388 downto 15); 
   P18059039X(401 downto 15) <= P18059039X_High_R_d3 + P18059039X_High_L_d3;   -- sum of higher bits
   P18059039X(14 downto 0) <= P3871X_d3(14 downto 0);   -- lower bits untouched

   -- M1703139399725281X <-  M25378755X<<26  + P18059039X
   M1703139399725281X_High_L <= M25378755X(402 downto 0) ;
   M1703139399725281X_High_R <=  (428 downto 402 => '0') & P18059039X(401 downto 26); 
   M1703139399725281X(428 downto 26) <= M1703139399725281X_High_R_d3 + M1703139399725281X_High_L_d3;   -- sum of higher bits
   M1703139399725281X(25 downto 0) <= P18059039X_d3(25 downto 0);   -- lower bits untouched

   -- P49915617267817564672632262431X <-  P5541746757911X<<53  + M1703139399725281X
   P49915617267817564672632262431X_High_L <= P5541746757911X(419 downto 0) ;
   P49915617267817564672632262431X_High_R <=  (472 downto 429 => M1703139399725281X(428)) & M1703139399725281X(428 downto 53); 
   P49915617267817564672632262431X(472 downto 53) <= P49915617267817564672632262431X_High_R_d3 + P49915617267817564672632262431X_High_L_d3;   -- sum of higher bits
   P49915617267817564672632262431X(52 downto 0) <= M1703139399725281X_d3(52 downto 0);   -- lower bits untouched

   -- P10549150842341881266512781758037029254081539873411274346271X <-  P33287250731211262594121822235X<<98  + P49915617267817564672632262431X
   P10549150842341881266512781758037029254081539873411274346271X_High_L <= P33287250731211262594121822235X(471 downto 0) ;
   P10549150842341881266512781758037029254081539873411274346271X_High_R <=  (569 downto 473 => '0') & P49915617267817564672632262431X(472 downto 98); 
   P10549150842341881266512781758037029254081539873411274346271X(569 downto 98) <= P10549150842341881266512781758037029254081539873411274346271X_High_R_d3 + P10549150842341881266512781758037029254081539873411274346271X_High_L_d3;   -- sum of higher bits
   P10549150842341881266512781758037029254081539873411274346271X(97 downto 0) <= P49915617267817564672632262431X_d3(97 downto 0);   -- lower bits untouched

   -- M101X <-  M3X<<5  + M5X
   M101X_High_L <= M3X(379 downto 0) ;
   M101X_High_R <=  (384 downto 381 => M5X(380)) & M5X(380 downto 5); 
   M101X(384 downto 5) <= M101X_High_R_d2 + M101X_High_L_d2;   -- sum of higher bits
   M101X(4 downto 0) <= M5X_d2(4 downto 0);   -- lower bits untouched

   -- M65X <-  M1X<<6  + M1X
   M65X_High_L <=  (384 downto 384 => M1X(377)) & M1X(377 downto 0) ;
   M65X_High_R <=  (384 downto 378 => M1X(377)) & M1X(377 downto 6); 
   M65X(384 downto 6) <= M65X_High_R_d2 + M65X_High_L_d2;   -- sum of higher bits
   M65X(5 downto 0) <= M1X_d2(5 downto 0);   -- lower bits untouched

   -- P2239X <-  P9X<<8  + M65X
   P2239X_High_L <= P9X(380 downto 0) ;
   P2239X_High_R <=  (388 downto 385 => M65X(384)) & M65X(384 downto 8); 
   P2239X(388 downto 8) <= P2239X_High_R_d3 + P2239X_High_L_d3;   -- sum of higher bits
   P2239X(7 downto 0) <= M65X_d3(7 downto 0);   -- lower bits untouched

   -- M3307329X <-  M101X<<15  + P2239X
   M3307329X_High_L <= M101X(384 downto 0) ;
   M3307329X_High_R <=  (399 downto 389 => '0') & P2239X(388 downto 15); 
   M3307329X(399 downto 15) <= M3307329X_High_R_d2 + M3307329X_High_L_d3;   -- sum of higher bits
   M3307329X(14 downto 0) <= P2239X_d2(14 downto 0);   -- lower bits untouched

   -- M1527X <-  M3X<<9  + P9X
   M1527X_High_L <= M3X(379 downto 0) ;
   M1527X_High_R <=  (388 downto 381 => '0') & P9X(380 downto 9); 
   M1527X(388 downto 9) <= M1527X_High_R_d2 + M1527X_High_L_d2;   -- sum of higher bits
   M1527X(8 downto 0) <= P9X_d2(8 downto 0);   -- lower bits untouched

   -- P589827X <-  P9X<<16  + P3X
   P589827X_High_L <= P9X(380 downto 0) ;
   P589827X_High_R <=  (396 downto 379 => '0') & P3X(378 downto 16); 
   P589827X(396 downto 16) <= P589827X_High_R_d3 + P589827X_High_L_d3;   -- sum of higher bits
   P589827X(15 downto 0) <= P3X_d3(15 downto 0);   -- lower bits untouched

   -- M3201761277X <-  M1527X<<21  + P589827X
   M3201761277X_High_L <= M1527X(388 downto 0) ;
   M3201761277X_High_R <=  (409 downto 397 => '0') & P589827X(396 downto 21); 
   M3201761277X(409 downto 21) <= M3201761277X_High_R_d2 + M3201761277X_High_L_d3;   -- sum of higher bits
   M3201761277X(20 downto 0) <= P589827X_d2(20 downto 0);   -- lower bits untouched

   -- M113638962338660349X <-  M3307329X<<35  + M3201761277X
   M113638962338660349X_High_L <= M3307329X(399 downto 0) ;
   M113638962338660349X_High_R <=  (434 downto 410 => M3201761277X(409)) & M3201761277X(409 downto 35); 
   M113638962338660349X(434 downto 35) <= M113638962338660349X_High_R_d3 + M113638962338660349X_High_L_d3;   -- sum of higher bits
   M113638962338660349X(34 downto 0) <= M3201761277X_d3(34 downto 0);   -- lower bits untouched

   -- M489X <-  M15X<<5  + M9X
   M489X_High_L <= M15X(381 downto 0) ;
   M489X_High_R <=  (386 downto 382 => M9X(381)) & M9X(381 downto 5); 
   M489X(386 downto 5) <= M489X_High_R_d2 + M489X_High_L_d2;   -- sum of higher bits
   M489X(4 downto 0) <= M9X_d2(4 downto 0);   -- lower bits untouched

   -- M139X <-  M9X<<4  + P5X
   M139X_High_L <= M9X(381 downto 0) ;
   M139X_High_R <=  (385 downto 380 => '0') & P5X(379 downto 4); 
   M139X(385 downto 4) <= M139X_High_R_d2 + M139X_High_L_d2;   -- sum of higher bits
   M139X(3 downto 0) <= P5X_d2(3 downto 0);   -- lower bits untouched

   -- M250507X <-  M489X<<9  + M139X
   M250507X_High_L <= M489X(386 downto 0) ;
   M250507X_High_R <=  (395 downto 386 => M139X(385)) & M139X(385 downto 9); 
   M250507X(395 downto 9) <= M250507X_High_R_d3 + M250507X_High_L_d3;   -- sum of higher bits
   M250507X(8 downto 0) <= M139X_d3(8 downto 0);   -- lower bits untouched

   -- M536870911X <-  M1X<<29  + X
   M536870911X_High_L <= M1X(377 downto 0) ;
   M536870911X_High_R <=  (406 downto 377 => '0') & X(376 downto 29); 
   M536870911X(406 downto 29) <= M536870911X_High_R_d2 + M536870911X_High_L_d2;   -- sum of higher bits
   M536870911X(28 downto 0) <= X_d2(28 downto 0);   -- lower bits untouched

   -- P35970351105X <-  P17X<<31  + M536870911X
   P35970351105X_High_L <= P17X(381 downto 0) ;
   P35970351105X_High_R <=  (412 downto 407 => M536870911X(406)) & M536870911X(406 downto 31); 
   P35970351105X(412 downto 31) <= P35970351105X_High_R_d3 + P35970351105X_High_L_d3;   -- sum of higher bits
   P35970351105X(30 downto 0) <= M536870911X_d3(30 downto 0);   -- lower bits untouched

   -- P1289X <-  P5X<<8  + P9X
   P1289X_High_L <= P5X(379 downto 0) ;
   P1289X_High_R <=  (387 downto 381 => '0') & P9X(380 downto 8); 
   P1289X(387 downto 8) <= P1289X_High_R_d2 + P1289X_High_L_d2;   -- sum of higher bits
   P1289X(7 downto 0) <= P9X_d2(7 downto 0);   -- lower bits untouched

   -- P1178676465009929X <-  P35970351105X<<15  + P1289X
   P1178676465009929X_High_L <= P35970351105X(412 downto 0) ;
   P1178676465009929X_High_R <=  (427 downto 388 => '0') & P1289X(387 downto 15); 
   P1178676465009929X(427 downto 15) <= P1178676465009929X_High_R_d3 + P1178676465009929X_High_L_d2;   -- sum of higher bits
   P1178676465009929X(14 downto 0) <= P1289X_d3(14 downto 0);   -- lower bits untouched

   -- M4512731748738338355959X <-  M250507X<<54  + P1178676465009929X
   M4512731748738338355959X_High_L <= M250507X(395 downto 0) ;
   M4512731748738338355959X_High_R <=  (449 downto 428 => '0') & P1178676465009929X(427 downto 54); 
   M4512731748738338355959X(449 downto 54) <= M4512731748738338355959X_High_R_d3 + M4512731748738338355959X_High_L_d3;   -- sum of higher bits
   M4512731748738338355959X(53 downto 0) <= P1178676465009929X_d3(53 downto 0);   -- lower bits untouched

   -- M4293158615169404361210477293766073875191X <-  M113638962338660349X<<75  + M4512731748738338355959X
   M4293158615169404361210477293766073875191X_High_L <= M113638962338660349X(434 downto 0) ;
   M4293158615169404361210477293766073875191X_High_R <=  (509 downto 450 => M4512731748738338355959X(449)) & M4512731748738338355959X(449 downto 75); 
   M4293158615169404361210477293766073875191X(509 downto 75) <= M4293158615169404361210477293766073875191X_High_R_d3 + M4293158615169404361210477293766073875191X_High_L_d3;   -- sum of higher bits
   M4293158615169404361210477293766073875191X(74 downto 0) <= M4512731748738338355959X_d3(74 downto 0);   -- lower bits untouched

   -- M70368744177663X <-  M1X<<46  + X
   M70368744177663X_High_L <= M1X(377 downto 0) ;
   M70368744177663X_High_R <=  (423 downto 377 => '0') & X(376 downto 46); 
   M70368744177663X(423 downto 46) <= M70368744177663X_High_R_d2 + M70368744177663X_High_L_d2;   -- sum of higher bits
   M70368744177663X(45 downto 0) <= X_d2(45 downto 0);   -- lower bits untouched

   -- M1208416721219960257327842652931743545312307085007912959X <-  M4293158615169404361210477293766073875191X<<48  + M70368744177663X
   M1208416721219960257327842652931743545312307085007912959X_High_L <= M4293158615169404361210477293766073875191X(509 downto 0) ;
   M1208416721219960257327842652931743545312307085007912959X_High_R <=  (557 downto 424 => M70368744177663X(423)) & M70368744177663X(423 downto 48); 
   M1208416721219960257327842652931743545312307085007912959X(557 downto 48) <= M1208416721219960257327842652931743545312307085007912959X_High_R_d15 + M1208416721219960257327842652931743545312307085007912959X_High_L_d4;   -- sum of higher bits
   M1208416721219960257327842652931743545312307085007912959X(47 downto 0) <= M70368744177663X_d15(47 downto 0);   -- lower bits untouched

   -- P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X <-  P10549150842341881266512781758037029254081539873411274346271X<<184  + M1208416721219960257327842652931743545312307085007912959X
   P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L <= P10549150842341881266512781758037029254081539873411274346271X(569 downto 0) ;
   P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R <=  (753 downto 558 => M1208416721219960257327842652931743545312307085007912959X(557)) & M1208416721219960257327842652931743545312307085007912959X(557 downto 184); 
   P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X(753 downto 184) <= P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_R_d4 + P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X_High_L_d5;   -- sum of higher bits
   P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X(183 downto 0) <= M1208416721219960257327842652931743545312307085007912959X_d4(183 downto 0);   -- lower bits untouched

   R <= P258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177X(753 downto 0);
end architecture;

