with cte1 as 
( -- get latest purchased date of each customer
select [Mã KH]
, max([Ngày hạch toán]) as Latest_date
, count([Đơn hàng]) as Frequency
, sum([Doanh thu]) as Monetary
from [dbo].['Dữ liệu bán hàng$'] ct2 
where [Doanh thu] > 0
group by [Mã KH]
) 
, cte2 as 
( -- get R,F,M metrics
select [Mã KH]
, DATEDIFF(day,Latest_date,(select max([Ngày hạch toán]) from [dbo].['Dữ liệu bán hàng$'])) as Recency
, Frequency
, Monetary
from cte1
)
, cte3 as 
( -- rank R,F,M metrics by interquartile
select *
, NTILE(4) over (order by Recency DESC) as R 
, NTILE(4) over (order by Frequency) as F 
, NTILE(4) over (order by Monetary) as M
from cte2
) 
select *, CONCAT(R,F,M) as segment
from cte3
