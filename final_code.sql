CREATE OR REPLACE PROCEDURE baicuoikhoa.fact_summary_report_fin_monthly_prc(pMonth_key int default null)
	LANGUAGE plpgsql
AS $procedure$
declare 
	vmonth_key int;

	
	-- Creater Information 
    -- ---------------------
   	-- Procedure name: fact_summary_report_fin_monthly_prc 
    -- Author: Nguyen Hoang Sang
    -- Created : July 2025
	-- Mục đích: Tổng hợp báo cáo tài chính hàng tháng theo khu vực

	
	-- ---------------------
    -- SUMMARY Processing Stream
	-- step 1: Declare Variables
    -- step 2: Execute SQL Statements And Process Logic
    -- step 3: Calculate Values For tmp_head
    -- step 4: Calculate Values For tmp_area
    -- step 5: Target fact_profit_loss_area_by_monthly
	
	-- ----------------------

	
	
begin	
	if (pMonth_key = null or pMonth_key is null ) 
	then
		vmonth_key := to_char(current_date,'YYYYMM')::int;
	else 
		vmonth_key := pMonth_key;
	end if;
	
/*Lãi trong hạn */

-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_laitronghan_chua_phan_bo ;

insert into tmp_laitronghan_chua_phan_bo (month_key, area_code, amount)
-- lai trong han chua phan bo DVML
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code  in (702000030002, 702000030001, 702000030112) 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1) 
union all

---- lai trong han chua phan bo head
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code  in (702000030002, 702000030001, 702000030112) 
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1);


-- step 2 :tinh dnbq sau wo cua nhom 1 cac khu vuc va toan hang 

truncate table baicuoikhoa.tmp_dnck_after_wo;

INSERT INTO baicuoikhoa.tmp_dnck_after_wo
(month_key, area_code, avg_dbgroup_1, avg_dbgroup_2, avg_dbgroup_345, avg_after_wo,avg_toanhang,sale_manager)
-- dnck avg khu vuc : sau wo 
select  202302 as kpi_month ,area_code , avg(os_after_wo_1) as avg_after_wo_1 ,
avg(os_after_wo_2) as avg_after_wo_2 , avg(os_after_wo_345) as avg_after_wo_345, avg(dnck) as avg_after_wo, 0 as avg_toanhang,
case 
	when area_code = 'B' then 8
	when area_code = 'C' then 7
	when area_code = 'D' then 22
	when area_code = 'E' then 5
	when area_code = 'F' then 5
	when area_code = 'G' then 11
	when area_code = 'H' then 15
	when area_code = 'toanhang' then 73
	end as sale_manager
from 
(
	select y.area_code , x.kpi_month , sum(outstanding_principal) as dnck, 
	sum 
	(
		case
			when coalesce(max_bucket,1) = 1 then outstanding_principal
			else 0
		end 
	) as os_after_wo_1,
	sum 
	(
		case
			when coalesce(max_bucket,1) = 2 then outstanding_principal
			else 0
		end 
	) as os_after_wo_2,
	sum 
	(
		case
			when coalesce(max_bucket,1) in (3,4,5) then outstanding_principal
			else 0
		end 
	) as os_after_wo_345
	from fact_kpi_month_raw_data x 
	join dim_province y on x.pos_city = y.pos_city
	--and y.area_code = 'B'
	where kpi_month <= 202302
	and kpi_month >= 202301
	group by x.kpi_month , y.area_code 
) x
group by area_code 
union 
select  202302 as kpi_month ,area_code , avg(os_after_wo_1) as avg_after_wo_1 ,
avg(os_after_wo_2) as avg_after_wo_2 , avg(os_after_wo_345) as avg_after_wo_345 , avg(dnck) as avg_after_wo, 0 as avg_toanhang,
0 as sale_manager
from 
( 
	select 'HEAD' as area_code , x.kpi_month , sum(outstanding_principal) as dnck,
	sum 
	(
		case
			when coalesce(max_bucket,1) = 1 then outstanding_principal
			else 0
		end 
	) as os_after_wo_1,
	sum 
	(
		case
			when coalesce(max_bucket,1) = 2 then outstanding_principal
			else 0
		end 
	) as os_after_wo_2,
	sum 
	(
		case
			when coalesce(max_bucket,1) in (3,4,5) then outstanding_principal
			else 0
		end 
	) as os_after_wo_345
	from fact_kpi_month_raw_data x 
	join dim_province y on x.pos_city = y.pos_city
	where kpi_month <= 202302
	and kpi_month >= 202301
	group by x.kpi_month 
) x
group by area_code

