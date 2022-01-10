@IsTest
public class BatchGetLogsTest {

    @IsTest
    public static void testBatchCallout() {
        BatchGetLogs.searchLogDAOService = new MockSearchLogDAO();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        BatchGetLogs bgl = new BatchGetLogs('test');
        Database.executeBatch(bgl, 50);
        Test.stopTest();
        System.assert(BatchGetLogs.logSize > 0, 'Resulting list should not be empty.');
    }
    
    public class MockSearchLogDAO extends MockSearchLogDAOService {
        public override List<ApexLog> getLogs() {
            List<ApexLog> logs = new List<ApexLog>();
            Id logId = TestUtility.getFakeId(ApexLog.SObjectType);
            ApexLog testLog = (ApexLog) JSON.deserialize(
                '{"Id":"'+logId+'"}', 
                ApexLog.class);
            logs.add(testLog);
            return logs;
        }
    }
}