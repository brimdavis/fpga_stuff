--
-- <bit_count.vhd>
--

---------------------------------------------------------------
--
-- (C) COPYRIGHT 2018  Brian Davis
--
-- Code released under the terms of the MIT license
-- https://opensource.org/licenses/MIT
--
---------------------------------------------------------------

--
-- bit counting 
--
--   - uses classical software shift-and-mask addition technique to count bits
--     XST optimizes this into a tree of small adders
--

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;


entity bit_count is
  port
    (   
      din    : in  std_logic_vector;
      count  : out std_logic_vector
    );

end bit_count;


architecture combinatorial_looped_mask of bit_count is

  constant SIZE : natural := din'LENGTH;
  
  --
  -- produces bit mask arrays to add consecutive groups of bits, e.g.
  --
  -- STAGE  MASK
  --   1    X"5555_5555"
  --   2    X"3333_3333"
  --   3    X"0707_0707"
  --   4    X"000f_000f"
  --
  function bit_mask( stage : natural ) return unsigned is
    variable mask : unsigned(SIZE-1 downto 0);

    constant STRIDE : natural := 2**stage;
    variable i      : natural := 0;

  begin

     mask := ( others => '0');

     while i < SIZE loop

       for j in 0 to stage-1 loop
         if i+j < SIZE then mask(i+j) := '1'; end if;
       end loop;

       i := i + STRIDE;

     end loop;

     return mask;
  end;


  --
  -- number of adder stages needed to cover the input vector length
  --
  constant STAGES : natural := natural( ceil( log2( real(SIZE) ) ));

  --
  -- note there are STAGES+1 entries in array
  --
  type t_sum_array is array(0 to STAGES) of unsigned(SIZE-1 downto 0);

  --
  -- using a signal for sums, instead of a variable in the process,
  -- makes converting this code to a clocked version easier
  --
  signal sums : t_sum_array;  

begin

  --
  -- port size sanity check 
  -- be sure to enable synthesis assertions when using Vivado
  --
  assert count'LENGTH > STAGES
    report   "Output count vector size is too small to hold result"
    severity ERROR;

  --
  -- count bits using shift/mask/add technique
  --
  process(din,sums)
    begin

      --
      -- initialize index zero of the sum array to the data input
      --
      sums(0) <= unsigned(din);

      --
      -- stage loop
      --   note that the loop index starts at 1
      --
      stage_loop: for i in 1 to STAGES loop

        sums(i) <=   (   sums(i-1)                AND bit_mask(i) ) 
                   + ( ( sums(i-1) srl 2**(i-1) ) AND bit_mask(i) );

      end loop;

    end process;

  count <= std_logic_vector( sums(STAGES)( count'LENGTH-1 downto 0 ) );

end combinatorial_looped_mask;
