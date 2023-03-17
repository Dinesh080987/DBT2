
--Model removing the orders section from dim_customers.sql , For ref check customers.sql
with
    orders as (
        select id as orderid, user_id as customerid, order_date, status
        from raw.jaffle_shop.orders
    )
select *
from orders
