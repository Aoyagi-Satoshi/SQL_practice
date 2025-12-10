CREATE OR REPLACE FUNCTION create_testdate(start_date date, end_date date) 
RETURNS void 
LANGUAGE 'plpgsql' 
AS $$
DECLARE
    row_order orders%ROWTYPE;
BEGIN
    INSERT INTO orders (order_datetime)
    SELECT
        d::date + (random() * INTERVAL '23 hours')
    FROM
        generate_series(start_date, end_date, '1 day') AS d;

    FOR row_order IN
        SELECT * 
		FROM orders
        WHERE order_datetime::date BETWEEN start_date AND end_date
    LOOP

        INSERT INTO order_details (order_id, product_id, quantity)
        SELECT
            row_order.order_id,
            (1 + floor(random() * 5))::int,
            (1 + floor(random() * 10))::int
        FROM
            generate_series(1,1 + floor(random() * 3)::int);
    END LOOP;
END;
$$;