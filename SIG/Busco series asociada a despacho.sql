SELECT 'CO01' as Company, st.SerialNumber,st.PartNum,  FROM SeriesTemporal st WHERE st.IdOrdenes IN (
  SELECT [Id]
 
  FROM [SIG-CD].[dbo].[Ordenes]
  WHERE OrderNUm = '278408'
  )


  SELECT * FROM SeriesTemporal st WHERE st.IdOrdenes IN (
  SELECT [Id]
 
  FROM [SIG-CD].[dbo].[Ordenes]
  WHERE OrderNUm = '278408'
  )

  SELECT A.Company,A.Plant,A.OrderNum,A.OrderLine,A.OrderRelNum, st.PartNum, st.SerialNumber
 
  FROM [SIG-CD].[dbo].[Ordenes] A
  inner join (
					  SELECT * FROM SeriesTemporal st WHERE st.IdOrdenes IN (
					  SELECT [Id]
 
					  FROM [SIG-CD].[dbo].[Ordenes]
					  WHERE OrderNUm = '278408'
				
						)
				)ST
	on  A.ID		= ST.IdOrdenes

			

  WHERE OrderNUm = '278408'