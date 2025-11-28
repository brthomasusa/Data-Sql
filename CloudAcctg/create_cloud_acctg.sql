--S1A-- COMPANY TABLE
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

--S1B-- COMPANY TABLE SEQUENCE
create sequence gl_company_seq;

--S2-- COMPANY FISCAL YEAR TABLE
create table gl_fiscal_year (
   cocode       number
      constraint fk_fiscal_year
         references gl_company ( cocode ),
   coyear       number(4),
   comonthid    number(2),
   comonthname  varchar2(9),
   pfrom        date,
   pto          date,
   initial_year number(1),
   year_closed  number(1),
   month_closed number(1),
   tye_executed date,
   constraint gl_fiscal_year_pk primary key ( cocode,
                                              coyear,
                                              comonthid ) enable
);

--S3A-- VOUCHER TYPES TABLE
create table gl_voucher (
   vchcode   number,
   vchtype   varchar2(6),
   vchtitle  varchar2(30),
   vchnature number(1),
   constraint gl_voucher_pk primary key ( vchcode ) enable
);

--S3B-- VOUCHER TABLE SEQUENCE
create sequence gl_voucher_seq;

--S4-- COST CENTERS TABLE
create table gl_cost_center (
   cocode  number
      constraint fk_cost_center
         references gl_company ( cocode ),
   cccode  varchar2(5),
   cctitle varchar2(25),
   cclevel number(1),
   constraint gl_cost_center_pk primary key ( cocode,
                                              cccode ) enable
);

--S5-- CHART OF ACCOUNT TABLE
create table gl_coa (
   cocode    number
      constraint fk_coa
         references gl_company ( cocode ),
   coacode   varchar2(11),
   coatitle  varchar2(50),
   coalevel  number(1),
   coanature varchar2(11),
   coatype   varchar2(11),
   cccode    varchar2(5),
   constraint gl_coa_pk primary key ( cocode,
                                      coacode ) enable
);

--S6A-- TRANSACTION MASTER TABLE
create table gl_tran_master (
   tran_no        number,
   cocode         number
      constraint fk_tran_master1
         references gl_company ( cocode )
   not null,
   coyear         number(4) not null,
   comonthid      number(2) not null,
   vchcode        number
      constraint fk_tran_master2
         references gl_voucher ( vchcode )
   not null,
   vchno          number(10) not null,
   vchdate        date not null,
   vchdescription varchar2(150) not null,
   createdby      varchar2(10) not null,
   createdon      date not null,
   vchverified    varchar2(1) not null,
   vchposted      varchar2(1) not null,
   closing        number(1) not null,
   constraint pk_tran_master primary key ( tran_no ),
   constraint fk_tran_master3
      foreign key ( cocode,
                    coyear,
                    comonthid )
         references gl_fiscal_year
);

--S6B-- TRANSACTION DETAIL TABLE
create table gl_tran_detail (
   line_no        number,
   tran_no        number not null,
   cocode         number
      constraint fk_tran_detail1
         references gl_company ( cocode )
   not null,
   coacode        varchar2(11) not null,
   cccode         varchar2(5),
   vchdescription varchar2(150) not null,
   vchdr          number(15,2) not null,
   vchcr          number(15,2) not null,
   vchreference   varchar2(25),
   reconciled     number(1) not null,
   constraint pk_tran_detail primary key ( line_no ),
   constraint fk_tran_detail3 foreign key ( cocode,
                                            cccode )
      references gl_cost_center,
   constraint fk_tran_detail4 foreign key ( cocode,
                                            coacode )
      references gl_coa
);

--S6C-- ADD FOREIGN KEY
alter table gl_tran_detail
   add constraint fk_tran_detail2
      foreign key ( tran_no )
         references gl_tran_master ( tran_no )
            on delete cascade
      enable;

--S6D-- TRANSACTION TABLE SEQUENCE
create sequence gl_tran_master_seq minvalue 1 start with 1 increment by 1 cache 20;
create sequence gl_tran_detail_seq minvalue 1 start with 1 increment by 1 cache 20;

--S6E-- TRIGGER TO POPULATE DEFAULT COST CENTER CODE FROM CHART OF ACCOUNT (IF LEFT NULL IN VOUCHER)

create or replace trigger "TRAN_DETAIL_GET_COST_CENTER" before
   insert or update on gl_tran_detail
   for each row
declare
   vcccode varchar2(5);
begin
   if :new.cccode is null then
      select cccode
        into vcccode
        from gl_coa
       where cocode = :new.cocode
         and coacode = :new.coacode;
      :new.cccode := vcccode;
   end if;
end;
/
alter trigger "TRAN_DETAIL_GET_COST_CENTER" enable
/


--S7-- TRIAL BALANCE REPORT TABLE
create table gl_trial_balance (
   coacode     varchar2(11),
   coatitle    varchar2(50),
   coalevel    number(1),
   opendr      number(15,2),
   opencr      number(15,2),
   activitydr  number(15,2),
   activitycr  number(15,2),
   closingdr   number(15,2),
   closingcr   number(15,2),
   coname      varchar2(50),
   tbdate      date,
   fromaccount varchar2(11),
   toaccount   varchar2(11),
   cccode      varchar2(5),
   cctitle     varchar2(25),
   reportlevel number(1),
   userid      varchar2(50),
   grand_total number(1)
);

