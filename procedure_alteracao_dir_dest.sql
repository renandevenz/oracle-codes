create or replace procedure proc_alter_dir_dest (
        p_cod_matriz in tb_ediext_perfil.cod_matriz%TYPE, 
        p_dir_dest in tb_ediext_perfil_sftp.dir_dest%TYPE, 
        p_id_concil in tb_ediext_perfil_sftp.id_sftp%TYPE,
        p_protocolo varchar2
) is
    prot_err exception;
begin

if p_protocolo = 'SFTP' then
    update tb_ediext_perfil_sftp ps set
        ps.dir_dest = p_dir_dest
        where ps.id_perfil = (select p.id from tb_ediext_perfil p 
                                where p.cod_matriz = p_cod_matriz);
    elsif p_protocolo = 'CD' then
        update tb_ediext_perfil_cd pc set
            pc.dir_dest = p_dir_dest
            where pc.id_perfil = (select p.id from tb_ediext_perfil p
                                    where p.cod_matriz = p_cod_matriz);
    else 
        raise prot_err;
    
 end if;
 
    exception
        when prot_err then
            dbms_output.put_line('ERRO! PROTOCOLO INVÁLIDO!');
 
end;
/
