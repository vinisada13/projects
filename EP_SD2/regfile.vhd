package my_types_pkg is
    type ine is array (0 to 31) of bit_vector(63 downto 0);
end package my_types_pkg;
package body my_types_pkg is
end package body my_types_pkg;

library IEEE;
use IEEE.numeric_bit.all;
use work.my_types_pkg.all;
entity mux_32 is
    generic (
        dataSize : natural := 64
    );
    port (
        inn : in ine;  -- entrada de dados 1
        sel  : in  bit_vector(4 downto 0);           -- sinal de seleção
        dOut : out bit_vector(dataSize-1 downto 0)   -- saída de dados
    );
end entity mux_32;

architecture a_mux of mux_32 is
begin
    dOut<= inn(to_integer(unsigned(sel)));
end architecture a_mux;

library IEEE;
use IEEE.numeric_bit.all;
entity dec is
    port(
        code : in bit_vector(4 downto 0);
        outc : out bit_vector(31 downto 0);
    );
end entity;
architecture ardec of dec is
    signal n : integer;
    begin
        n <= to_integer(unsigned(code));
        with n select
        outc <=
        (0=>'1', others =>'0') when 0,
        (1=>'1', others =>'0') when 1,
        (2=>'1', others =>'0') when 2,
        (3=>'1', others =>'0') when 3,
        (4=>'1', others =>'0') when 4,
        (5=>'1', others =>'0') when 5,
        (6=>'1', others =>'0') when 6,
        (7=>'1', others =>'0') when 7,
        (8=>'1', others =>'0') when 8,
        (9=>'1', others =>'0') when 9,
        (10=>'1', others =>'0') when 10,
        (11=>'1', others =>'0') when 11,
        (12=>'1', others =>'0') when 12,
        (13=>'1', others =>'0') when 13,
        (14=>'1', others =>'0') when 14,
        (15=>'1', others =>'0') when 15,
        (16=>'1', others =>'0') when 16,
        (17=>'1', others =>'0') when 17,
        (18=>'1', others =>'0') when 18,
        (19=>'1', others =>'0') when 19,
        (20=>'1', others =>'0') when 20,
        (21=>'1', others =>'0') when 21,
        (22=>'1', others =>'0') when 22,
        (23=>'1', others =>'0') when 23,
        (24=>'1', others =>'0') when 24,
        (25=>'1', others =>'0') when 25,
        (26=>'1', others =>'0') when 26,
        (27=>'1', others =>'0') when 27,
        (28=>'1', others =>'0') when 28,
        (29=>'1', others =>'0') when 29,
        (30=>'1', others =>'0') when 30,
        (31=>'1', others =>'0') when others;
end architecture;


use work.my_types_pkg.all;
entity regfile2 is
    port (
        clock : in bit; -- 
        reset : in bit ; --
        regWrite : in bit ; -- ! entrada registrador WR
        rr1 : in bit_vector (4 downto 0); -- ! entrada define registrador 1
        rr2 : in bit_vector (4 downto 0); -- ! entrada define registrador 2
        wr : in bit_vector (4 downto 0); -- ! entrada define registrador de escrita
        d : in bit_vector (63 downto 0); -- ! entrada de dado para carga paralela
        q1 : out bit_vector (63 downto 0); -- ! saida do registrador rr1
        q2 : out bit_vector (63 downto 0) -- ! saida do registrador rr2
    );
end entity regfile2;

architecture a_regfile of regfile2 is
    component dec is
        port(
        code : in bit_vector(4 downto 0);
        outc : out bit_vector(31 downto 0)
    );
    end component;
    component reg is             -- instanciando registradores da outra entidade
    generic (
        dataSize : natural := 64
    );
    port (
        clock  : in bit;                        -- entrada de clock
        reset  : in bit;                        -- clear assíncrono
        enable : in bit;                        -- write enable (carga paralela)
        d      : in  bit_vector(dataSize-1 downto 0);  -- entrada
        q      : out bit_vector(dataSize-1 downto 0)   -- saída
    );
        end component;

    component mux_32 is
        generic (
        dataSize : natural := 64
        );   
        port (
        inn : in ine;  -- entrada de dados 1
        sel  : in  bit_vector(4 downto 0);           -- sinal de seleção
        dOut : out bit_vector(dataSize-1 downto 0)   -- saída de dados
        );
    end component;

    component mux_n is 
    	generic(
        dataSize : natural := 64);
        port (
        in0  : in  bit_vector(dataSize-1 downto 0);  -- entrada de dados 0
        in1  : in  bit_vector(dataSize-1 downto 0);  -- entrada de dados 1
        sel  : in  bit;                              -- sinal de seleção
        dOut : out bit_vector(dataSize-1 downto 0)   -- saída de dados
    );
        end component;
        signal regs : ine;
        signal dRegs : bit_vector (31 downto 0);

begin


    regsBanco: for i in 0 to 30 generate
    
        rx: reg
        generic map(dataSize => 64)
        port map(clock => clock, reset => reset, enable => (dRegs(i) and regWrite), d => d, q => regs(i)); -- cria 31 registradores

    end generate regsBanco;
	xzr : reg 
    generic map(dataSize => 64)
    port map(clock => clock, reset => reset, enable => (dRegs(31) and regWrite) , d =>x"0000000000000000", q => regs(31));
    rreg1 : mux_32 
    generic map(dataSize => 64)   
    port map(
        inn => regs,
        sel => rr1,
        dOut => q1
    );
    rreg2 : mux_32
    generic map(dataSize => 64)
    port map(
        inn => regs,
        sel => rr2,
        dOut => q2
    );

    decoder: dec 
    port map(code => wr,
        outc => dRegs
        ); -- cria decoder





end architecture a_regfile;