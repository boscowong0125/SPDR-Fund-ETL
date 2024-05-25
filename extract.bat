@echo off

rem extract all files to staging folder

cd C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data
mkdir staging_holdings
cd .\staging_holdings
wget https://www.ssga.com/us/en/individual/etfs/library-content/products/fund-data/etfs/us/us_spdrallholdings.zip
tar -xf us_spdrallholdings.zip
del us_spdrallholdings.zip

rem ETL in staging folder

cd C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data
pwsh.exe -File "convert_csv.ps1"

rem archive after finishing ETL

rename "C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data\staging_holdings" "%date:~-4,4%%date:~-10,2%%date:~7,2%_holdings"
move ".\%date:~-4,4%%date:~-10,2%%date:~7,2%_holdings" ".\Archive"
