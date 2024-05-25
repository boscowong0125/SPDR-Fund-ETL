USE [PersonalFinance]
GO

/****** Object:  StoredProcedure [dbo].[Load_FundHoldings]    Script Date: 5/23/2024 7:39:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bosco Wong
-- Create date:		2024-05-23
-- Description:		Create

-- exec dbo.Load_FundHoldings
-- =============================================
CREATE PROCEDURE [dbo].[Load_FundHoldings]

AS
BEGIN
	-- drop temp table if exist
IF OBJECT_ID('tempdb.dbo.#TempFundHoldings', 'U') IS NOT NULL
  DROP TABLE #TempFundHoldings; 

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
) ON [PRIMARY]

-- insert csv into temp table
BULK INSERT #TempFundHoldings
FROM 'C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data\holdings-daily-us-en-spy.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)

-- insert temp table into dbo.FundHoldings
INSERT INTO dbo.FundHoldings
SELECT 'SPDR S&P 500 ETF Trust'
	 , 'SPY'
	 , DATEADD(d, -1, CAST(GETDATE() AS DATE))
	 , Name
	 , Ticker
	 , CUSIP
	 , SEDOL
	 , CAST(Weight AS DECIMAL(18,6))
	 , Sector
	 , CAST(Shares AS DECIMAL(18,6))
	 , LocalCurrency
FROM #TempFundHoldings

END
GO
