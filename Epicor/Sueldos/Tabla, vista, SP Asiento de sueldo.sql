USE [RVF_Local]
GO

/****** Object:  Table [dbo].[RVF_TBL_ASIENTOS_DE_SUELDO]    Script Date: 4/13/2021 2:24:19 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RVF_TBL_ASIENTOS_DE_SUELDO]') AND type in (N'U'))
DROP TABLE [dbo].[RVF_TBL_ASIENTOS_DE_SUELDO]
GO

/****** Object:  Table [dbo].[RVF_TBL_ASIENTOS_DE_SUELDO]    Script Date: 4/13/2021 2:24:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
select * from [RVF_TBL_ASIENTOS_DE_SUELDO]

select * from RVF_VW_ASIENTOS_DE_SUELDO
SELECT  [Company]
      ,[GLJrnHed_Description]
      ,[GLJrnHed_JEDate]
      ,[GLAccount]
      ,[TotDebit]
      ,[TotCredit]
      ,[CommentText]
      ,[Check_box01]
      ,[GLJrnHed_ID]
  FROM [RVF_Local].[dbo].[RVF_TBL_ASIENTOS_DE_SUELDO]

  EXEC RVF_PRC_ASIENTOS_DE_SUELDO

CREATE TABLE [dbo].[RVF_TBL_ASIENTOS_DE_SUELDO](
	[Company] [varchar](15) NOT NULL,
	[GLJrnHed_Description] [varchar](15) NOT NULL,
	[GLJrnHed_JEDate] [date] NOT NULL,
	[GLAccount] [varchar](15) NOT NULL,
	[TotDebit] [decimal](18, 5) NOT NULL,
	[TotCredit] [decimal](18, 5) NOT NULL,
	[CommentText] [varchar](max) NOT NULL,
	[Check_box01] [bit] NOT NULL,
	[GLJrnHed_ID]UniqueIdentifier NOT NULL default newid()
CONSTRAINT [PK_RVF_TBL_ASIENTOS_DE_SUELDO] PRIMARY KEY CLUSTERED 
(
	[Company] ASC,
	[GLJrnHed_JEDate] ASC,
	[GLJrnHed_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


