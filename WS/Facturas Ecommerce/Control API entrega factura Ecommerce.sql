USE [WS]
GO

/****** Object:  Schema [AS]    Script Date: 27/8/2025 12:37:12 ******/
CREATE SCHEMA [FA]
GO

CREATE TABLE [FA].[Log_Facturas_Ecommerce](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SysRowID] [uniqueidentifier] NOT NULL,
	[Company] [nvarchar](5) NULL,
	[InvoiceNum] [int] NULL,[Fecha] [datetime] NULL,
	[Estado] [nvarchar](3000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Log_Facturas_Ecommerce] ADD  DEFAULT (getdate()) FOR [Fecha]
GO

ALTER TABLE [dbo].[Log_Facturas_Ecommerce] ADD  DEFAULT ('Pendiente') FOR [Estado]
GO


--/*
ALTER PROCEDURE	[FA].[PRC_FacturasEcommerce] (@SysRowID UNIQUEIDENTIFIER)
AS
--*/

/*
DECLARE
@SysRowID UNIQUEIDENTIFIER = '8DC21ED2-889C-46B8-A250-7BBF97BDE4B8'
--*/

SELECT		
			Company,
			InvoiceNum,
			LegalNumber
			--,SysRowID
			--*
FROM		[CORPE11-EPIDB].EpicorERP.erp.InvcHead
WHERE
			--InvoiceNum=444054
			SysRowID		=		@SysRowID
		


		EXEC FA.PRC_FacturasEcommerce '8dc21ed2-889c-46b8-a250-7bbf97bde4b8'
		select * from [FA].[Log_Facturas_Ecommerce]

		truncate table [FA].[Log_Facturas_Ecommerce]