@IsTest
public class BatchGetLogsTest {
    private static Integer batchSize;
    private static final Integer MAX_LOG_LENGTH = 12000000;
    
    @IsTest
    public static void testBatchCallout() {
        List<ApexLog> logs = [
            SELECT Id, LogUserId, StartTime, LogLength 
            FROM ApexLog 
            WHERE LogLength < :MAX_LOG_LENGTH
            ORDER BY StartTime DESC
        ];
        System.assert(logs.size() > 0, 'Log size should be greater than 0. Try run test again.');
        batchSize = logs.size() +1; // Making sure only one batch is created for execution due to Apex test limitation
        BatchGetLogs.searchLogDAOService = new MockSearchLogDAO();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout());
        System.debug('The Batch size: '+batchSize);
        BatchGetLogs bgl = new BatchGetLogs('test');
        Database.executeBatch(bgl, batchSize);
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