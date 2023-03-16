-- config block to change from view to tables as per the below config (double underscore will prompt config)

{{
    config(
        materialized='table'
    )
}}


with
    customers as (
        select id as customerid, first_name, last_name from raw.jaffle_shop.customers
    ),
    orders as (
        select id as orderid, user_id as customerid, order_date, status
        from raw.jaffle_shop.orders
    ),
    customer_orders as (
        select
            customerid,
            min(order_date) as firstorderdate,
            max(order_date) as lastorderdate,
            count(orderid) as number_of_orders
        from orders
        group by 1
    ),
    final as (
        select
            customers.customerid,
            customers.first_name,
            customers.last_name,
            customer_orders.firstorderdate,
            customer_orders.lastorderdate,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        from customers
        left join customer_orders using (customerid)
    )
select *
from final
