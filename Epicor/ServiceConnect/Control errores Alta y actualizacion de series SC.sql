select [Company], [Key1], [Key2], [Key3], [Key4], [ShortChar01], [ShortChar02], [ShortChar03], [ShortChar04],[Date01]
from [Ice].[UD35]
where [Key1]= 'SC UPDATE SERIES'
order by Key2 desc

order by convert(date ,[KEy2]) desc




select Key1, Key2, Key3, Key4, ShortChar04 from [Ice].[UD35]
where [Key1]= 'SC ALTA SERIES'
AND KEY3 in ('RF2300500008269')
order by [Key2] DESC



