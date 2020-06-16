CREATE OR REPLACE PROCEDURE MAIORES(
    p_numero1 INT,
    p_numero2 INT,
    p_numero3 INT
) IS
 
v_aux INT;
     
BEGIN
    
    v_aux := 0;
    
    IF p_numero1 >= v_aux THEN
        v_aux := p_numero1;
   
    IF p_numero2 >= v_aux THEN
        v_aux := p_numero2;
        
    IF p_numero3 >= v_aux THEN
        v_aux := p_numero3;
     
    INSERT INTO TB_MAIORES 
        (NUMERO1, NUMERO2, NUMERO3, MAIOR)  
    VALUES
        (p_numero1, p_numero2, p_numero3, v_aux);
COMMIT;               
END IF;
END IF;
END IF;
END;
/
