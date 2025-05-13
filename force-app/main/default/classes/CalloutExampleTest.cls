@IsTest
private class CalloutExampleTest {

    @IsTest
    static void testGetMessage() {
        Test.setMock(HttpCalloutMock.class, new CalloutMock());

        Test.startTest();
        String result = CalloutExample.getMessage();
        Test.stopTest();

        System.assertEquals('{"message": "Mocked response ✅"}', result);
    }
}