union all
select 202302 as kpi_month ,'toanhang' as area_code ,avg(dn_month) as avg_after_wo_1 ,
avg(dn_month) as avg_after_wo_2 ,avg(dn_month) as avg_after_wo_345 ,avg(dn_month) as avg_after_wo, avg(dn_month) as avg_toanhang, 73 as sale_manager 
from 
(
	select x.kpi_month , sum(x.outstanding_principal) as dn_month
	from fact_kpi_month_raw_data x 
	join dim_province y on x.pos_city = y.pos_city
	where kpi_month <= 202302  
	and kpi_month >= 202301
	group by x.kpi_month 
);



-- step 3 : tinh lai trong han da phan bo :
truncate table tmp_laitronghan_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_laitronghan_da_phan_bo
-- create table tmp_laitronghan_da_phan_bo as
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_dbgroup_1 , y.avg_dbgroup_1_head ,
x.amount + (z.amount * y.avg_dbgroup_1 / y.avg_dbgroup_1_head) as amount_da_phan_bo
from tmp_laitronghan_chua_phan_bo x 
join tmp_laitronghan_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'HEAD'
  where a.area_code <> 'HEAD'
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code <> 'HEAD';



/* CHI TIEU LAI QUA HAN */
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_laiquahan_chua_phan_bo ;
--select * from  tmp_laiquahan_chua_phan_bo tlcpb 

insert into tmp_laiquahan_chua_phan_bo (month_key, area_code, amount)
---- lai qua han DVML  
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) lai_qua_han
from fact_txn_month_raw_data ftm 
where account_code  in (702000030012, 702000030112) 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) 
union all
---- lai qua han HEAD
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) lai_qua_han
from fact_txn_month_raw_data ftm 
where account_code  in (702000030012, 702000030112)  
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1);


--select * from tmp_laiquahan_chua_phan_bo
-- step 3 : tinh lai qua han da phan bo :
truncate table tmp_laiquahan_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_laiquahan_da_phan_bo
-- create table tmp_laitronghan_da_phan_bo as
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_dbgroup_2 , y.avg_dbgroup_2_head ,
x.amount + (z.amount * y.avg_dbgroup_2 / y.avg_dbgroup_2_head) as amount_da_phan_bo
from tmp_laiquahan_chua_phan_bo x 
join tmp_laiquahan_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_dbgroup_2  , b.avg_dbgroup_2 as avg_dbgroup_2_head 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'HEAD'
  where a.area_code <> 'HEAD'
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code <> 'HEAD';


/* CHI TIEU phi bao hiem */
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_phibaohiem_chua_phan_bo;

insert into tmp_phibaohiem_chua_phan_bo (month_key, area_code, amount)
---- lai qua han DVML  
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) phi_bao_hiem
from fact_txn_month_raw_data ftm 
where account_code = 716000000001
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) 
union all
---- lai qua han HEAD
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) phi_bao_hiem
from fact_txn_month_raw_data ftm 
where account_code  = 716000000001 
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1);

--
INSERT INTO baicuoikhoa.psdn_phibaohiem 
( area_code, month_key  , psdn)
-- PSDN khu vuc
select y.area_code , 202302 as month_key  , sum(psdn) as psdn_khuvuc
from fact_kpi_month_raw_data x 
join dim_province y on x.pos_city = y.pos_city
where kpi_month = 202302
--and x.psdn = 1 
group by kpi_month , y.area_code

