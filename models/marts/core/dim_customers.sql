-- config block to change from view to tables as per the below config (double
-- underscore will prompt config)
-- -{{ config(materialized="table") }}
-- Commenting the above line to use materialization through dbt_project.yml file
-- referencing the model from stg_customers.sql by referencing the informations .
-- Previous info available in customers.sql
with
    customers as (select * from {{ ref("stg_customers") }}),
--orders as (select * from {{ ref("stg_orders") }}), as per assesment added new fct_order and ref it
    orders as (select * from {{ ref("fct_orders") }}),

    customer_orders as (
        select
            customerid,
            min(order_date) as firstorderdate,
            max(order_date) as lastorderdate,
            count(orderid) as number_of_orders,
            sum(amount) as lifeetime_value
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
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
            customer_orders.lifeetime_value
        from customers
        left join customer_orders using (customerid)
    )
select *
from final
