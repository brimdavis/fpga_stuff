--
-- testbench for bit_count
--

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity testbench is

end testbench;


architecture bench1 of testbench is

  constant BIT_WIDTH   : natural := 128;
  constant COUNT_WIDTH : natural := 8;

  signal data      : std_logic_vector(BIT_WIDTH-1 downto 0);
  signal bit_count : std_logic_vector(COUNT_WIDTH-1 downto 0);

begin

  U1 : entity work.bit_count
    port map 
      (        
        din   => data,
        count => bit_count
      );

  P_test : process
    begin

      --
      -- all zeros
      --
      data <= (others => '0');
      wait for 10 ns;
      assert bit_count = std_logic_vector(to_unsigned(0,COUNT_WIDTH)) report "All zeros test Failed" severity FAILURE;

      --
      -- all ones
      --
      data <= (others => '1');
      wait for 10 ns;
      assert bit_count = std_logic_vector(to_unsigned(BIT_WIDTH,COUNT_WIDTH)) report "All ones test Failed" severity FAILURE;

      --
      -- loop generates walking bit patterns
      --
      for i in 0 to BIT_WIDTH-1 loop
        
        --
        -- walking one
        --
        data    <= ( others => '0');
        data(i) <=  '1';
        wait for 10 ns;

        assert bit_count = std_logic_vector(to_unsigned(1,COUNT_WIDTH)) 
          report "Test set bit #" & integer'image(i) & " Failed" 
          severity ERROR;

        --
        -- walking zero
        --
        data    <= ( others => '1');
        data(i) <= '0';
        wait for 10 ns;

        assert bit_count = std_logic_vector(to_unsigned(BIT_WIDTH-1,COUNT_WIDTH)) 
          report "Test clear bit #" & integer'image(i) & " Failed" 
          severity ERROR;

        --
        -- shifting ones
        --
        data             <= ( others => '0');
        data(i downto 0) <= ( others => '1');
        wait for 10 ns;

        assert bit_count = std_logic_vector(to_unsigned(i+1,COUNT_WIDTH)) 
          report "Test ones #" & integer'image(i) & " Failed" 
          severity ERROR;

        --
        -- shifting zeros
        --
        data             <= ( others => '1');
        data(i downto 0) <= ( others => '0');
        wait for 10 ns;

        assert bit_count = std_logic_vector(to_unsigned(BIT_WIDTH-i-1,COUNT_WIDTH)) 
          report "Test zeros #" & integer'image(i) & " Failed" 
          severity ERROR;

      end loop;

      wait;

    end process;

end bench1;
  
  
  
  
  
  
  
  
