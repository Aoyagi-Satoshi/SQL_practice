CREATE OR REPLACE FUNCTION public.create_testdate(start_date date, end_date date) 
RETURNS void 
LANGUAGE 'plpgsql' 
AS $BODY$ 
DECLARE 
new_order_id INT;

BEGIN 
    WHILE start_date <= end_date LOOP
        INSERT INTO orders(order_datetime)
        VALUES(start_date + (random() * INTERVAL '23 hours')) 
            RETURNING order_id INTO new_order_id;
        INSERT INTO order_details(order_id, product_id, quantity)
        VALUES
            (
                new_order_id,
                (1 + floor(random() * 5)) :: INT,
                (1 + floor(random() * 10)) :: INT
            );
        start_date := start_date + INTERVAL '1 day';
    END LOOP;
END;
$BODY$;