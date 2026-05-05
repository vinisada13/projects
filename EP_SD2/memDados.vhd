library ieee;
use ieee.numeric_bit.all;
library std;
use std.textio.all;

entity memoriaDados is
    generic (
        addressSize : natural := 8;
        dataSize    : natural := 8;
        datFileName : string  := "memDados_conteudo_inicial.dat"
    );
    port (
        clock  : in  bit;
        wr     : in  bit;
        addr   : in  bit_vector(addressSize-1 downto 0);
        data_i : in  bit_vector(dataSize-1 downto 0);
        data_o : out bit_vector(dataSize-1 downto 0)
    );
end entity memoriaDados;

architecture a_ram of memoriaDados is

    type mem_tipo is array (0 to 2**addressSize - 1) of bit_vector(dataSize-1 downto 0);

    function init_mem(arquivo : in string) return mem_tipo is
        file f         : text open read_mode is arquivo;
        variable linha : line;
        variable bv    : bit_vector(dataSize-1 downto 0);
        variable mem_v : mem_tipo := (others => (others => '0'));
        variable i     : integer := 0;
    begin
        while not endfile(f) loop
            readline(f, linha);
            read(linha, bv);

            if i <= mem_v'high then
                mem_v(i) := bv;
            end if;

            i := i + 1;
        end loop;

        return mem_v;
    end function;

    signal mem : mem_tipo := init_mem(datFileName);

begin

    process(clock)
    begin
        if clock = '1' and clock'event then
            if wr = '1' then
                mem(to_integer(unsigned(addr))) <= data_i;
            end if;
        end if;
    end process;

    data_o <= mem(to_integer(unsigned(addr)));

end architecture a_ram;
