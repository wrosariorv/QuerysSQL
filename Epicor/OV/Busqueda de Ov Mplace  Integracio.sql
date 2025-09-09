

select [Company], [Key1], [Key2], [Key3], [Key4], [Key5], [ShortChar01], [Number01], [Number02],  [ShortChar02],[ShortChar05],[Date01],[CheckBox01] from [Ice].[UD35]
where
[Company] ='CO01'
and [Key1]='SC VENTAS WEB'
AND [Key4] in ('M00184','M00182')
order by Key2 desc