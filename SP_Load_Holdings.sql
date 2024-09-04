USE [PersonalFinance]
GO

/****** Object:  StoredProcedure [dbo].[Load_FundHoldings]    Script Date: 9/4/2024 1:28:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:			Bosco Wong
-- Create date:		2024-05-23
-- Description:		Create

-- exec dbo.Load_FundHoldings '2024-08-30'
-- =============================================
CREATE PROCEDURE [dbo].[Load_FundHoldings] (@ValDate DATE)

AS
BEGIN
	-- drop temp table if exist
IF OBJECT_ID('tempdb.dbo.#TempFundHoldings', 'U') IS NOT NULL
  DROP TABLE #TempFundHoldings; 

DECLARE @FullPath NVARCHAR(1200)
DECLARE @FilePath NVARCHAR(1000) = 'C:\Users\bosco\OneDrive\Data\SPDR_Daily_Data\Latest_Data\holdings-daily-us-en-spy_'
DECLARE @FileExt NVARCHAR(10) = '.csv';

SET @FullPath = @FilePath + CAST(@ValDate AS NVARCHAR(10))
SET @FullPath = @FullPath + @FileExt;

-- create temp table
CREATE TABLE #TempFundHoldings (
	[Name] [nvarchar](200) NULL,
	[Ticker] [nvarchar](10) NULL,
	[CUSIP] [nvarchar](15) NULL,
	[SEDOL] [nvarchar](15) NULL,
	[Weight] [nvarchar](15) NULL,
	[Sector] [nvarchar](200) NULL,
	[Shares] [nvarchar](15) NULL,
	[LocalCurrency] [nvarchar](10) NULL
) ON [PRIMARY];


DECLARE @InsertTempTableSQL NVARCHAR(MAX);
SET @InsertTempTableSQL = 'BULK INSERT #TempFundHoldings FROM ''' + @FullPath + '''
WITH
(
    FIRSTROW = 6,
    FIELDTERMINATOR = ' + ''',''' + ', 
    ROWTERMINATOR = ' + '''\n''' + ',   
    TABLOCK
)';

EXEC (@InsertTempTableSQL)

-- insert temp table into dbo.FundHoldings
INSERT INTO dbo.FundHoldings
SELECT 'SPDR S&P 500 ETF Trust'
	 , 'SPY'
	 , @ValDate
	 , Name
	 , Ticker
	 , CUSIP
	 , SEDOL
	 , CAST(Weight AS DECIMAL(18,6))
	 , CASE WHEN Sector = '-' THEN NULL ELSE Sector END
	 , CAST(Shares AS DECIMAL(18,6))
	 , LocalCurrency
	 , GETDATE()
FROM #TempFundHoldings

END
GO