union all
------ psdn toan hang 175850
select 'toan_hang' as area_code, 202302 as month_key,  sum(psdn) as psdn_toanhang
from fact_kpi_month_raw_data a ;

---- them data vao 
INSERT INTO baicuoikhoa.tmp_phibaohiem_da_phan_bo
(month_key, area_code, amount_chua_phan_bo, amount_head, amount_da_phan_bo)

-- create table tmp_laitronghan_da_phan_bo as
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head ,
x.amount + (z.amount * y.psdn / y.psdn_toanhang) as amount_da_phan_bo
from tmp_phibaohiem_chua_phan_bo  x 
join tmp_phibaohiem_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.psdn  , b.psdn as psdn_toanhang 
  from psdn_phibaohiem   a 
  join psdn_phibaohiem b on b.area_code = 'toan_hang'
  where a.area_code <> 'toan_hang'
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code not in ('toan_hang');

/* phi tang han muc */

-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_phitanghanmuc_chua_phan_bo;

insert into tmp_phitanghanmuc_chua_phan_bo (month_key, area_code, amount)
---- phi tang han muc DVML 70455003154 
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code = 719000030002 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) 
union all
---- phi tang han muc HEAD
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code = 719000030002
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1);

-- step 2 : tinh lai trong han da phan bo :
truncate table tmp_phitanghanmuc_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_phitanghanmuc_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_dbgroup_1 , y.avg_dbgroup_1_head ,
x.amount + (z.amount * y.avg_dbgroup_1 / y.avg_dbgroup_1_head) as amount_da_phan_bo
from tmp_phitanghanmuc_chua_phan_bo x 
join tmp_phitanghanmuc_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_dbgroup_1  , b.avg_dbgroup_1 as avg_dbgroup_1_head 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'HEAD'
  where a.area_code <> 'HEAD'
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code <> 'HEAD';

/* phi thanh toan cham, thu tu ngoai bang */

-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_phikhac_chua_phan_bo;

insert into tmp_phikhac_chua_phan_bo (month_key, area_code, amount)
---- phi tang han muc DVML 70455003154 
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code in (719000030003,719000030113,790000030003,790000030113,790000030004,790000030114) 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) 
union all
---- phi khacHEAD
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code in (719000030003,719000030113,790000030003,790000030113,790000030004,790000030114)
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1);


-- step 2 : tinh lai phi khac da phan bo :
truncate table tmp_phikhac_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_phikhac_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_dbgroup_345 , y.avg_dbgroup_345_head ,
x.amount + (z.amount * y.avg_dbgroup_345 / y.avg_dbgroup_345_head) as amount_da_phan_bo

from tmp_phikhac_chua_phan_bo x 
join tmp_phikhac_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_dbgroup_345  , b.avg_dbgroup_345 as avg_dbgroup_345_head 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'HEAD'
  where a.area_code <> 'HEAD'
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code <> 'HEAD';

--chi phi thuan KDV
-- DT nguon von 
-- CP TT2 
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_cptt2_chua_phan_bo;

insert into tmp_cptt2_chua_phan_bo (month_key, area_code, amount)

select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code   in (801000000001,802000000001) 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) 

union all
---- cptt2 HEAD
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) lai_trong_han
from fact_txn_month_raw_data ftm 
where account_code   in (801000000001,802000000001) 
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1);

------- tinh chi phi da phan bo 
truncate table tmp_cptt2_da_phan_bo ;
INSERT INTO baicuoikhoa.tmp_cptt2_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as

select a.month_key , a.area_code , a.avg_after_wo  ,c.amount as amount_head, b.avg_toanhang  as avg_after_wo_toanhang,
c.amount as amount_chua_phan_bo,
c.amount*(a.avg_after_wo/b.avg_toanhang) as amount_da_phan_bo 
from tmp_dnck_after_wo a 
join tmp_dnck_after_wo b on b.area_code = 'toanhang'
join tmp_cptt2_chua_phan_bo c on b.month_key = c.month_key 
where a.area_code not in ('toanhang');
  
 --CP von TT 1 
 --CP von CCTG 
