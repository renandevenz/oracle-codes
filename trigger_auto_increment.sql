create or replace trg_auto_increment
	before insert on tb_ediext_perfil
	for each row
	begin
		if :new.id is null then
			select seq_perfil.nextval into :new.id from dual;
		end if;
	end;
