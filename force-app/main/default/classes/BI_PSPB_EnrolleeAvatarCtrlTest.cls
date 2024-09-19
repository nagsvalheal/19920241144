@IsTest
/**
 * @description       : This is a BI_PSPB_EnrolleeAvatarCtrlTest test class designed to test the functionality of the BI_PSPB_EnrolleeAvatarCtrl class,
 * History:
 * Version  Author      Date            Detail          Description
 * 1.0      Ashif     10-Jul-2024     Created         Initial development.
 */
public class BI_PSPB_EnrolleeAvatarCtrlTest {
	@IsTest
	static void testUpdateEnrolleeAvatar() {
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
			Username = System.now().millisecond() + 'enrollee@avatar.com',
			Alias = 'avat',
			Email = 'avatar.enrol@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'caroline',
			LastName = 'forbes',
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
			Account portalAccount1 = new Account(
				FirstName = 'Testenrol',
				LastName = 'avatar',
				PersonEmail = 'avataruser@test.com',
				OwnerId = portalAccountOwner1.Id,
				RecordTypeId = personAccountRecordType.Id
			);

			insert portalAccount1;

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
				WHERE AccountId = :portalAccount1.Id
				LIMIT 1
			];
			User user1 = new User(
				Username = System.now().millisecond() + 'test12345@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'avtest',
				Email = 'avataruser@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'avatar',
				FirstName = 'Testenrol',
				CommunityNickname = 'avtusers',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;

			CareProgram cpvalue = new CareProgram(
				Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
				StartDate = Date.today()
			);
			insert cpvalue;
			// Test data setup
			CareProgramEnrollee enrollee = new CareProgramEnrollee();
			enrollee.BI_PSP_AvatarUrl__c = 'initialAvatarUrl';
			enrollee.BI_PSP_Loginattempt__c = 0;
			enrollee.AccountId = portalAccount1.Id;
			enrollee.CareProgramId = cpvalue.id;
			enrollee.Name = 'metin';
			insert enrollee;

			// Define new avatar URL
			String newAvatarUrl = 'https://example.com/newAvatar.png';

			// Call the method to test
			Test.startTest();
			BI_PSPB_EnrolleeAvatarCtrl.updateEnrolleeAvatar(
				enrollee.Id,
				newAvatarUrl
			);
			try {
				BI_PSPB_EnrolleeAvatarCtrl.updateEnrolleeAvatar('', '');
			} catch (Exception e) {
				Assert.areEqual(
					'Script-thrown exception',
					e.getMessage(),
					'Unexpected exception message.'
				);
			}
			Test.stopTest();

			// Retrieve the updated record
			enrollee = [
				SELECT
					Id,
					BI_PSP_AvatarUrl__c,
					BI_PSP_Loginattempt__c,
					BI_PSPB_FirstLoginDate__c
				FROM CareProgramEnrollee
				WHERE Id = :enrollee.Id
			];

			// Verify that the avatar URL was updated
			Assert.areEqual(
				newAvatarUrl,
				enrollee.BI_PSP_AvatarUrl__c,
				'Avatar URL should be updated.'
			);

			// Verify that login attempt value was set
			Assert.areEqual(
				1,
				enrollee.BI_PSP_Loginattempt__c,
				'Login attempt should be set to 1.'
			);

			// Verify that the first login date was set
			Assert.areEqual(
				Date.today(),
				enrollee.BI_PSPB_FirstLoginDate__c,
				'First login date should be set to today.'
			);
		}

	}
}