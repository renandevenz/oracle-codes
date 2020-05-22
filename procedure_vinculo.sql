create or replace procedure proc_vinculo (
   p_cod_matriz in tb_ediext_perfil.cod_matriz%type,
   p_concil in tb_ediext_perfil.concil%type,
   p_id_mbx in tb_ediext_perfil.id_mbx%type,
   p_id_concil int,
   p_dir_dest varchar2,
   p_protocolo varchar2 
   
) is

	v_ec tb_ediext_perfil.concil%type;
	conc_r tb_ediext_perfil.concil%type;
	contem_ec exception;
	concil_exists exception;
	
    
    cursor verifica_ec is 
	select p_concil
		from tb_ediext_perfil
    where concil = 'EC';
    
begin
 
    open verifica_ec;
        fetch verifica_ec into v_ec;
    close verifica_ec;

    if p_concil = 'EC' then
        raise contem_ec;
    end if; 

    for conc_r in (select concil
                 from tb_ediext_perfil
                )
    loop
    if instr(conc_r.concil, p_concil) > 0 then
        raise concil_exists;
      end if;
    end loop;
    
	
    insert into tb_ediext_perfil_mbx 
		values 
	(perfil_mbx.nextval
	 		, (select 
			   	id from tb_ediext_perfil where cod_matriz = p_cod_matriz
			  	)
	 		, (select 
			   	id from tb_ediext_mbx where MBX = 'MB'||p_concil)
				);
    
    if p_protocolo = 'sftp' then
        insert into tb_ediext_perfil_sftp
                values 
        (perfil_sftp.nextval
			, (select id 
				from tb_ediext_perfil where cod_matriz = p_cod_matriz
				)
			, p_id_concil
			, p_dir_dest);
        
        update tb_ediext_perfil 
		set sftp = 1 
		where cod_matriz = p_cod_matriz;
	
	else
	  insert into tb_ediext_perfil_cd
                values 
          (PERFIL_cd.nextval
			, (select id 
				from tb_ediext_perfil where cod_matriz = p_cod_matriz
				)
			, p_id_concil
			, p_dir_dest
			, null);
        
        update tb_ediext_perfil 
		set cd = 1 
		where cod_matriz = p_cod_matriz;
	end if;
    
	
    update tb_ediext_perfil a set
      a.concil = case when a.concil = 'EC' then p_concil
                  else a.concil ||','|| p_concil
             end
    where a.cod_matriz = p_cod_matriz;       


    exception
        when contem_ec
            then dbms_output.put_line('PARA ESTE PROCEDIMENTO, NÃO É PERMITIDO VINCULAR '||v_ec);
        when concil_exists
            then dbms_output.put_line('ERRO! A MATRIZ '||p_cod_matriz||' JÁ POSSUI VINCULO COM A CONCILIADORA: ' || p_concil);
        when others 
            then dbms_output.put_line('Erro na execução da stored procedure proc_vinculo');
                 dbms_output.put_line('Código Oracle: ' || sqlcode);
                 dbms_output.put_line('Mensagem Oracle: ' || sqlerrm);
end;
/
