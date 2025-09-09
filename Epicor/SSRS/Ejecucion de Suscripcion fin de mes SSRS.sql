USE [RVF_Local]
GO

/****** Object:  StoredProcedure [dbo].[RVF_PRC_SIS_GENERA_REPORTES_FIN_DE_MES]    Script Date: 14/8/2023 12:11:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- /*

ALTER PROCEDURE	[dbo].[RVF_PRC_SIS_GENERA_REPORTES_FIN_DE_MES]
AS

-- */


----------------------------------------------------------

DECLARE		@FechaActual	DATE, 
			@FindeMes		DATE

SELECT		@FindeMes		=		EOMONTH (GETDATE()), 
			@FechaActual	=		CAST(GETDATE() AS DATE)

----------------------------------------------------------

IF			@FindeMes		=		@FechaActual
	BEGIN

			/****************************************************************
			Ejecuta Job
			****************************************************************/

			--'Detalle anticipos sin aplicar - Completo'
			EXEC msdb.dbo.sp_start_job N'8CCCCE37-75DD-4745-A6D4-D2CF09C05792'   

			-- 'Cuenta corriente Clientes - Completo'
			EXEC msdb.dbo.sp_start_job N'87EDD01B-B186-4F5F-B24F-E4732D7CD71E'

			-- 'Cuenta corriente Clientes - Resumen'
			EXEC msdb.dbo.sp_start_job N'F6941B97-3A00-4332-8C74-1F178C1FA9F4'

			-- 'Aging Clientes - China'
			EXEC msdb.dbo.sp_start_job N'E62EBB77-BB13-4E49-ACFE-20FCB8D65D94'

			-- 'Saldo deuda Cuenta Corriente'
			EXEC msdb.dbo.sp_start_job N'C27F5609-919D-4B40-BC6C-41AC3FC6337E'
			-- 'Facturas observadas Clientes'
			EXEC msdb.dbo.sp_start_job N'0B273136-705F-480D-804E-A5F926A02E3F'

	END

GO


