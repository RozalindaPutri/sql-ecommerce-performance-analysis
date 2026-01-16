-- 1. Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
-- (after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.

select 
extract (month from order_date) as bulan,
sum(after_discount) as total_transaksi
from `finpro-480409.tokopaedi.order_detail`
where extract (year from order_date) = 2021 and is_valid = 1
group by 1
order by 2 desc
limit 1;

--2. Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
-- besar? Gunakan is_valid = 1 untuk memfilter data transaksi.

select 
s.category as kategori,
sum(o.after_discount) as total_transaksi
from `finpro-480409.tokopaedi.order_detail` as o
join `finpro-480409.tokopaedi.sku_detail` as s
on o.sku_id = s.id
where extract (year from o.order_date) = 2022 and o.is_valid = 1
group by 1
order by 2 desc
limit 1;

-- Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
--Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
--penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data transaksi.

select
s.category as kategori,
SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2021 THEN o.after_discount ELSE 0 END) AS total_2021,
  SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2022 THEN o.after_discount ELSE 0 END) AS total_2022,
    (SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2022 THEN o.after_discount ELSE 0 END) -
    SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2021 THEN o.after_discount ELSE 0 END)) AS selisih,
    CASE WHEN SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2022 THEN o.after_discount ELSE 0 END) > 
    SUM(CASE WHEN EXTRACT(YEAR FROM o.order_date) = 2021 THEN o.after_discount ELSE 0 END)
    THEN 'Naik'
    ELSE 'Turun'
  END AS status_perubahan
from `finpro-480409.tokopaedi.order_detail` as o
join `finpro-480409.tokopaedi.sku_detail` as s
on o.sku_id = s.id
where extract (year from o.order_date) in (2021,2022) and  o.is_valid = 1
group by 1
order by selisih desc;

-- Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
-- (berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.
select
p.payment_method as metode_bayar,
count(distinct o.id) total_digunakan
from `finpro-480409.tokopaedi.order_detail` as o
join `finpro-480409.tokopaedi.payment_detail` as p
on o.payment_id = p.id
where extract (year from o.order_date) = 2022  and  o.is_valid = 1
group by 1
order by 2 desc
limit 5;

-- Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
--1. Samsung,2. Apple,3. Sony,4. Huawei,5. Lenovo
--Gunakan is_valid = 1 untuk memfilter data transaksi.

select 
case
  when lower(s.sku_name) like '%samsung%' then 'samsung'
  when lower(s.sku_name) like '%apple%' or lower(s.sku_name) like     '%imac%' or lower(s.sku_name) like '%iphone%' or lower(s.sku_name) like '%macbook%' then 'apple'
  when lower(s.sku_name) like '%sony%' then 'Sony'
  when lower(s.sku_name) like '%huawei%' then 'Huawei'
  when lower(s.sku_name) like '%lenovo%' then 'Lenovo'
  else 'other'
end as produk,
sum(o.after_discount) as total_transaksi
from `finpro-480409.tokopaedi.order_detail` as o
join `finpro-480409.tokopaedi.sku_detail` as s
on o.sku_id = s.id
where o.is_valid = 1
group by produk
having produk != 'other'
order by total_transaksi desc
limit 5;