--S8-- BANK OPENING OUTSTANDINGS
create table gl_banks_os (
   sr_no      number,
   cocode     number
      constraint fk_banks_os1
         references gl_company ( cocode )
   not null,
   coacode    varchar2(11) not null,
   remarks    varchar2(50) not null,
   vchdr      number(15,2) not null,
   vchcr      number(15,2) not null,
   reconciled number(1) not null,
   constraint pk_banks_os primary key ( sr_no ),
   constraint fk_banks_os2 foreign key ( cocode,
                                         coacode )
      references gl_coa
);

create sequence gl_banks_os_seq minvalue 1 start with 1 increment by 1 cache 20;

--S9-- BANK RECONCILIATION REPORT
create table gl_reconcile_report (
   srno           number,
   userid         varchar2(50),
   coname         varchar2(50),
   reportdate     date,
   coacode        varchar2(11),
   coatitle       varchar2(50),
   monthyear      varchar2(14),
   vchdate        date,
   vchtype        varchar2(6),
   vchno          number(10),
   vchdescription varchar2(150),
   vchreference   varchar2(25),
   amount         number(15,2)
);   

--S10-- BUDGET ALLOCATION

create table gl_budget (
   cocode          number
      constraint fk_budget1
         references gl_company ( cocode )
   not null,
   coyear          number(4),
   coacode         varchar2(11) not null,
   coanature       varchar2(11) not null,
   cccode          varchar2(5),
   budget_amount1  number(15,2),
   budget_amount2  number(15,2),
   budget_amount3  number(15,2),
   budget_amount4  number(15,2),
   budget_amount5  number(15,2),
   budget_amount6  number(15,2),
   budget_amount7  number(15,2),
   budget_amount8  number(15,2),
   budget_amount9  number(15,2),
   budget_amount10 number(15,2),
   budget_amount11 number(15,2),
   budget_amount12 number(15,2),
   criterion       number(1),
   constraint fk_budget2 foreign key ( cocode,
                                       coacode )
      references gl_coa
);

--S11-- BUDGET REPORT TABLE
create table gl_budget_report (
   coacode     varchar2(11),
   coatitle    varchar2(50),
   budget      number(15,2),
   actual      number(15,2),
   variance    number(15,2),
   percent     number(7,2),
   status      varchar2(1),
   userid      varchar2(50),
   grand_total number(1),
   coname      varchar2(50),
   accountfrom varchar2(11),
   accountto   varchar2(11),
   monthfrom   varchar2(9),
   monthto     varchar2(9),
   printedon   timestamp
);

--S12-- FINANCIAL STATEMENTS SETUP TABLE
create table gl_fs_setup (
   cocode      number,
   reportcode  varchar2(4),
   reporttitle varchar2(50),
   fsaccount   varchar2(50),
   accountfrom varchar2(11),
   accountto   varchar2(11),
   constraint gl_fs_setup_pk primary key ( cocode,
                                           reportcode,
                                           fsaccount ) enable
);

--S13-- FINANCIAL STATEMENTS REPORT TABLE
create table gl_fs_report (
   reportcode      varchar2(4),
   reporttitle     varchar2(50),
   srno            number,
   fsaccount       varchar2(50),
   currentbalance  number(15,2),
   previousbalance number(15,2),
   percent         number(7,2),
   userid          varchar2(50),
   coname          varchar2(50),
   coyear          number(4),
   comonthname     varchar2(9),
   calculation     number(1),
   netvalue        number(1),
   notes           number(1),
   notescode       varchar2(11),
   notestitle      varchar2(50),
   heading         number(1)
);

--S14A-- SEGMENTS FOR APPLICATION ACCESS
create table gl_segments (
   segmentid     number,
   segmenttitle  varchar2(50),
   segmentparent number,
   segmenttype   varchar2(4),
   pageid        number(4),
   itemrole      varchar2(10),
   constraint gl_segments_pk primary key ( segmentid ) enable
);

--S14B--
create sequence gl_segments_seq minvalue 1 start with 1 increment by 1 cache 20;


--S15A-- USER GROUPS MASTER TABLE
create table gl_groups_master (
   groupid    number(4),
   grouptitle varchar2(25),
   constraint gl_groups_pk primary key ( groupid ) enable
); 

--S15B-- USER GROUPS DETAIL TABLE
create table gl_groups_detail (
   groupid       number(4)
      constraint fk_group_detail
         references gl_groups_master ( groupid ),
   segmentid     number
      constraint fk_user_groups
         references gl_segments ( segmentid ),
   segmentparent number,
   segmenttype   varchar2(4),
   pageid        number(4),
   itemrole      varchar2(10),
   allow_access  varchar2(1)
);

--S16-- APPLICATION USERS TABLE
create table gl_users (
   userid    varchar2(50),
   cocode    number
      constraint fk_users
         references gl_company ( cocode ),
   coyear    number(4),
   comonthid number(2),
   groupid   number(4)
      constraint fk_users2
         references gl_groups_master ( groupid ),
   password  varchar2(4000),
   admin     varchar2(1),
   constraint gl_users_pk primary key ( userid ) enable
);


--S17-- APPLICATION DASHBOARD
create table gl_dashboard (
   srno          number,
   accounttitle  varchar2(50),
   currentyear   number(15,2),
   previousyear  number(15,2),
   userid        varchar2(50),
   ratiotitle    varchar2(50),
   current_year  number(15,2),
   previous_year number(15,2)
);

--S18-- APPLICATION FEEDBACK
create table gl_feedback (
   feedbackid   number,
   ts           timestamp default sysdate,
   custname     varchar2(50),
   custemail    varchar2(100),
   custfeedback varchar2(4000),
   constraint gl_feedback_pk primary key ( feedbackid ) enable
);

create sequence gl_feedback_seq;