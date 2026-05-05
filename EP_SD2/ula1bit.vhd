
entity ula1bit is
    port (
    a : in bit;
    b : in bit;
    cin : in bit;
    ainvert : in bit;
    binvert : in bit;
    operation : in bit_vector(1 downto 0);
    result : out bit;
    cout : out bit;
    overflow: out bit);
end entity;
architecture ULA1  of ula1bit is
    signal a2: bit;
    signal b2: bit;
begin
    a2 <= (not a) when ainvert='1' else
    a;
    b2 <= (not b) when binvert='1' else
    b; 
    cout<= (a2 and b2) or ((a2 xor b2) and cin);
    overflow <= ((a2 and b2 and (not (a2 xor b2 xor cin))) or ((not a2) and (not b2) and (a2 xor b2 xor cin)));
    with operation select
        result <=
            (a2 and b2) when "00",
            (a2 or b2 ) when "01",
            (a2 xor b2 xor cin) when "10",
            b when "11";
end architecture ULA1;

