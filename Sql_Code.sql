 --Is this the same across store locations?

select distinct(st.store_location),
 sum((p.Product_Price)-(p.Product_Cost)) as profit
 from `gc01-377205.Maven_toys.Products`
  p join `gc01-377205.Maven_toys.sale` s on p.Product_ID=s.product_id 
 join `gc01-377205.Maven_toys.stores` st on s.Store_ID=st.Store_ID
 group by  st.Store_Location
order by profit desc;

--Which product categories drive the biggest profits?

select distinct(p.Product_Category),
 sum((p.Product_Price)-(p.Product_Cost)) as profit
 from `gc01-377205.Maven_toys.Products`
  p join `gc01-377205.Maven_toys.sale` s on p.Product_ID=s.product_id 
 join `gc01-377205.Maven_toys.stores` st on s.Store_ID=st.Store_ID
 group by  p.Product_Category
order by profit desc;

--Can you find any seasonal trends or patterns in the sales data?

 --jan to march q1
 
 select  sum(Units*Product_Price) as Q1_total_sales from `gc01-377205.Maven_toys.sale` as s
 join `gc01-377205.Maven_toys.Products` p  using(product_id)
 where date between '2017-01-01' and '2017-03-31';
 
--Q2

 select  sum(Units*Product_Price) as Q2_total_sales from `gc01-377205.Maven_toys.sale` as s
 join `gc01-377205.Maven_toys.Products` p  using(product_id)
 where date between '2017-04-01' and '2017-06-30';
 
 --july to sep Q3

  select  sum(Units*Product_Price) as Q3_total_sales from `gc01-377205.Maven_toys.sale` as s
 join `gc01-377205.Maven_toys.Products` p  using(product_id)
 where date between '2017-07-01' and '2017-09-30';
 
--oct to dec Q4

 select  sum(Units*Product_Price) as Q4total_sales from `gc01-377205.Maven_toys.sale` as s
 join `gc01-377205.Maven_toys.Products` p  using(product_id)
 where date between '2017-10-01' and '2017-12-31'
 
--Are sales being lost with out-of-stock products at certain locations?

  select 
  st.Store_Name,
 sum(p.Product_Price*s.Units) as total_sales, 
 from `gc01-377205.Maven_toys.product`as p 
 join `gc01-377205.Maven_toys.sale` as s on p.Product_ID=s.Product_ID
 join `gc01-377205.Maven_toys.stores` as st on s.Store_ID=st.Store_ID
 join `gc01-377205.Maven_toys.inventory`as i on p.Product_ID=i.Product_ID
where i.Stock_On_Hand!=0
 group by st.Store_Name
 order by total_sales desc;
  select 
  st.Store_Name,
 sum(p.Product_Price*s.Units) as total_sales, 
 from `gc01-377205.Maven_toys.product`as p 
 join `gc01-377205.Maven_toys.sale` as s on p.Product_ID=s.Product_ID
 join `gc01-377205.Maven_toys.stores` as st on s.Store_ID=st.Store_ID
 join `gc01-377205.Maven_toys.inventory`as i on p.Product_ID=i.Product_ID
where i.Stock_On_Hand=0
 group by st.Store_Name
 order by total_sales desc;
--question 4

--How much money is tied up in inventory at the toy stores? How long will it last?

SELECT 
Store_Name,
Product_Category,
round(sum(Product_Cost*Stock_On_Hand),0)as investment_in_store from `gc01-377205.Maven_toys.inventory` as i 
join `gc01-377205.Maven_toys.Products` p using(product_id)
join `gc01-377205.Maven_toys.stores` s using(store_id)
where Stock_On_Hand !=0 and Product_Category='Toys'
group by store_name,Product_Category
order by investment_in_store desc;
