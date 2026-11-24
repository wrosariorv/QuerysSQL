--CREATE SCHEMA [SF]

/*
ALTER PROCEDURE [SF].[ConsultoDocumento](@ID INT ,@Responsable INT )
AS
--*/
--/*
DECLARE
@ID INT         =64383,
@Responsable INT    =659
--*/

SELECT  CT.IDTrabajo,
        CD.ID,
        CT.Responsable,
        CD.UNC          AS Ruta,
        CD.Descripcion
FROM            [CORPCIBDB01].[RadioVictoria].dbo.CC_Documentacion  CD
INNER JOIN      [CORPCIBDB01].[RadioVictoria].dbo.CS_Trabajos       CT
    ON CD.IDOrigen = CT.IDTrabajo
WHERE   CT.FechaAlta    >= '20240101'
  AND   CT.FechaAlta    <  '20260802'
  AND   CD.Relacion     = 'CS_Trabajos'
  AND   CD.ID           = @ID
  AND   CT.Responsable  = @Responsable
GO


  



CREATE TABLE [SF].[Log_SaleForce](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Identificador] [uniqueidentifier] NOT NULL,
	[IDResponsable] [int] NULL,
	[Ruta] [nvarchar](50) NULL,
	[Fecha] [datetime] NOT NULL,
	[Estado] [nvarchar](MAX) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SF].[Log_SaleForce] ADD  DEFAULT (getdate()) FOR [Fecha]
GO

ALTER TABLE [SF].[Log_SaleForce] ADD  DEFAULT ('Pendiente') FOR [Estado]
GO


