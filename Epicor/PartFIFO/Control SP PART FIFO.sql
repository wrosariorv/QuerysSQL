USE [RVF_Local]
GO

/****** Object:  Table [dbo].[CAEA_Control]    Script Date: 5/5/2021 11:57:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--Drop TAble [FIX_FIFO_Control]
CREATE TABLE [dbo].[FIX_FIFO_Control](
	[Fecha] [datetime] NOT NULL,
	[EnUso] [bit] NOT NULL,
	[Control_Error] [bit] NOT NULL
) ON [PRIMARY]
GO

select * from [FIX_FIFO_Control]

BEGIN    
    
DECLARE  @EnUso VARCHAR(5)    
    
SELECT  @EnUso  =  EnUso    
FROM  [FIX_FIFO_Control]    
    
IF   ISNULL(@EnUso, 0)  =  0    
    
 BEGIN    
    
  DELETE FROM [FIX_FIFO_Control]     
  INSERT INTO [FIX_FIFO_Control] VALUES (GETDATE(), '1')     
    
 END    
    
END  

-------------------------
SELECT   *    
FROM  [FIX_FIFO_Control]
-------------------------

------------------------

BEGIN

UPDATE		[CORPEPISSRS01].[RVF_Local].dbo.[FIX_FIFO_Control]
SET 		EnUso		=		'0'
WHERE		EnUso		=		'1'

END

------------------------