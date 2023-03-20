        select id as payment_id,
        id as orderid,
        paymentmethod as payment_method,
        status,
        --amount converted from cents to dollars
         amount / 100 as amount, 
         created as create_at
        from raw.stripe.payment
   