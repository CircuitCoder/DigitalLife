LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity lock is
  port(input:in std_logic_vector(3 downto 0);
       mode: in std_logic_vector(1 downto 0);
       clk: in std_logic;
       rst: in std_logic;
       succ: out std_logic;
       fail: out std_logic
     );
end lock;

architecture bhv of lock is
  type state_type is (IDLE, START, VERIFY_0, VERIFY_1, VERIFY_2, VERIFY_3, SET, SUCCESS);
  signal state: state_type := IDLE;
  signal pass: std_logic_vector(3 downto 0) := "0000";
begin
  process(state)
  begin
    case state is
      when IDLE =>
        fail <= '1';
        succ <= '0';

      when SUCCESS =>
        fail <= '0';
        succ <= '1';

      when others =>
        fail <= '0';
        succ <= '0';
    end case;
  end process;

  process(rst, clk)
  begin
    if(rst = '1') then
      state <= START;
    elsif rising_edge(clk) then
      case state is
        when START =>
          if mode = "01" then
            state <= VERIFY_1;
          else
            state <= SET;
          end if;

        when VERIFY_0 =>
          if pass(0) /= input(0) then
            state <= IDLE;
          else
            state <= VERIFY_1;
          end if;

        when VERIFY_1 =>
          if pass(1) /= input(1) then
            state <= IDLE;
          else
            state <= VERIFY_2;
          end if;

        when VERIFY_2 =>
          if pass(2) /= input(2) then
            state <= IDLE;
          else
            state <= VERIFY_3;
          end if;

        when VERIFY_3 =>
          if pass(3) /= input(3) then
            state <= IDLE;
          else
            state <= SUCCESS;
          end if;

        when SET =>
          pass <= input;
          state <= SUCCESS;

        when others =>
          state <= state;
      end case;
    end if;
  end process;
end bhv;
