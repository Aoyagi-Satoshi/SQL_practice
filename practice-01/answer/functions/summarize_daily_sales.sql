CREATE OR REPLACE FUNCTION summarize_daily_sales(target_date date)
RETURNS void
LANGUAGE 'plpgsql'    
AS $BODY$
DECLARE
product_record RECORD;
BEGIN
    FOR product_record IN SELECT product_id FROM products LOOP
        INSERT INTO daily_sales_summary
            (
            summary_date,
            product_id,
            total_quantity_sold,
            total_sales_amount
            )
        SELECT
            target_date,
            p.product_id,
            COALESCE(SUM(order_details.quantity), 0),
            COALESCE(SUM(p.price * order_details.quantity), 0)
        FROM products AS p
            LEFT JOIN order_details
            ON p.product_id = order_details.product_id
        WHERE p.product_id = product_record.product_id
        GROUP BY p.product_id;
    END LOOP;
END;
$BODY$;