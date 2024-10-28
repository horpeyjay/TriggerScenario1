public with sharing class sheet1API {
    public static HttpResponse dataFromApi() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://horpeyjay.github.io/csvToJson/FFH.json');
        request.setMethod('GET');

        Http http = new Http();
        HttpResponse response;

        try {
            response = http.send(request);
            if (response.getStatusCode() != 200) {
                System.debug('Error: Unable to reach the endpoint');
                return response;
            }
        } catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
            return null;
        }

        // Parse the response body
        String responseBody = response.getBody();
        List<Object> frequentFlierRaw = (List<Object>) JSON.deserializeUntyped(responseBody);
        List<FrequentFlierObject> ffObjects = new List<FrequentFlierObject>();

        for (Object ob : frequentFlierRaw) {
            Map<String, Object> ff = (Map<String, Object>) ob;
            FrequentFlierObject ffObject = new FrequentFlierObject();

            ffObject.recordDate = (String) ff.get('Record Creation Date');
            ffObject.joinDate = (String) ff.get('Join Date');
            ffObject.flierNumber = (String) ff.get('Frequent Flier Number');
            ffObject.firstName = (String) ff.get('First Name');
            ffObject.lastName = (String) ff.get('Last Name');
            ffObject.inquiryType = (String) ff.get('Inquiry Type');
            ffObject.flightNumber = (String) ff.get('Most Recent Flight #');
            ffObject.departureAirport = (String) ff.get('Departure Airport');
            ffObject.arrivalAirport = (String) ff.get('Arrival Airport');
            ffObject.useLounge = (String) ff.get('Lounge Used?');
            ffObject.additionalSnack = (String) ff.get('Additional Snack?');
            ffObject.plannedSnack = (String) ff.get('Planned Snack?');
            ffObject.checkedBags = (String) ff.get('# of Included Checked Bags');
            ffObject.totalBags = (String) ff.get('Total # of Checked Bags');
            ffObject.flightDelayed = (String) ff.get('Flight Delayed?');

            ffObjects.add(ffObject);
        }

        List<Initial_Fliers__c> initFliers = new List<Initial_Fliers__c>();
        for (FrequentFlierObject ff : ffObjects) {
            Initial_Fliers__c initFlier = new Initial_Fliers__c();
            initFlier.Record_Creation__c = Date.valueOf(ff.recordDate);
            initFlier.Join_Date__c = Date.valueOf(ff.joinDate);
            initFlier.Most_Recent_Flight__c = ff.flightNumber;
            initFlier.First_Name__c = ff.firstName;
            initFlier.Last_Name__c = ff.lastName;
            initFlier.Inquiry_Type__c = ff.inquiryType;
            initFlier.Frequent_Flier_Number__c = ff.flierNumber;
            initFlier.Departing_Airport__c = ff.departureAirport;
            initFlier.Arrival_Airport__c = ff.arrivalAirport;
            initFlier.Lounge_used__c = Boolean.valueOf(ff.useLounge);
            initFlier.Additional_Snack__c = Boolean.valueOf(ff.additionalSnack);
            initFlier.Planned_Snack__c = Boolean.valueOf(ff.plannedSnack);
            initFlier.of_Included_Checked_Bags__c = Integer.valueOf(ff.checkedBags);
            initFlier.Total_of_Checked_Bags__c = Integer.valueOf(ff.totalBags);
            initFlier.Flight_Delayed__c = Boolean.valueOf(ff.flightDelayed);

            initFliers.add(initFlier);
        }

        if (!initFliers.isEmpty()) {
            insert initFliers;
        }

        return response;
    }

    public class FrequentFlierObject {
        public String recordDate;
        public String joinDate;
        public String flierNumber;
        public String firstName;
        public String lastName;
        public String inquiryType;
        public String flightNumber;
        public String departureAirport;
        public String arrivalAirport;
        public String useLounge;
        public String additionalSnack;
        public String plannedSnack;
        public String checkedBags;
        public String totalBags;
        public String flightDelayed;
    }
}
