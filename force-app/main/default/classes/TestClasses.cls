public with sharing class TestClasses {
    public void stringStaticMethod() {
        //Instance Methods here
        //method 1: String.contains() - Checks if the string contains a specified substring
        String checkContainsFunction = 'This is a very long text in Bob Place';
        Boolean isContainBob = checkContainsFunction.contains('Bob');
        system.debug('Find Bob in the text? ' + isContainBob );

        //method 2: String.replace() - Replaces all occurrences of a substring with a new substring
        String misspeltName = 'My name is Bob Jerry but I married recently and have a name change';
        String replaceName = misspeltName.replace('Bob', 'Mr Benny');
        system.debug('My new name is ' + replaceName );

        // method 3: String.toUpperCase() - Converts the string to uppercase
        String myfullName = 'bob jerry';
        String upperCaseName = myfullName.toUpperCase();
        system.debug('My name is ' + upperCaseName );

        //method 4: String.substring() - Returns a substring from the string based on start and end index
        String myName = 'With The Force Naija';
        String startIndex = myName.substring(15, 20);
        system.debug('The Name is  ' + startIndex );

        //Method 5 String.length() - Returns the number of characters in the string
        String fullName = 'Jenny Jenkins';
        Integer nameString = fullName.length();
        system.debug('The number of the characters is ' + nameString );
        
    }

    public static void stringInstanceMethod(){
        //call static methods here
        //method 1: convert integer to string
        String convertIntegerToString = String.valueOf(123); 
        system.debug('The converted integer is ' + convertIntegerToString);

        //method 2: check if a string is blank
        String blankCheck = '';
        Boolean checkToDo = String.isBlank(blankCheck);
        System.debug('Is the string blank ' + checkToDo);

        //method 3: String.format() - Returns a formatted string using arguments and placeholders.

        List<Object> stringFormatargs = new List<Object>{'World'};
        String stringFormat = String.format('Hello, {0}', stringFormatargs);
        System.debug(stringFormat);

        //method 4: String.join() - Joins elements of a list into a string with a specified separator
        List<String> stringToJoin = new List<String>{'Hello', 'Rachel', 'World'};
        String stringJoin = String.join(stringToJoin, ':');
        System.debug(stringJoin);

        //method 5: String.escapeSingleQuotes() - Escapes single quotes in a string for use in SOQL or SOSL queries.
        String escapeSingleQuotes = 'Welcome to Bob\'s place';
        String escapeSingleQuotesOutput = String.escapeSingleQuotes(escapeSingleQuotes);
        System.debug('The string with quotes ' + escapeSingleQuotesOutput);
    }

    public void dateTimeStaticMethod(){
        //Instance Methods
        //method 1: Datetime.addDays() - Adds a specified number of days to a Datetime object.
        DateTime myCurrentDate = Datetime.now();
        Datetime newDate = myCurrentDate.addDays(7);
        system.debug('The Date to finish the course is ' + newDate);

        //method 2: Datetime.format() - Formats the Datetime object into a string using the default format of the current user's locale.
        Datetime userDateToFormat = Datetime.newInstance(2024, 10, 23, 02, 15, 45);
        String formattedDate = userDateToFormat.format();
        system.debug('The newly formatted date is ' + formattedDate);

        //Method 3: Datetime.year() - Returns the year portion of the Datetime object
        Datetime currentUserDate = Datetime.now().addYears(3);
        Integer yearOfDate = currentUserDate.year();
        system.debug('The year of the date is ' + yearOfDate);

        //method 4: Datetime.hour() - Returns the hour portion of the Datetime object in GMT
        Integer hourOfDate = currentUserDate.hourGmt();
        System.debug('The hour in GMT is ' + hourOfDate);

        //Method 5: Datetime.getTime() - Returns the number of milliseconds since the Unix epoch (January 1, 1970, 00:00:00 GMT) for the Datetime object.
        Long timeInMilliseconds = currentUserDate.getTime();
        System.debug('The time in milliseconds is ' + timeInMilliseconds);
    }

    public static void dateTimeInstanceMethod(){
        //Static Methods
        //method 1: Datetime.newInstance() - Creates a new Datetime object from specified year, month, day, hour, minute, and second.
        Datetime timeOfAssignment = Datetime.newInstance(2024, 10, 23, 15, 51, 18);
        system.debug('The time of Assignment is '+ timeOfAssignment);

        //Method 2: Datetime.now() - Returns the current Datetime value in the current user's time zone
        Datetime currentTime = Datetime.now();
        system.debug('The current time is ' + currentTime);

        //method 3: Datetime.newInstanceGmt() - Creates a new Datetime object in GMT
        Datetime dateTimeInGMT = Datetime.newInstanceGmt(2024, 10, 23, 12, 38, 45);
        system.debug('The time instance in GMT is ' + dateTimeInGMT);

        //method 4: Datetime.valueOf() - Converts a string into a Datetime object
        String dateString = '2024/10/23 15:08:52';
        Datetime dateStringInDatetime = Datetime.valueOf(dateString);
        system.debug('The date string is ' + dateStringInDatetime);

        //Method 5: Datetime.valueOfGmt() - Converts a string representing a GMT Datetime into a Datetime object.
        String dateStringinGMT = '2024-10-23 15:08:52';
        Datetime dateStringInDatetimeGMT = Datetime.valueOf(dateStringinGMT);
        system.debug('The date string is ' + dateStringInDatetimeGMT);
        
    }
}