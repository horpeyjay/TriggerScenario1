@isTest
public with sharing class sheet1APITest {
    @isTest
    static void test_dataFromApi() {


        // Set up mock HTTP response
        String jsonResponse = '[{"Record Creation Date": "2024-02-27", "Join Date": "1988-07-08", "Frequent Flier Number": "7234617746", "First Name": "Debbie", "Last Name": "Spears", "Inquiry Type": "Flight Status", "Most Recent Flight #": "G35206241", "Lounge Used?": "FALSE", "Departing Airport": "HND", "Arrival Airport": "HND", "Planned Snack?": "FALSE", "Additional Snack?": "TRUE", "# of Included Checked Bags": "2", "Total # of Checked Bags": "7", "Flight Delayed?": "TRUE"}]';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(jsonResponse));

        // Call the method
        HttpResponse response = sheet1API.dataFromApi();

        // Verify results
        System.assertEquals(200, response.getStatusCode());

        List<Initial_Fliers__c> insertedRecords = [SELECT Id, First_Name__c FROM Initial_Fliers__c WHERE First_Name__c = 'Debbie'];
        System.assertEquals(1, insertedRecords.size());
        System.assertEquals('Debbie', insertedRecords[0].First_Name__c);
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private String responseBody;
        public MockHttpResponseGenerator(String responseBody) {
            this.responseBody = responseBody;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(responseBody);
            return res;
        }
    }
}