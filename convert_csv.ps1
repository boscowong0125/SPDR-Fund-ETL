# path
$ExcelFilePath = "C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data\staging_holdings\holdings-daily-us-en-spy.xlsx"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
 
# Find valuation date and last row of the table range
$workbook = $excel.Workbooks.Open($ExcelFilePath)
$sourceSheet = $workbook.Sheets.Item(1)
$dateCell = $sourceSheet.Range("B3").Value().substring(6)
$valDate = [DateTime]::ParseExact($dateCell, "dd-MMM-yyyy", $null).ToString("yyyy-MM-dd")
$lastRow = $sourceSheet.Cells($sourceSheet.Rows.Count, 8).End(-4162).Row  # -4162 corresponds to xlUp

$workbook.Close($false)  # Close the workbook without saving changes
$excel.Quit()

# Extract table into CSV
$csvFilePath = "C:\Users\bosco\OneDrive\Desktop\Projects\Data Projects\SPDR Fund Data\staging_holdings\holdings-daily-us-en-spy_" + $valDate + ".csv"
$data = Import-Excel -Path $excelFilePath -StartRow 5 -EndRow $lastRow -StartColumn 1 -EndColumn 8
$data | Export-Csv -Path $csvFilePath -NoTypeInformation -UseQuotes never
