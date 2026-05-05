entity tb_polilegv8 is
end entity tb_polilegv8;
architecture tb of tb_polilegv8 is
    component polilegv8 is 
    port(
        clock : in bit;
        reset : in bit;
    );
    end component;
    constant CLK_PERIOD : time := 10000 ns;
    
    signal simulando : bit := '1';
    
    signal clock  : bit;
    signal reset  : bit;
    signal keep: bit:='1';
    begin
		clock<=not(clock) and keep after CLK_PERIOD/2;
    poli : polilegv8 port map(
        clock => clock,
        reset => reset
    );
end architecture tb;