truncate table tmp_cctg_chua_phan_bo;

insert into tmp_cctg_chua_phan_bo (month_key, area_code, amount) 
select 	202302 as month_key,
		dp.area_name ,
		sum(amount) as amount
from fact_txn_month ftm 
left join dim_province dp on ftm.area_code = dp.area_code 
where account_code  = 803000000001
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) between 1 and 2
group by dp.area_name;

-------xoa du lieu truoc khi  them vao
truncate table tmp_cctg_da_phan_bo;

INSERT INTO baicuoikhoa.tmp_cctg_da_phan_bo
-- create table tmp_laitronghan_da_phan_bo as
select a.month_key,  a.area_code,  a.avg_after_wo, c.amount as amount_head, b.avg_toanhang  as avg_after_wo_toanhang,
c.amount as amount_chua_phan_bo, 
c.amount*(a.avg_after_wo/b.avg_toanhang) as amount_da_phan_bo 
from tmp_dnck_after_wo a 
join tmp_dnck_after_wo b on b.area_code = 'toanhang'
join tmp_cctg_chua_phan_bo c on b.month_key = c.month_key 
where a.area_code not in ('toanhang');

--DT Kinh doanh  step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_dtkd_chua_phan_bo;

insert into tmp_dtkd_chua_phan_bo 

select 202302 as month_key ,'HEAD'  as area_code , sum(amount) as dt_kinhdoanh_khuvuc
from fact_txn_month_raw_data ftm 
where account_code  in ('702000010001','702000010002','704000000001','705000000001','709000000001','714000000002','714000000003',
'714037000001','714000000004','714014000001','715000000001','715037000001','719000000001','709000000101','719000000101')
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1) 

union all
 --DT Kinh doanh  DVML 5243787
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) as dt_kinhdoanh_khuvuc
from fact_txn_month_raw_data ftm 
where account_code  in ('702000010001','702000010002','704000000001','705000000001','709000000001','714000000002','714000000003',
'714037000001','714000000004','714014000001','715000000001','715037000001','719000000001','709000000101','719000000101')
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;
----
truncate table tmp_dtkd_da_phan_bo;


INSERT INTO baicuoikhoa.tmp_dtkd_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as

select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
x.amount + (z.amount * y.avg_after_wo / y.avg_toanhang) as amount_da_phan_bo
from tmp_dtkd_chua_phan_bo x 
join tmp_dtkd_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'toanhang'
  where a.area_code not in ('HEAD', 'toanhang')
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code not in ( 'toanhang');

 /*CP hoa hong  */
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_laitronghan_chua_phan_bo ;

insert into tmp_chiphihoahong_chua_phan_bo (month_key, area_code, amount)
---- lÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â£i trong hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚ÂºÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¡n DVML 70455003154 
select 202302 as month_key , 'HEAD'  as area_code , sum(amount) ascp_hoahong
from fact_txn_month_raw_data ftm 
where account_code   in ('816000000001','816000000002','816000000003') 
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
--and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H','H')
group by substring(analysis_code,9,1)

union all
-- CP hoa hong DVML

select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) ascp_hoahong
from fact_txn_month_raw_data ftm 
where account_code  in ('816000000001','816000000002','816000000003') 
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;

----
-- step 3 : tinh lai trong han da phan bo :
truncate table tmp_chiphihoahong_da_phan_bo ;

--them data
INSERT INTO baicuoikhoa.tmp_chiphihoahong_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as

select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
x.amount + (z.amount * y.avg_after_wo / y.avg_toanhang) as amount_da_phan_bo
from tmp_chiphihoahong_chua_phan_bo x 
join tmp_chiphihoahong_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'toanhang'
  where a.area_code not in ('HEAD', 'toanhang')
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code not in ( 'toanhang');


 /*CP thuan KD khac  */
-- CP thuan KD khac - HEAD
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_chiphithuankd_chua_phan_bo ;

insert into tmp_chiphithuankd_chua_phan_bo (month_key, area_code, amount)

