USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_ACTUALIZA_DATOS_SHIPTO_MPLACE]    Script Date: 12/08/2021 09:48:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--/*
ALTER PROCEDURE		[dbo].[RVF_PRC_ACTUALIZA_DATOS_SHIPTO_MPLACE]	(		@CUSTNUM				int,
																			@Name					nvarchar(100),
																			@ResaleID				nvarchar(40),
																			@ShipToNum				nvarchar(28),
																			@Address1				nvarchar(100),
																			@Address2				nvarchar(100),
																			@Address3				nvarchar(100),
																			@City					nvarchar(100),
																			@State					nvarchar(100),
																			@ZIP					nvarchar(20),
																			@AGProvinceCode			nvarchar(8),
																			@AGGrossIncomeTaxID		nvarchar(40)
																		)
AS
--*/

Begin

		UPDATE	[CORPEPIDB].EpicorErp.ERP.ShipTo
		SET		[Name]					=		@NAme,
				[ResaleID]				=		@ResaleID,
				[Address1]				=		@Address1,
				[Address2]				=		@Address2,
				[Address3]				=		@Address3,
				[City]					=		@City,
				[State]					=		@State,	
				[ZIP]					=		@ZIP,
				[AGProvinceCode]		=		@AGProvinceCode,				
				[AGGrossIncomeTaxID]	=		@AGGrossIncomeTaxID

		WHERE
				CUSTNUM					=		@CUSTNUM
		AND		SHIPTONUM				=		@ShipToNum

END

GO


select		top 100
			[Name]
			,[ResaleID]
			,[Address1]
			,[Address2]
			,[Address3]
			,[City]
			,[State]
			,[ZIP]
			,AGProvinceCode
			,AGGrossIncomeTaxID

from
				[CORPEPIDB].EpicorErp.ERP.ShipTo		a
inner join		[CORPEPIDB].EpicorErp.ERP.ShipTo_ud		b
ON
				a.SysRowID			=		b.ForeignSysRowID
where
CUSTNUM  in (
'8640',
'8642',
'8649',
'8682',
'8737',
'8881',
'8887',
'8891',
'8892',
'8893',
'8894',
'8895',
'8896',
'8897',
'8898',
'8902',
'8903',
'8906',
'8907',
'8908',
'8909',
'8910',
'8911',
'8912',
'8913',
'8914',
'8915',
'8916',
'8943',
'8944',
'8963',
'8964',
'8982',
'8983',
'8984',
'8985',
'8986',
'8988',
'8989'
)

select top 100* from [CORPEPIDB].EpicorErp.ERP.ShipTo_ud

select			AGProvinceCode,AGGrossIncomeTaxID,* 
from			[CORPEPIDB].EpicorErp.ERP.customer		a
inner join		[CORPEPIDB].EpicorErp.ERP.customer_ud	b
ON
				a.SysRowID			=		b.ForeignSysRowID

where
CustID like 'M00%'


Customer_UD.ShortChar01

select ShortChar01,ShortChar03,* from [CORPEPIDB].EpicorErp.ERP.customer_ud
where
ShortChar01 <>''
and ShortChar03<>''