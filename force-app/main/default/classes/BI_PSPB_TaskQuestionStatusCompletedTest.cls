@IsTest
/**
* @description This class contains test methods to verify the behaviour of
updating questions status to completed.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_TaskQuestionStatusCompletedTest {
	public static User testUserPatient;
	@IsTest
	static void testMarkTaskQuestionCompleted() {
		UserRole portalRole = [
			SELECT Id
			FROM UserRole
			WHERE PortalType = 'None'
			LIMIT 1
		];

		Profile profile1 = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
		];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'brucetask.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucetask',
			LastName = 'Waynetask',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;
		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account account = new Account(
				FirstName = 'Brucetask',
				LastName = 'Waynetask',
				PersonEmail = 'brucetask.wayne@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			User user1 = new User(
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

			insert user1;
			CareProgram testCareProgram = new CareProgram(
				Name = 'Test Care Program',
				StartDate = Date.today()
			);
			insert testCareProgram;

			CareProgramEnrollee testCareProgramEnrolle = new CareProgramEnrollee(
				AccountId = account.Id,
				CareProgramId = testCareProgram.Id,
				BI_PSP_AvatarUrl__c = '/Branded/resource/1702474530000/BI_PSPB_AsianWoman_ElderAdult',
				Name = 'TestPatientFeed PatientLastName'
			);
			insert testCareProgramEnrolle;

			Test.startTest();
			List<Task> updatedTasks = BI_PSPB_TaskQuestionStatusCompleted.markTaskQuestionCompleted();
			Test.stopTest();
			for (Task t : updatedTasks) {
				Assert.areEqual(
					'Completed',
					t.Status,
					'Task status should be updated to Completed'
				);
				Assert.areEqual(
					testUserPatient.Id,
					t.OwnerId,
					'Task owner should be the test user'
				);
				Assert.areEqual(
					testCareProgramEnrolle.AccountId,
					t.WhoId,
					'Task should be associated with the correct account'
				);
			}
		}
	}
	@IsTest
	static void testMarkTaskQuestionCompletedNoEnrolleeId() {
		UserRole portalRole = [
			SELECT Id
			FROM UserRole
			WHERE PortalType = 'None'
			LIMIT 1
		];

		Profile profile1 = [
			SELECT Id
			FROM Profile
			WHERE Name = 'System Administrator'
		];

		User portalAccountOwner1 = new User(
			UserRoleId = portalRole.Id,
			ProfileId = profile1.Id,
			Username = System.now().millisecond() + 'test2@test.com',
			Alias = 'batman',
			Email = 'bruce.wayne1@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Bruce1',
			LastName = 'Wayne1',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);

		insert portalAccountOwner1;
		System.runAs(portalAccountOwner1) {
			// Retrieve the Record Type ID for Person Accounts
			RecordType personAccountRecordType = [
				SELECT Id
				FROM RecordType
				WHERE SObjectType = 'Account' AND Name = 'Person Account'
				LIMIT 1
			];

			// Create Person Account
			Account account = new Account(
				FirstName = 'Bruce1',
				LastName = 'Wayne1',
				PersonEmail = 'bruce.wayne1@wayneenterprises.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert account;

			// Create user associated with Person Account
			Profile portalProfile = [
				SELECT Id
				FROM Profile
				WHERE Name = 'BI_PSP_Patient Profile'
				LIMIT 1
			];
			Contact personContact = [
				SELECT Id
				FROM Contact
				WHERE AccountId = :account.Id
				LIMIT 1
			];
			User user1 = new User(
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

			insert user1;
			try {
				Test.startTest();
				BI_PSPB_TaskQuestionStatusCompleted.markTaskQuestionCompleted();
				Test.stopTest();
			} catch (Exception e) {
				/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Method thrown exception'
				);
			}
		}
	}
	@IsTest
	static void testMarkTaskQuestionCompletedWithoutUser() {
		try {
			Test.startTest();
			BI_PSPB_TaskQuestionStatusCompleted.markTaskQuestionCompleted();
			Test.stopTest();
		} catch (Exception e) {
			/*  When executing the negative scenario, if the flow enters 
            the catch block and throws an exception, assertions 
            are made solely for validating the exception occurrence.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}