entity unidadeControle is
    port(
        opcode        : in  bit_vector(10 downto 0);   -- sinal de condição / código da instrução
        extendMSB     : out bit_vector(4 downto 0);    -- sinal de controle sign-extend (MSB)
        extendLSB     : out bit_vector(4 downto 0);    -- sinal de controle sign-extend (LSB)
        reg2Loc       : out bit;                       -- controle MUX Read Register 2
        regWrite      : out bit;                       -- controle Write Register
        aluSrc        : out bit;                       -- controle MUX entrada B da ULA
        alu_control   : out bit_vector(3 downto 0);    -- controle da ULA
        branch        : out bit;                       -- controle de desvio condicional
        uncondBranch  : out bit;                       -- controle de desvio incondicional
        memRead       : out bit;                       -- controle leitura RAM
        memWrite      : out bit;                       -- controle escrita RAM
        memToReg      : out bit                        -- controle MUX Write Data
    );
end entity unidadeControle;


architecture a_uc of unidadeControle is
begin
    process(opcode)
    begin
        case opcode is 
            when "10001011000" => --ADD
                reg2Loc <= '0';
                aluSrc <= '0';
                memToReg <= '0';
                regWrite <= '1';
                memRead <= '0';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0010";
                extendMSB <= "00000"; --não importa
                extendlsb <= "00000"; --não importa
            when "11001011000" => --SUB
                reg2Loc <= '0';
                aluSrc <= '0';
                memToReg <= '0';
                regWrite <= '1';
                memRead <= '0';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0110";
                extendMSB <= "00000"; --não importa
                extendlsb <= "00000"; --não importa
            when "10001010000" => --AND
               reg2Loc <= '0';
                aluSrc <= '0';
                memToReg <= '0';
                regWrite <= '1';
                memRead <= '0';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0000";
                extendMSB <= "00000"; --não importa
                extendlsb <= "00000"; --não importa
            when "10101010000" => --ORR
               reg2Loc <= '0';
                aluSrc <= '0';
                memToReg <= '0';
                regWrite <= '1';
                memRead <= '0';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0001";
                extendMSB <= "00000"; --não importa
                extendlsb <= "00000"; --não importa
            when "11111000010" => --LDUR
               reg2Loc <= '1'; --não importa
                aluSrc <= '1';
                memToReg <= '1'; 
                regWrite <= '1';
                memRead <= '1';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0010";
                extendMSB <= "10100"; 
                extendlsb <= "01100"; 
            when "11111000000" => --STUR
               reg2Loc <= '1';
                aluSrc <= '1';
                memToReg <= '0'; --não importa
                regWrite <= '0';
                memRead <= '0';
                memWrite <= '1';
                branch <= '0';
                uncondBranch <= '0';
                alu_control <= "0010";
                extendMSB <= "10100"; 
                extendlsb <= "01100"; 
            when "10110100000" | "10110100001"|"10110100010"|"10110100011"
            |"10110100100"|"10110100101"|"10110100110"|"10110100111" => --CBZ
                reg2Loc <= '1';
                aluSrc <= '0';
                memToReg <= '0'; --não importa
                regWrite <= '0';
                memRead <= '0';
                memWrite <= '0';
                branch <= '1';
                uncondBranch <= '0';
                alu_control <= "0011";--apenas ultimos dois bits importam
                extendMSB <= "10111"; 
                extendlsb <= "00101"; 
            when "00010100000" |"00010100001" |"00010100010" |"00010100011" |"00010100100" |
            "00010100101" | "00010100110" |"00010100111" |"00010101000" |"00010101001" |
            "00010101010" |"00010101011" |"00010101100" |"00010101101" |"00010101110" |
            "00010101111" |"00010110000" |"00010110001" |"00010110010" |"00010110011" |
            "00010110100" |"00010110101" |"00010110110" |"00010110111" |"00010111000" |
            "00010111001" |"00010111010" |"00010111011" |"00010111100" |"00010111101" |
            "00010111110" |"00010111111" => --B
                reg2Loc <= '1'; -- não importa
                aluSrc <= '0'; --não importa
                memToReg <= '0'; --não importa
                regWrite <= '0'; 
                memRead <= '0';
                memWrite <= '0';
                branch <= '0';
                uncondBranch <= '1';
                alu_control <= "0000";--não importa
                extendMSB <= "11001"; 
                extendlsb <= "00000"; 
            when others => 
            -- estado de segurança
                reg2Loc      <= '0';
                aluSrc       <= '0';
                memToReg     <= '0';
                regWrite     <= '0';
                memRead      <= '0';
                memWrite     <= '0';
                branch       <= '0';
                uncondBranch <= '0';
                alu_control  <= "0000"; 
                extendMSB    <= "00000"; 
                extendLSB    <= "00000";
        end case;
    end process;
end architecture a_uc;


            


            







