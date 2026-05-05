entity ula is
port (
A : in bit_vector(63 downto 0); -- entrada A
B : in bit_vector(63 downto 0); -- entrada B
S : in bit_vector(3 downto 0);
-- seleciona operacao
F : out bit_vector(63 downto 0); -- saida
Z : out bit ;
-- flag zero
Ov : out bit ;
Co : out bit
) ;
end entity ula ;
architecture ulaarch of ula is
    signal cinout : bit_vector(63 downto 0);
    signal overflowvec : bit_vector(63 downto 0);
    signal soperation : bit_vector (1 downto 0);
    signal sub : bit:='0';
    signal norr : bit:='0';
    component ula1bit is
        port(
            a: in bit;
            b: in bit;
            cin: in bit;
            ainvert: in bit;
            binvert: in bit;
            operation: in bit_vector(1 downto 0);
            result: out bit;
            cout: out bit;
            overflow: out bit
        );
    end component;
    begin
        with S select
            soperation <= 
                "00" when "0000",
                "00" when "1100",
                "01" when "0001",
                "10" when "0010",
                "10" when "0110",
                "11" when "0111",
                "11" when others;
        with s select
            sub <= '1'when ("0110"),
             '0' when others;
        with s select
            norr <= '1' when ("1100"),
            '0' when others;
        u0 : ula1bit
            port map(
                a => A(0), b => B(0), cin => sub, ainvert => norr, binvert => (sub or norr), operation => soperation, result =>F(0), cout => cinout(0), overflow => overflowvec(0));
        gen: for i in 1 to 63 generate
            ux: ula1bit port map (a => A(i), b => B(i), cin => cinout(i-1), ainvert => norr, binvert => (sub or norr), operation => soperation, result =>F(i), cout => cinout(i), overflow => overflowvec(i));
        end generate;
        with F select
        Z<='1' when (x"0000000000000000"),
            '0' when others;
        Ov <= overflowvec(63);
        Co <= cinout(63);
end architecture ulaarch;