--Model removing the customers section from dim_customers.sql , For ref check customers.sql

with
    customers as (
        select id as customerid, first_name, last_name from raw.jaffle_shop.customers
    )

    select * from customers