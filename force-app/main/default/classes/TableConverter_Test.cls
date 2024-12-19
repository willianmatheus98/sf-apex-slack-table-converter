@isTest
public with sharing class TableConverter_Test {
    @isTest
    static void testConvertHtmlTableToTabSimpleTable() {
        // Test the convertHtmlTableToTab method with a simple table
        String htmlTable = '<table><tr><th>Name</th><th>Value</th></tr><tr><td>First</td><td>One</td></tr><tr><td>Second</td><td>Two</td></tr></table>';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);

        String expected = 'Name\tValue\nFirst\tOne\nSecond\tTwo';
        System.debug(LoggingLevel.DEBUG, 'tabSeparatedData >>> ' + tabSeparatedData);
        System.debug(LoggingLevel.DEBUG, 'expected >>> ' + expected);

        Assert.areEqual(expected, tabSeparatedData, 'Data should be tab separated');
    }

    @isTest
    static void testConvertHtmlTableToAsciiSimpleTable() {
        // Test the convertHtmlTableToTab method with a simple table
        String htmlTable = '<table><tr><th>Name</th><th>Value</th></tr><tr><td>First</td><td>One</td></tr><tr><td>Second</td><td>Two</td></tr></table>';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);
        String asciiData = TableConverter.convertTabToAscii(tabSeparatedData);

        String expected = '+--------+-------+\n ¦ Name   ¦ Value ¦ \n+--------+-------+\n ¦ First  ¦ One   ¦ \n ¦ Second ¦ Two   ¦ \n+--------+-------+\n';
        System.debug(LoggingLevel.DEBUG, 'asciiData >>> ' + asciiData);
        System.debug(LoggingLevel.DEBUG, 'expected >>> ' + expected);

        Assert.areEqual(expected, asciiData, 'Data should be ascii printed');
    }

    @isTest
    static void testPrepareForSlackSimpleTable() {
        // Test the convertHtmlTableToTab method with a simple table
        String htmlTable = '<table><tr><th>Name</th><th>Value</th></tr><tr><td>First</td><td>One</td></tr><tr><td>Second</td><td>Two</td></tr></table>';
        String slackMessage = TableConverter.prepareForSlack(htmlTable);

        String expected = '```+--------+-------+\n ¦ Name   ¦ Value ¦ \n+--------+-------+\n ¦ First  ¦ One   ¦ \n ¦ Second ¦ Two   ¦ \n+--------+-------+\n```\n';
        System.debug(LoggingLevel.DEBUG, 'slackMessage >>> ' + slackMessage);
        System.debug(LoggingLevel.DEBUG, 'expected >>> ' + expected);

        Assert.areEqual(expected, slackMessage, 'Data should be slack code format');
    }

    @isTest
    static void testConvertHtmlTableToTabComplexTable() {
        // Test the convertHtmlTableToTab method with a more complex table structure
        String htmlTable = '<table class="foo"><tr class="header"><th>Header 1</th><th>Header 2</th></tr><tr><td>Data 1</td><td>Data 2</td></tr></table>';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);

        String expected = 'Header 1\tHeader 2\nData 1\tData 2';
        System.debug(LoggingLevel.DEBUG, 'tabSeparatedData >>> ' + tabSeparatedData);
        System.debug(LoggingLevel.DEBUG, 'expected >>> ' + expected);

        Assert.areEqual(expected, tabSeparatedData, 'Data should be tab separated');
    }

    @isTest
    static void testConvertHtmlTableToTabTableWithPadding() {
        // Test the convertHtmlTableToTab method with a table containing cells with different padding
        String htmlTable = '<table><tr><td style="padding-left:10px;">Value 1</td><td style="padding-left:20px;">Value 2</td></tr></table>';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);

        String expected = 'Value 1\tValue 2';
        System.debug(LoggingLevel.DEBUG, 'tabSeparatedData >>> ' + tabSeparatedData);
        System.debug(LoggingLevel.DEBUG, 'expected >>> ' + expected);

        Assert.areEqual(expected, tabSeparatedData, 'Data should be tab separated');
    }

    @isTest
    static void testConvertHtmlTableToTabEmptyData() {
        // Test the convertHtmlTableToTab method for blank data
        String htmlTable = '';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);

        Assert.areEqual('', tabSeparatedData, 'Should be blank data');
    }

    @isTest
    static void testConvertHtmlTableToAsciiEmpty() {
        
        String htmlTable = '';
        String tabSeparatedData = TableConverter.convertHtmlTableToTab(htmlTable);
        String asciiData = TableConverter.convertTabToAscii(tabSeparatedData);

        String expected = '';

        Assert.areEqual(expected, asciiData, 'Should be blank data');
    }
}