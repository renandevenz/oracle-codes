declare
    v_left varchar2(100);
    v_center varchar2(100);
    v_right varchar2(100);
begin
    for r in (
      select level as lev, regexp_substr(tb_ediext_perfil.concil, '(.*?)(,|$)', 1, level, null, 1) as val
      from tb_ediext_perfil
      connect by level <= 3)
    loop
        if r.lev = 1 then
            v_left = r.val;
        elsif r.lev = 2 then
            v_center = r.val;
        elsif r.lev = 3 then
            v_right = r.val;
        end if;
    end loop;
    
    dbms_output.print_line(v_left);
    dbms_output.print_line(v_center);
    dbms_output.print_line(v_right);
    
end;
/