select 	202302 as month_key,
		'HEAD' as area_code  ,
		sum(amount) as laitronghan
from fact_txn_month ftm 
left join dim_province dp on ftm.area_code = dp.area_code 
where account_code  in ('809000000002','809000000001','811000000001','811000000102','811000000002','811014000001','811037000001',
'811039000001','811041000001','815000000001','819000000002','819000000003','819000000001','790000000003',
'790000050101','790000000101','790037000001','849000000001','899000000003','899000000002','811000000101','819000060001')
and analysis_code like 'HEAD%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) between 1 and 2
group by dp.area_code  

union all

select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount) ascp_hoahong
from fact_txn_month_raw_data ftm 
where account_code  in ('809000000002','809000000001','811000000001','811000000102','811000000002','811014000001','811037000001',
'811039000001','811041000001','815000000001','819000000002','819000000003','819000000001','790000000003',
'790000050101','790000000101','790037000001','849000000001','899000000003','899000000002','811000000101','819000060001')
and analysis_code like 'DVML%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;

----
-- step 3 : tinh lai trong han da phan bo :
truncate table tmp_chiphithuankd_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_chiphithuankd_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as

select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
x.amount + (z.amount * y.avg_after_wo / y.avg_toanhang) as amount_da_phan_bo
from tmp_chiphithuankd_chua_phan_bo x 
join tmp_chiphithuankd_chua_phan_bo z on z.area_code = 'HEAD'
-- tinh ty trong phan bo 
left join 
(
  select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang 
  from tmp_dnck_after_wo a 
  join tmp_dnck_after_wo b on b.area_code = 'toanhang'
  where a.area_code not in ('HEAD', 'toanhang')
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code not in ( 'toanhang');

 /*CP thuan kd  (net) */
/*CP thue, phi*/
/*CP nhan vien*/
-- step 1 : do du lieu lai trong han tu GL vao bang tam
truncate table tmp_chiphinhanvien_chua_phan_bo ;

insert into tmp_chiphinhanvien_chua_phan_bo(month_key, area_code, amount)

select 	202302 as month_key,
		'HEAD'as area_code  ,
		sum(amount)
from fact_txn_month ftm 
left join dim_province dp on ftm.area_code = dp.area_code 
where analysis_code like 'HEAD%' 
and cast(account_code as varchar) like '85%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) between 1 and 2
group by dp.area_code

union all
--CP nhan vien -15074158721  dvml -7543017008 
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount)
from fact_txn_month_raw_data ftm 
where analysis_code like 'DVML%'
and cast(account_code as varchar) like '85%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;

----
-- step 3 : tinh lai trong han da phan bo :
truncate table tmp_chiphinhanvien_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_chiphinhanvien_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as
	
	select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
	x.amount + (z.amount * y.sale_manager_area/y.sale_manager_toanhang) as amount_da_phan_bo
	from tmp_chiphinhanvien_chua_phan_bo x 
	join tmp_chiphinhanvien_chua_phan_bo z on z.area_code = 'HEAD'
	-- tinh ty trong phan bo 
	left join 
	(
	  select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang, a.sale_manager as sale_manager_area, b.sale_manager as sale_manager_toanhang 
	  from tmp_dnck_after_wo a 
	  join tmp_dnck_after_wo b on b.area_code = 'toanhang'
	  where a.area_code not in ('HEAD', 'toanhang')
	) y on x.month_key = y.month_key and x.area_code = y.area_code 
	where x.area_code not in ( 'toanhang');

/*CP quan ly*/
--xoa du lieu truoc khi  them data
truncate table tmp_chiphiquanly_chua_phan_bo ;

insert into tmp_chiphiquanly_chua_phan_bo(month_key, area_code, amount)
--CP nhan vien  head
select 	202302 as month_key,
		'HEAD'as area_code  ,
		sum(amount)
from fact_txn_month ftm 
left join dim_province dp on ftm.area_code = dp.area_code 
where analysis_code like 'HEAD%' 
and cast(account_code as varchar) like '86%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) between 1 and 2
group by dp.area_code

