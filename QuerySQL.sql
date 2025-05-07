Alias:
kf_final_transaction as t
kr_inventory as i
kf_kantor_cabang as c
kf_product as p


CREATE OR REPLACE TABLE `kimia_farma`.kf_analisa AS
SELECT
t.transaction_id,
t.date,
c.branch_id,
c.branch_name,
c.kota,
c.provinsi,
c.rating AS rating_cabang,
t.customer_name,
p.product_id,
p.product_name,
p.price AS actual_price,
t.discount_percentage,
CASE
  WHEN p.price <= 50000 THEN 0.10
  WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
  WHEN p.price >100000 AND p.price <=300000 THEN 0.20
  WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
  ELSE 0.30
END AS persentase_gross_laba,
p.price * (1 -(t.discount_percentage)) AS nett_sales,
(p.price * (1 - t.discount_percentage)) * 
CASE
  WHEN p.price <= 50000 THEN 0.10
  WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
  WHEN p.price >100000 AND p.price <=300000 THEN 0.20
  WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
  ELSE 0.30
END AS nett_profit,
t.rating AS rating_transaksi,
FROM 
  `kimia_farma.kf_final_transaction` t
JOIN 
  `kimia_farma.kf_product` p ON t.product_id = p.product_id
JOIN 
  `kimia_farma.kf_kantor_cabang` c ON t.branch_id = c.branch_id
JOIN 
  `kimia_farma.kf_inventory` i ON t.branch_id = i.branch_id AND t.product_id = i.product_id;
