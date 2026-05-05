entity polilegv8 is
port (
clock : in bit;
reset : in bit
);
end entity polilegv8;
architecture arcpolilegv8 of polilegv8 is
    signal     extendMSB  :  bit_vector (4 downto 0);
    signal     extendLSB  :   bit_vector (4 downto 0);
    signal     reg2Loc :  bit;
    signal     regWrite  :  bit;
    signal     aluSrc  :  bit;
    signal     alu_control : bit_vector (3 downto 0);
    signal     branch  :    bit;
    signal     uncondBranch : bit;
    signal     memRead :   bit;
    signal     memWrite :  bit;
    signal     memToReg  :  bit;
    signal     opcode   :   bit_vector (10 downto 0);
    component fluxoDados is
    port(
        clock         : in bit;
        reset         : in bit;
        extendMSB     : in bit_vector (4 downto 0);
        extendLSB     : in bit_vector (4 downto 0);
        reg2Loc       : in bit;
        regWrite      : in bit;
        aluSrc        : in bit;
        alu_control   : in bit_vector (3 downto 0);
        branch        : in bit;
        uncondBranch  : in bit;
        memRead       : in bit;
        memWrite      : in bit;
        memToReg      : in bit;
        opcode        : out bit_vector (10 downto 0)
    );
    end component;
    component unidadeControle is 
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
    end component;
    begin
        flux0 : fluxoDados
        port map(
            clock   => clock,      
            reset   => reset,     
            extendMSB => extendMSB,   
            extendLSB   => extendLSB,  
            reg2Loc     => reg2Loc,  
            regWrite =>   regWrite,  
            aluSrc => aluSrc,       
            alu_control => alu_control,  
            branch   =>  branch,   
            uncondBranch  => uncondBranch,
            memRead => memRead,     
            memWrite  => memWrite,  
            memToReg => memToReg,      
            opcode => opcode       
        );
        control0 : unidadeControle
        port map(
            opcode => opcode,   
            extendMSB => extendMSB,   
            extendLSB   => extendLSB,  
            reg2Loc     => reg2Loc,  
            regWrite =>   regWrite,  
            aluSrc => aluSrc,       
            alu_control => alu_control,  
            branch   =>  branch,   
            uncondBranch  => uncondBranch,
            memRead => memRead,     
            memWrite  => memWrite,  
            memToReg => memToReg      
            );
end architecture arcpolilegv8;