union all
--CP nhan vien -15074158721  dvml -7543017008 
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount)
from fact_txn_month_raw_data ftm 
where analysis_code like 'DVML%'
and cast(account_code as varchar) like '86%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;


-- step 3 : tinh lai trong han da phan bo :
truncate table tmp_chiphiquanly_da_phan_bo ;

INSERT INTO baicuoikhoa.tmp_chiphiquanly_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as
	
	select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
	x.amount + (z.amount * y.sale_manager_area/y.sale_manager_toanhang) as amount_da_phan_bo
	from tmp_chiphiquanly_chua_phan_bo x 
	join tmp_chiphiquanly_chua_phan_bo z on z.area_code = 'HEAD'
	-- tinh ty trong phan bo 
	left join 
	(
	  select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang, a.sale_manager as sale_manager_area, b.sale_manager as sale_manager_toanhang 
	  from tmp_dnck_after_wo a 
	  join tmp_dnck_after_wo b on b.area_code = 'toanhang'
	  where a.area_code not in ('HEAD', 'toanhang')
	) y on x.month_key = y.month_key and x.area_code = y.area_code 
	where x.area_code not in ( 'toanhang');

/*CP tai san*/

--xoa du lieu truoc khi  them data
truncate table tmp_chiphitaisan_chua_phan_bo ;

insert into tmp_chiphitaisan_chua_phan_bo(month_key, area_code, amount)
--CP tai san  head
select 	202302 as month_key,
		'HEAD'as area_code  ,
		sum(amount)
from fact_txn_month ftm 
left join dim_province dp on ftm.area_code = dp.area_code 
where analysis_code like 'HEAD%' 
and cast(account_code as varchar) like '87%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) between 1 and 2
group by dp.area_code

union all
--CP tai san -15074158721  dvml -7543017008 
select 202302 as month_key , substring(analysis_code,9,1)  as area_code , sum(amount)
from fact_txn_month_raw_data ftm 
where analysis_code like 'DVML%'
and cast(account_code as varchar) like '87%'
and extract(year from transaction_date) = 2023
and extract(month from transaction_date) <= 2
and extract(month from transaction_date) >= 1
and substring(analysis_code,9,1) in ('B','C','D','E','F','G','H')
group by substring(analysis_code,9,1) ;


-- step 3 : tinhchi phi tai san:
truncate table tmp_chiphitaisan_da_phan_bo  ;

INSERT INTO baicuoikhoa.tmp_chiphitaisan_da_phan_bo 
-- create table tmp_laitronghan_da_phan_bo as
	
select x.month_key , x.area_code , x.amount as amount_chua_phan_bo, z.amount as amount_head , y.avg_after_wo , y.avg_toanhang ,
x.amount + (z.amount * y.sale_manager_area/y.sale_manager_toanhang) as amount_da_phan_bo
from tmp_chiphitaisan_chua_phan_bo x  
join tmp_chiphitaisan_chua_phan_bo z on z.area_code = 'HEAD'
	-- tinh ty trong phan bo 
left join 
(select a.month_key , a.area_code , a.avg_after_wo , b.avg_toanhang as avg_toanhang, a.sale_manager as sale_manager_area, b.sale_manager as sale_manager_toanhang 
from tmp_dnck_after_wo a 
join tmp_dnck_after_wo b on b.area_code = 'toanhang'
where a.area_code not in ('HEAD', 'toanhang')
) y on x.month_key = y.month_key and x.area_code = y.area_code 
where x.area_code not in ('HEAD', 'toanhang');


------------------------------------------------------------------------
------------------------------------------------------------------------
-- xoa data truoc khi do vao
truncate table fact_summary_report_fin_monthly;

