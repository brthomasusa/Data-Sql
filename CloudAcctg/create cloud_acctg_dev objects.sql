-- COMPANY TABLE
create table gl_company (
   cocode     number,
   coname     varchar2(50),
   coaddress  varchar2(100),
   cophone    varchar2(15),
   cofax      varchar2(15),
   cocity     varchar2(15),
   cozip      varchar2(15),
   cocurrency varchar2(15),
   constraint gl_company_pk primary key ( cocode ) enable
);

create sequence gl_company_seq;

create or replace trigger bi_company before
   insert on gl_company
   for each row
begin
   if :new.cocode is null then
      select gl_company_seq.nextval
        into :new.cocode
        from dual;
   end if;
end;
/

-- Insert test data into gl_company
insert into gl_company (
   coname,
   coaddress,
   cocity,
   cozip,
   cophone,
   cofax,
   cocurrency
) values ( 'BTechnical Consulting',
           '123 Main St.',
           'Dallas',
           '75231',
           '972-555-5555',
           '972-555-5557',
           '$' );

insert into gl_company (
   coname,
   coaddress,
   cocity,
   cozip,
   cophone,
   cofax,
   cocurrency
) values ( 'Computer Depot',
           '1477 Retail Row.',
           'Dallas',
           '75214',
           '972-555-6666',
           '972-555-5558',
           '$' );

commit;