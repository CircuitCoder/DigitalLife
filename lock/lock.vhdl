LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity lock is
  port(input:in std_logic_vector(3 downto 0);
       mode: in std_logic_vector(1 downto 0);
       clk: in std_logic;
       rst: in std_logic;
       succ: out std_logic;
       fail: out std_logic;
       locked: out std_logic
     );
end lock;

architecture bhv of lock is
  type state_type is (IDLE, ADMIN_0, ADMIN_1, ADMIN_2, ADMIN_3, VERIFY_0, VERIFY_1, VERIFY_2, VERIFY_3, SET_0, SET_1, SET_2, SET_3, SUCCESS);
  type lock_type is (INITIAL, TRY_1, TRY_2, TRY_3);
  signal state: state_type := IDLE;
  signal lock: lock_type := INITIAL;
  signal pass0: std_logic_vector(3 downto 0) := "0001";
  signal pass1: std_logic_vector(3 downto 0) := "0010";
  signal pass2: std_logic_vector(3 downto 0) := "0100";
  signal pass3: std_logic_vector(3 downto 0) := "1000";

  signal admin0: std_logic_vector(3 downto 0) := "0001";
  signal admin1: std_logic_vector(3 downto 0) := "0010";
  signal admin2: std_logic_vector(3 downto 0) := "0100";
  signal admin3: std_logic_vector(3 downto 0) := "1000";
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

  process(lock, state)
  begin
    if(lock = TRY_3 and state /= VERIFY_0 and state /= VERIFY_1 and state /= VERIFY_2 and state /= VERIFY_3) then
      locked <= '1';
    else
      locked <= '0';
    end if;
  end process;

  process(rst, clk)
  begin
    if(rst = '1') then
      if mode = "01" then
        if lock /= TRY_3 then
          state <= VERIFY_0;

          case lock is
            when INITIAL =>
              lock <= TRY_1;
            when TRY_1 =>
              lock <= TRY_2;
            when others =>
              lock <= TRY_3;
          end case;
        end if;
      elsif mode = "00" then
        if state = SUCCESS then
          state <= SET_0;
        end if;
      elsif mode = "10" then
        state <= ADMIN_0;
      end if;
    elsif rising_edge(clk) then
      case state is
        when ADMIN_0 =>
          if admin0 /= input then
            state <= IDLE;
          else
            state <= ADMIN_1;
          end if;

        when ADMIN_1 =>
          if admin1 /= input then
            state <= IDLE;
          else
            state <= ADMIN_2;
          end if;

        when ADMIN_2 =>
          if admin2 /= input then
            state <= IDLE;
          else
            state <= ADMIN_3;
          end if;

        when ADMIN_3 =>
          if admin3 /= input then
            state <= IDLE;
          else
            state <= SUCCESS;
            lock <= INITIAL;
          end if;

        when VERIFY_0 =>
          if pass0 /= input then
            state <= IDLE;
          else
            state <= VERIFY_1;
          end if;

        when VERIFY_1 =>
          if pass1 /= input then
            state <= IDLE;
          else
            state <= VERIFY_2;
          end if;

        when VERIFY_2 =>
          if pass2 /= input then
            state <= IDLE;
          else
            state <= VERIFY_3;
          end if;

        when VERIFY_3 =>
          if pass3 /= input then
            state <= IDLE;
          else
            state <= SUCCESS;
            lock <= INITIAL;
          end if;

        when SET_0 =>
          pass0 <= input;
          state <= SET_1;

        when SET_1 =>
          pass1 <= input;
          state <= SET_2;

        when SET_2 =>
          pass2 <= input;
          state <= SET_3;

        when SET_3 =>
          pass3 <= input;
          state <= SUCCESS;

        when others =>
          state <= state;
      end case;
    end if;
  end process;
end bhv;
