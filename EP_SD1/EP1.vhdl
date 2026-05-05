library IEEE;
entity elevador is
    port (
        botoes_internos, botoes_externos : in  bit_vector(7 downto 0);
        andar_atual                      : in  bit_vector(2 downto 0);
        acao_anterior                    : in  bit_vector(1 downto 0);
        proxima_acao                     : out bit_vector(1 downto 0);
        aviso_admin                      : out bit
    );
end elevador;

architecture logic of elevador is
    signal andar : bit_vector(7 downto 0);
begin

    with andar_atual select
        andar <= "00000001" when "000",
                 "00000010" when "001",
                 "00000100" when "010",
                 "00001000" when "011",
                 "00010000" when "100",
                 "00100000" when "101",
                 "01000000" when "110",
                 "10000000" when "111",
                 "00000000" when others;


    aviso_admin <=  '1' when (botoes_internos = "11111111") else
                    '1' when (botoes_internos = "11111110") else
                    '1' when (botoes_internos = "01111111") else
                    '1' when (botoes_internos = "10111111") else
                    '1' when (botoes_internos = "11111101") else
                    '1' when (botoes_internos = "11111011") else
                    '1' when (botoes_internos = "11110111") else
                    '1' when (botoes_internos = "11101111") else
                    '1' when (botoes_internos = "11011111") else
                    '0';


    proxima_acao <= 

        "11" when (acao_anterior = "11" or (andar_atual = "000" and acao_anterior = "01") or (andar_atual = "111" and acao_anterior = "10")) else

        "00" when (
            (((andar(0)  and (botoes_internos(0) or botoes_externos(0))) or
            (andar(1)  and (botoes_internos(1) or botoes_externos(1))) or
            (andar(2)  and (botoes_internos(2) or botoes_externos(2))) or
            (andar(3)  and (botoes_internos(3) or botoes_externos(3))) or
            (andar(4)  and (botoes_internos(4) or botoes_externos(4))) or
            (andar(5)  and (botoes_internos(5) or botoes_externos(5))) or
            (andar(6)  and (botoes_internos(6) or botoes_externos(6))) or
            (andar(7)  and (botoes_internos(7) or botoes_externos(7))))='1') or
            (botoes_internos = "00000000" and botoes_externos = "00000000")
        ) else
        "11" when (((((botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7) or botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='0') and andar_atual = "001") or
                             (((botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='0') and andar_atual = "010") or
                             (((botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='0') and andar_atual = "011") or
                             (((botoes_internos(5) or botoes_internos(6) or botoes_internos(7) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='0') and andar_atual = "100") or
                             (((botoes_internos(6) or botoes_internos(7) or botoes_externos(6) or botoes_externos(7))='0') and andar_atual = "101") or
                             ((botoes_internos(7) or botoes_externos(7))='0' and andar_atual = "110")) and acao_anterior="01") else
        "11" when (((((botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(0) or botoes_internos(1) or botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(0) or botoes_externos(1))='0') and andar_atual = "110") or
                             (((botoes_internos(3) or botoes_internos(4) or botoes_internos(2) or botoes_internos(1) or botoes_internos(0) or botoes_externos(0) or botoes_externos(1) or botoes_externos(2) or botoes_externos(3) or botoes_externos(4))='0') and andar_atual = "101") or
                             (((botoes_internos(3) or botoes_internos(2) or botoes_internos(1) or botoes_internos(0) or botoes_externos(0) or botoes_externos(1) or botoes_externos(2) or botoes_externos(3))='0') and andar_atual = "100") or
                             (((botoes_internos(2) or botoes_internos(1) or botoes_internos(0) or botoes_externos(1) or botoes_externos(2) or botoes_externos(0))='0') and andar_atual = "011") or
                             (((botoes_internos(1) or botoes_internos(0) or botoes_externos(0) or botoes_externos(1))='0') and andar_atual = "010") or
                             ((botoes_internos(0) or botoes_externos(0))='0' and andar_atual = "001")) and acao_anterior="10") else
        "01" when ((((((botoes_internos(1) or botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "000") or
                             (((botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "001") or
                             (((botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "010") or
                             (((botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "011") or
                             (((botoes_internos(5) or botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "100") or
                             (((botoes_internos(6) or botoes_internos(7))='1') and andar_atual = "101") or
                             (botoes_internos(7)='1' and andar_atual = "110")) and acao_anterior/="10") or acao_anterior="01") else
        "10" when ((((((botoes_internos(1) or botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(6) or botoes_internos(0))='1') and andar_atual = "111") or
                             (((botoes_internos(2) or botoes_internos(3) or botoes_internos(4) or botoes_internos(5) or botoes_internos(1) or botoes_internos(0))='1') and andar_atual = "110") or
                             (((botoes_internos(3) or botoes_internos(4) or botoes_internos(2) or botoes_internos(1) or botoes_internos(0))='1') and andar_atual = "101") or
                             (((botoes_internos(3) or botoes_internos(2) or botoes_internos(1) or botoes_internos(0))='1') and andar_atual = "100") or
                             (((botoes_internos(2) or botoes_internos(1) or botoes_internos(0))='1') and andar_atual = "011") or
                             (((botoes_internos(1) or botoes_internos(0))='1') and andar_atual = "010") or
                             (botoes_internos(0)='1' and andar_atual = "001")) and acao_anterior/="01") or acao_anterior="10" ) else
        "01" when (((((botoes_externos(1) or botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "000") or
                             (((botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "001") or
                             (((botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "010") or
                             (((botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "011") or
                             (((botoes_externos(5) or botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "100") or
                             (((botoes_externos(6) or botoes_externos(7))='1') and andar_atual = "101") or
                             ((botoes_externos(7)='1') and andar_atual = "110")) and acao_anterior/="10") else
        "10" when (((((botoes_externos(1) or botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(6) or botoes_externos(0))='1') and andar_atual = "111") or
                             (((botoes_externos(2) or botoes_externos(3) or botoes_externos(4) or botoes_externos(5) or botoes_externos(0) or botoes_externos(1))='1') and andar_atual = "110") or
                             (((botoes_externos(3) or botoes_externos(4) or botoes_externos(0) or botoes_externos(2) or botoes_externos(1))='1') and andar_atual = "101") or
                             (((botoes_externos(0) or botoes_externos(3) or botoes_externos(2) or botoes_externos(1))='1') and andar_atual = "100") or
                             (((botoes_externos(0) or botoes_externos(2) or botoes_externos(1))='1') and andar_atual = "011") or
                             (((botoes_externos(0) or botoes_externos(1))='1') and andar_atual = "010") or
                             ((botoes_externos(0)='1') and andar_atual = "001")) and acao_anterior/="01") else
        "11";
end logic;
