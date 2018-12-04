--
-- top level fpga, needed to bind widths of unconstrained bit_count() ports
--
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
                                
entity fpga_top is
  port 
    (        
      din    : in  std_logic_vector(127 downto 0);   -- 128 bit input vector
      count  : out std_logic_vector(  7 downto 0)    --   8 bits are needed to handle counts from 0 to 128
    );

end fpga_top;


architecture arch1 of fpga_top is

begin

  U1 : entity work.bit_count
    port map 
      (        
        din   => din,
        count => count
      );

end arch1;
