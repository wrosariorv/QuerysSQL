USE [RVF_Local]
GO

/****** Object:  Table [dbo].[RVF_TBL_IMP_QUOTE_HEADER]    Script Date: 21/10/2025 15:16:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RVF_TBL_IMP_QUOTE_HEADER]') AND type in (N'U'))
DROP TABLE [dbo].[RVF_TBL_IMP_QUOTE_HEADER]
GO



CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_HEADER](
	[Company] [varchar](10) NOT NULL,
	[QuoteNum] [varchar](50) NOT NULL,
	[EntryDate] [date] NOT NULL,
	[CustNum] [int] NOT NULL,
	[ShipToNum] [varchar](50) NOT NULL,
	[PONum] [varchar](50) NULL,
	[MktgCampaignID] [varchar](50) NOT NULL,
	[TermsCode] [varchar](50) NOT NULL,
	[RequestDate] [date] NOT NULL,
	[CustID] [varchar](50) NOT NULL,
	[Territory][varchar](50) NOT NULL,
	[SalesRepCode][varchar](50) NOT NULL,
	[DateTime][datetime] NOT NULL,
 CONSTRAINT [PK_RVF_TBL_IMP_QUOTE_HEADER] PRIMARY KEY CLUSTERED 
(
	[Company] ASC,
	[QuoteNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[RVF_TBL_IMP_QUOTE_DETAIL]    Script Date: 21/10/2025 15:20:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RVF_TBL_IMP_QUOTE_DETAIL]') AND type in (N'U'))
DROP TABLE [dbo].[RVF_TBL_IMP_QUOTE_DETAIL]
GO



CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_DETAIL](
	[Company] [varchar](10) NOT NULL,
	[QuoteNum] [varchar](50) NOT NULL,
	[QuoteLine] [int] NOT NULL,
	[PartNum] [varchar](50) NOT NULL,
	[SellingExpectedQty] [int] NOT NULL,
	[ListPrice] [decimal](17, 5) NOT NULL,
	[DiscountPercent] [float] NULL,
 CONSTRAINT PK_RVF_TBL_IMP_QUOTE_DETAIL 
        PRIMARY KEY (Company, QuoteNum, QuoteLine),
    CONSTRAINT FK_RVF_TBL_IMP_QUOTE_DETAIL_Header 
        FOREIGN KEY (Company, QuoteNum)
        REFERENCES [dbo].[RVF_TBL_IMP_QUOTE_HEADER] (Company, QuoteNum)
         ON DELETE CASCADE   -- ?? descomenta si querés que al eliminar el header se eliminen los detalles
		 )


CREATE NONCLUSTERED INDEX IX_RVF_TBL_IMP_QUOTE_DETAIL_Company_QuoteNum
    ON [dbo].[RVF_TBL_IMP_QUOTE_DETAIL] (Company, QuoteNum);
GO

/*
CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_HEADER] (
    Company           NVARCHAR(10)     NOT NULL,
    QuoteNum          INT              NOT NULL,
    EntryDate         DATE             NULL,
    CustNum           INT              NULL,
    ShipToNum         NVARCHAR(50)     NULL,
    PONum             NVARCHAR(100)    NULL,
    MktgCampaignID    NVARCHAR(50)     NULL,
    TermsCode         NVARCHAR(10)     NULL,
    RequestDate       DATE             NULL,
    CustID            NVARCHAR(50)     NULL,
    Territory         NVARCHAR(50)     NULL,
	SalesRepCode	  NVARCHAR(50)     NULL,
    CONSTRAINT PK_RVF_TBL_IMP_QUOTE_HEADER PRIMARY KEY (Company, QuoteNum)
);



CREATE TABLE [dbo].[RVF_TBL_IMP_QUOTE_DETAIL] (
    Company             NVARCHAR(10)     NOT NULL,
    QuoteNum            INT              NOT NULL,
    QuoteLine           INT              NOT NULL,
    PartNum             NVARCHAR(100)    NOT NULL,
    SellingExpectedQty  DECIMAL(18,2)    NULL,
    ListPrice           DECIMAL(18,5)    NULL,
    DiscountPercent     DECIMAL(9,2)     NULL,
    CONSTRAINT PK_RVF_TBL_IMP_QUOTE_DETAIL 
        PRIMARY KEY (Company, QuoteNum, QuoteLine),
    CONSTRAINT FK_RVF_TBL_IMP_QUOTE_DETAIL_Header 
        FOREIGN KEY (Company, QuoteNum)
        REFERENCES [dbo].[RVF_TBL_IMP_QUOTE_HEADER] (Company, QuoteNum)
         ON DELETE CASCADE   -- ?? descomenta si querés que al eliminar el header se eliminen los detalles
);
GO


CREATE NONCLUSTERED INDEX IX_RVF_TBL_IMP_QUOTE_DETAIL_Company_QuoteNum
    ON [dbo].[RVF_TBL_IMP_QUOTE_DETAIL] (Company, QuoteNum);
GO
*/