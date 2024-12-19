public with sharing class TableConverter {
    public static String convertHtmlTableToTab(String htmlTable){
        if (String.isBlank(htmlTable)){
            return '';
        }

        // Regular expressions to extract rows and cells
        Pattern rowPattern = Pattern.compile('<tr[^>]*>(.*?)</tr>');
        Pattern cellPattern = Pattern.compile('<t[dh][^>]*>(.*?)</t[dh]>');

        Matcher rowMatcher = rowPattern.matcher(htmlTable);
        String tabSeparatedData = '';

        while (rowMatcher.find()){
            String row = rowMatcher.group(1); // Extract row content
            Matcher cellMatcher = cellPattern.matcher(row);

            List<String> cells = new List<String>();
            while (cellMatcher.find()){
                String cellContent = cellMatcher.group(1).trim(); // Extract and trim cell content
                // Remove any additional HTML tags inside the cell content
                cellContent = cellContent.replaceAll('<[^>]+>', '');
                cells.add(cellContent);
            }

            // Join the cell values with tabs and append to the result
            tabSeparatedData += String.join(cells, '\t') + '\n';
        }

        return tabSeparatedData.trim(); // Trim any trailing newlines
    }

    public static String convertTabToAscii(String tabTable){
        if (String.isBlank(tabTable)){
            return '';
        }

        // Split the input into rows
        List<String> rows = tabTable.split('\n');

        // Split rows into cells and calculate the max column widths
        List<List<String>> tableData = new List<List<String>>();
        List<Integer> columnWidths = new List<Integer>();

        for (String row : rows){
            List<String> cells = row.split('\t');
            tableData.add(cells);

            for (Integer i = 0; i < cells.size(); i++){
                String cell = cells[i];
                // Ensure columnWidths list is large enough
                if (columnWidths.size() <= i){
                    columnWidths.add(0);
                }
                // Update max width for this column
                columnWidths[i] = System.Math.max(columnWidths[i], cell.length());
            }
        }

        // Build the ASCII table
        String asciiTable = '';

        // Create the horizontal border
        String border = '+';
        for (Integer width : columnWidths){
            border += '-'.repeat(width + 2) + '+';
        }
        String horizontalBorder = border;

        // Append the table rows
        for (Integer i = 0; i < tableData.size(); i++){
            if (i == 0){
                // Add the top border
                asciiTable += horizontalBorder + '\n';
            }
            // Add the row content
            asciiTable += constructRow(tableData[i], columnWidths, ' ¦ ');
            // Add the header separator or bottom border
            if (i == 0 || i == tableData.size() - 1){
                asciiTable += horizontalBorder + '\n';
            }
        }

        return asciiTable.toString();
    }

    // Helper method to construct a row
    static String constructRow(List<String> row, List<Integer> widths, String separator){
        List<String> paddedCells = new List<String>();
        for (Integer i = 0; i < row.size(); i++){
            String cell = row[i];
            paddedCells.add(cell.rightPad(widths[i])); // Pad cell to match column width
        }
        return separator + String.join(paddedCells, separator) + separator + '\n';
    }

    public static String prepareForSlack(String input) {
        String output = '';
        String processedInput = input.unescapeHtml4();
    
        System.debug(LoggingLevel.FINEST, 'processedInput >>> ' + processedInput);
    
        // This ensures a newline is added after each of the specified closing tags.
        processedInput = processedInput.replaceAll('</(p|table|div|span)>(\\s*)', '</$1>\n');

    
        if (processedInput.contains('\n')) {
            List<String> lines = processedInput.split('\n');
    
            for (String line : lines) {
                String result = line;

                System.debug(LoggingLevel.FINEST, 'line >>> ' + line);
    
                // Process tables separately and convert to Slack-friendly format
                if (line.contains('<table')) {
                    result = '```' + TableConverter.convertTabToAscii(TableConverter.convertHtmlTableToTab(line)) + '```';
                }
    
                output += result + '\n';
            }
        }
    
        // Remove all remaining HTML tags
        output = output.replaceAll('<[^>]*>', '');
    
        // Log debug information
        System.debug(LoggingLevel.FINEST, 'Escaped Unicode:\n' + output.escapeUnicode());
        System.debug(LoggingLevel.DEBUG, 'Final Output:\n' + output);
    
        return output;
    }
    
}