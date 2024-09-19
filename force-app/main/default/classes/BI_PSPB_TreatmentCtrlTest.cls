/**
*@description The BI_PSPB_TreatmentCtrlTest class contains a series of test methods designed to validate 
*the functionality of the createRemainderRecord method in the BI_PSPB_TreatmentCtrl Apex class. This test class covers a range of scenarios, 
*including typical usage, edge cases, and error conditions to ensure robust code behavior. 
*/
@isTest
public class BI_PSPB_TreatmentCtrlTest {
private static User testUserPatient;
    private static Account testAccount;
    private static CareProgramEnrollee testCareProgramEnrolle;
    
    static {
        initializeTestData();
    }
    
    private static void initializeTestData() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Bruce',
            LastName = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        insert portalAccountOwner1;

        System.runAs(portalAccountOwner1) {
            // Retrieve Record Type ID for Person Accounts
            RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
            
            // Create Person Account
            testAccount = new Account(
                FirstName = 'Test',
                LastName = 'Account',
                PersonEmail = 'test12345@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );
            insert testAccount;

            // Create user associated with Person Account
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
            Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
            testUserPatient = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Account',
                FirstName = 'Test',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUserPatient;
        }
    }

    @isTest
    static void testCreateRemainderRecord() {
        System.runAs(testUserPatient) {
            CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program', StartDate = Date.today());
            insert testCareProgram;
            
            testCareProgramEnrolle = new CareProgramEnrollee(
                AccountId = testAccount.Id,
                CareProgramId = testCareProgram.Id,
                Name = 'Test Enrollee'
            );
            insert testCareProgramEnrolle;

            Date selectedDate = Date.today();
            List<String> selectedReminders = new List<String>{ '14', '10', '7' };
            List<String> selectedTreatment = new List<String>{ '3', '1' };

            Test.startTest();
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            Test.stopTest();

            List<BI_PSPB_Treatment_Reminder__c> reminders = [
                SELECT Id, BI_PSPB_Date_of_Treatment__c, BI_PSPB_Reminder_Date__c, BI_PSPB_Status__c, BI_PSPB_Subject__c
                FROM BI_PSPB_Treatment_Reminder__c
                WHERE BI_PSPB_Care_Program_Enrollee__c = :testCareProgramEnrolle.Id
            ];

            System.assertNotEquals(null, reminders, 'No treatment reminder records were created.');
            System.assertEquals(6, reminders.size(), 'Expected 6 treatment reminder records to be created, but found ' + reminders.size());
            for (BI_PSPB_Treatment_Reminder__c reminder : reminders) {
                System.assertEquals(selectedDate, reminder.BI_PSPB_Date_of_Treatment__c, 'Date of treatment mismatch');
                System.assertEquals('Active', reminder.BI_PSPB_Status__c, 'Reminder status mismatch');
                System.assertNotEquals(null, reminder.BI_PSPB_Subject__c, 'Reminder subject should not be null');
            }
        }
    }

    @isTest
    static void testCreateRemainderRecordNoReminders() {
        setupTestCareProgramAndEnrollee();

        Date selectedDate = Date.today();
        List<String> selectedReminders = new List<String>();  // Empty list
        List<String> selectedTreatment = new List<String>{ '3', '1' };

        Test.startTest();
        try {
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            System.assert(false, 'Expected an exception but did not get one.');
        } catch (Exception e) {
            System.assertEquals('Script-thrown exception', e.getMessage(), 'Unexpected exception message');
        }
        Test.stopTest();

        List<BI_PSPB_Treatment_Reminder__c> reminders = [
            SELECT Id
            FROM BI_PSPB_Treatment_Reminder__c
            WHERE BI_PSPB_Care_Program_Enrollee__c = :testCareProgramEnrolle.Id
        ];

        System.assertEquals(0, reminders.size(), 'Expected 0 treatment reminder records to be created, but found ' + reminders.size());
    }

    @isTest
    static void testCreateRemainderRecordNullDate() {
        setupTestCareProgramAndEnrollee();

        Date selectedDate = null;
        List<String> selectedReminders = new List<String>{ '14', '10', '7' };
        List<String> selectedTreatment = new List<String>{ '3', '1' };

        Test.startTest();
        try {
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            System.assert(false, 'Expected an exception but did not get one.');
        } catch (Exception e) {
            System.assert(e != null, 'Expected exception for null date');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateRemainderRecordEmptyLists() {
        setupTestCareProgramAndEnrollee();

        Date selectedDate = Date.today();
        List<String> selectedReminders = new List<String>();
        List<String> selectedTreatment = new List<String>();

        Test.startTest();
        try {
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            System.assert(false, 'Expected an exception but did not get one.');
        } catch (Exception e) {
            System.assert(e != null, 'Expected exception for empty lists');
        }
        Test.stopTest();
    }

    @isTest
    static void testCreateRemainderRecordNullLists() {
        setupTestCareProgramAndEnrollee();

        Date selectedDate = Date.today();
        List<String> selectedReminders = null;
        List<String> selectedTreatment = null;

        Test.startTest();
        try {
            BI_PSPB_TreatmentCtrl.createRemainderRecord(selectedDate, selectedReminders, selectedTreatment);
            System.assert(false, 'Expected an exception but did not get one.');
        } catch (Exception e) {
            System.assert(e != null, 'Expected exception for null lists');
        }
        Test.stopTest();
    }

    private static void setupTestCareProgramAndEnrollee() {
        System.runAs(testUserPatient) {
            if (testCareProgramEnrolle == null) {
                CareProgram testCareProgram = new CareProgram(Name = 'Test Care Program', StartDate = Date.today());
                insert testCareProgram;
                
                testCareProgramEnrolle = new CareProgramEnrollee(
                    AccountId = testAccount.Id,
                    CareProgramId = testCareProgram.Id,
                    Name = 'Test Enrollee'
                );
                insert testCareProgramEnrolle;
            }
        }
    }
}