-- fact_summary_report_fin_monthly
--
INSERT INTO baicuoikhoa.fact_summary_report_fin_monthly
(report_id, month_key, head_amt, tnb_area_amt, ntb_area_amt, btb_area_amt, dbd_area_amt, tbb_area_amt, dnb_area_amt, dbsh_area_amt)
SELECT
    id,
    202302 as month_key,
    ROUND(SUM(CASE WHEN h.area_code = 'HEAD' THEN h.amount_chua_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "HEAD",
    ROUND(SUM(CASE WHEN h.area_code = 'B' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "Mi?n Tây Nam B?",
    ROUND(SUM(CASE WHEN h.area_code = 'C' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "Nam Trung B?",
    ROUND(SUM(CASE WHEN h.area_code = 'D' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "B?c Trung B?",
    ROUND(SUM(CASE WHEN h.area_code = 'E' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "?ông B?c B?",
    ROUND(SUM(CASE WHEN h.area_code = 'F' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "Tây B?c B?",
    ROUND(SUM(CASE WHEN h.area_code = 'G' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "Mi?n ?ông Nam B?",
    ROUND(SUM(CASE WHEN h.area_code = 'H' THEN h.amount_da_phan_bo / 1000000.0 ELSE 0 END)::numeric, 2)/1000000 AS "?B Sông H?ng"
FROM  
(	
	    -- Câu truy v?n c?a b?n ?ã ???c ch?nh s?a ?? chèn vào b?ng dimension
    SELECT 3 as id, a.area_code, 'Lãi trong hạn' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_laitronghan_da_phan_bo a

    UNION ALL
    SELECT 4 as id, a.area_code, 'Lãi qua han' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_laiquahan_da_phan_bo a
    
    UNION ALL
    SELECT 5 as id, a.area_code, 'Phí bao hiem' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_phibaohiem_da_phan_bo  a
    
    UNION ALL
    SELECT 6 as id, a.area_code, 'Phí t?ng h?n m?c' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_phitanghanmuc_da_phan_bo  a
    
    UNION ALL
    SELECT 7 as id, a.area_code, 'Phí khác' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_phikhac_da_phan_bo  a
    
    UNION all
    SELECT 9 as id, '' as area_code, 'DT Ngu?n v?n ' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    UNION all
    --ccp von tt2
    SELECT 10 as id, a.area_code, 'CP v?n TT 2' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_cptt2_da_phan_bo  a
    
    -- chi phi von tt1
    UNION all
    select 11 as id, '' as area_code, 'CP von TT 1' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    
    UNION ALL
    SELECT 12 as id, a.area_code, 'CP von CCTG' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_cctg_da_phan_bo  a
    
    -- dt fintech
    UNION all
    select 14 as id, '' as area_code, 'DT Fintech' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    -- dt tieu thuong, ca nhan
    UNION all
    select 15 as id, '' as area_code, 'DT ti?u th??ng, cá nhân' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    UNION ALL
    SELECT 13 as id, a.area_code, 'DT Kinh doanh' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_dtkd_da_phan_bo  a
    
    UNION ALL
    SELECT 17 as id, a.area_code, 'CP hoa hong' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_chiphihoahong_da_phan_bo   a
    
    UNION ALL
    SELECT 18 as id, a.area_code, 'CP thu?n KD khác' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_chiphithuankd_da_phan_bo a
    
     -- chi phi hop tac kd tau
    UNION all
    select 19 as id, '' as area_code, 'CP h?p tác kd tàu (net)' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    -- chi phi thue, phi
    UNION all
    select 22 as id, '' as area_code, 'CP thu?, phí' AS tieu_chi, 0 as amount_da_phan_bo, 0 as amount_chua_phan_bo
    
    UNION ALL
    SELECT 23 as id, a.area_code, 'CP nhân viên' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_chiphinhanvien_da_phan_bo   a
    
    UNION ALL
    SELECT 24 as id, a.area_code, 'CP qu?n lý' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_chiphiquanly_da_phan_bo   a
    
    UNION ALL
    SELECT 25 as id, a.area_code, 'CP tài s?n' AS tieu_chi, a.amount_da_phan_bo, a.amount_chua_phan_bo
    FROM tmp_chiphitaisan_da_phan_bo   a
) AS h	
GROUP BY tieu_chi, id;
END;
$procedure$