--Model removing the customers section from dim_customers.sql , For ref check customers.sql

--with
--    customers as (
--       select id as customerid, first_name, last_name from raw.jaffle_shop.customers
--      commenting above line to use source instead of direct select
--          )
--
--    select * from customers
--refactor the above lines to use source
select 
id as customerid,
first_name,
last_name
from {{ source('jaffle_shop','customers')}}