CREATE OR REPLACE FUNCTION F_LIMITE_CREDITO
    ( P_ID IN TB_CLIENTES.CLIENTE_ID%TYPE ) 
RETURN NUMBER IS
     P_LIMITE NUMBER;
BEGIN

    IF P_ID IS NULL
    THEN
        RETURN -1;
    END IF;

    SELECT LIMITE INTO P_LIMITE
    FROM TB_CLIENTES
    WHERE CLIENTE_ID = P_ID;

    RETURN P_LIMITE;

    EXCEPTION WHEN NO_DATA_FOUND
    THEN
          RETURN -1;

END F_LIMITE_CREDITO;
/
-- Chamando a função

SELECT NOME,
       CASE WHEN F_LIMITE_CREDITO(CLIENTE_ID) = -1 THEN 'ERRO'
            WHEN F_LIMITE_CREDITO(CLIENTE_ID) < 10 THEN 'LIMITE INDISPONIVEL' 
            ELSE 'APROVADO'
       END AS SITUACAO_LIMITE
FROM TB_CLIENTES;
