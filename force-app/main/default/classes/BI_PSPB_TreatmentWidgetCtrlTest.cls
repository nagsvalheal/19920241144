@isTest
public class BI_PSPB_TreatmentWidgetCtrlTest {

    private static Account testAccount;
    private static User testUserPatient;
    private static CareProgramEnrollee testCareProgramEnrolle;

    static {
        initializeTestData();
    }

    private static void initializeTestData() {
        UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
        Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];

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
            // Retrieve the Record Type ID for Person Accounts
            RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];

            // Create Person Account
            testAccount = new Account(
                FirstName = 'Test',
                LastName = 'Account',
                PersonEmail = 'treatment03@test.com',
                OwnerId = portalAccountOwner1.Id,
                RecordTypeId = personAccountRecordType.Id
            );
            insert testAccount;

            // Create user associated with Person Account
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
            Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :testAccount.Id LIMIT 1];
            testUserPatient = new User(
                Username = System.now().millisecond() + 'treatment03@test.com',
                ContactId = personContact.Id,
                ProfileId = portalProfile.Id,
                Alias = 'tert',
                Email = 'treatment03@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Account',
                FirstName = 'Test',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            insert testUserPatient;

            // Creating mock BI_SFCOE_LOG_App_Settings__c record
            BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
                Name = 'PSPB',
                BI_SFCOE_LOG_Application__c = 'Spevigo'
            );
            insert settings;

            // Creating Care Program and Enrollee
            CareProgram testCareProgram = new CareProgram(
                Name = 'Test Care Program',
                StartDate = Date.today()
            );
            insert testCareProgram;

            testCareProgramEnrolle = new CareProgramEnrollee(
                AccountId = testAccount.Id,
                CareProgramId = testCareProgram.Id,
                Name = 'Test Enrollee'
            );
            insert testCareProgramEnrolle;

            // Create a BI_PSPB_Treatment_Reminder__c record
            BI_PSPB_Treatment_Reminder__c reminder = new BI_PSPB_Treatment_Reminder__c(
                BI_PSPB_Care_Program_Enrollee__c = testCareProgramEnrolle.Id,
                BI_PSPB_Subject__c = 'Test Reminder',
                BI_PSPB_Date_of_Treatment__c = Date.today().addDays(1),
                BI_PSPB_Status__c = BI_PSPB_TreatmentConstantsClassCtrl.actionTypeActive,
                BI_PSPB_Reminder_Date__c = Date.today().addDays(1)
            );
            insert reminder;
        }
    }


    @isTest
    static void testPrepopulatedValues() {
        System.runAs(testUserPatient) {
            Test.startTest();
            Map<String, Object> prepopulatedValues = BI_PSPB_TreatmentWidgetCtrl.prepopulatedValues();
            
            Test.stopTest();

            System.assertNotEquals(null, prepopulatedValues, 'The prepopulated values map should not be null.');
            System.assertEquals(null, prepopulatedValues.get(System.Label.BI_PSPB_SelectedCheckBox), 'There should be no selected checkboxes value.');
        }
    }

    @isTest
    static void testGetTasksWithDateOfTreatmentNoReminders() {
        System.runAs(testUserPatient) {
            delete [SELECT Id FROM BI_PSPB_Treatment_Reminder__c];
            Test.startTest();
            List<BI_PSPB_Treatment_Reminder__c> reminders = BI_PSPB_TreatmentWidgetCtrl.getTasksWithDateOfTreatment();
            Test.stopTest();

            System.assertEquals(0, reminders.size(), 'The reminders list should be empty.');
        }
    }


     @isTest
	static void testGetTasksWithDateOfTreatmentInvalidId() {
		 System.runAs(testUserPatient) {
		try {
			Test.startTest();
			// Call the method
		   BI_PSPB_TreatmentWidgetCtrl.getTasksWithDateOfTreatment();
			Test.stopTest();
		} catch (Exception ex) {
			// Assert if there's an exception
			System.assertEquals(
				'Script-thrown exception',
				ex.getMessage(),
				'An unexpected exception occurred: ' + ex.getMessage()
			);
		}
	}
	}
}