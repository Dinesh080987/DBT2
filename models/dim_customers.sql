-- config block to change from view to tables as per the below config (double
-- underscore will prompt config)
{{ config(materialized="table") }}

-- referencing the model from stg_customers.sql by referencing the informations .
-- Previous info available in customers.sql
with
    customers as (select * from {{ ref("stg_customers") }}),

    orders as (select * from {{ ref("stg_orders") }}),

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
