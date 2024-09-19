/**
@description    Test class for the BI_PSPB_supportCaseCreate class.
@author                    Niyas
@Last Modified On       04/23/2024
@Last Modified By         Niyas
*/
@isTest
private class BI_PSPB_CreateSupportCaseCtrlTest {
  /**
   *@description Test method to validate the createCase functionality.
   */
  public static User testUser;
  public static Contact contactForPatient;
  static {
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
			Email = 'brucemess.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess',
			LastName = 'Waynemess',
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
				FirstName = 'Brucemess',
				LastName = 'Waynemess',
				PersonEmail = 'brucemess.wayne@wayneenterprises.com',
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


    BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
      Name = 'PSPB',
      BI_SFCOE_LOG_Application__c = 'Spevigo'
    );
    insert settings;
    CareProgram testCareProgram = new CareProgram(Name = 'dfgh');
    insert testCareProgram;
    CareProgramEnrollee testEnrollee = new CareProgramEnrollee(
      AccountId = account.Id,
      Name = 'dfgh',
      CareProgramId = testCareProgram.Id
    );
    insert testEnrollee;
    Case testCase = new Case(
      AccountId = account.Id,
      BI_PSP_Patient__c = testEnrollee.Id,
      BI_PSP_Type__c = 'Medical Information Enquiry',
      Status = BI_PSPB_SupportCenterConstantsCtrl.draft,
      BI_PSPB_Sub_Type__c = 'Treatment',
      Description = 'Test Description'
    );
    insert testCase;
        }
  }
  /**
   *@description Test method to validate the createCase functionality.
   */
  @isTest
  static void testCreateCase() {
    try {
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
			Username = System.now().millisecond() + 'test22@test.com',
			Alias = 'batman',
			Email = 'brucemess12.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess1',
			LastName = 'Waynemess1',
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
				FirstName = 'Brucemess1',
				LastName = 'Waynemess1',
				PersonEmail = 'brucemess12.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test1245@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test1245@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      /*Account testNewAccount = new Account(
        Name = 'Test Account',
        RecordTypeId = personAccountRecordType.Id
      );*/
      ///insert testNewAccount;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrolleeqq',
        CareProgramId = testCP.Id
      );
      insert cpe;
      /*CareProgramEnrollee cpeo = new CareProgramEnrollee(
        AccountId = testNewAccount.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpeo;*/
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiry';
      supportWrapper.subType = 'Treatment';
      supportWrapper.description = 'description';
      Test.startTest();
     BI_PSPB_CreateSupportCaseCtrl.createCase(
        supportWrapper,
        fileIds
      );
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(supportWrapper, fileIds);
     
      Test.stopTest();
        }
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
  /**
   * @description Test method to verify the behavior of createCase method.
   */
  @isTest
  static void testCreateCaseFailed() {
    try {
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
			Username = System.now().millisecond() + 'test223@test.com',
			Alias = 'batman',
			Email = 'brucemess123.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess13',
			LastName = 'Waynemess13',
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
				FirstName = 'Brucemess13',
				LastName = 'Waynemess13',
				PersonEmail = 'brucemess123.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test12945@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test12945@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      // Call the method to be tested
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiryyyyyy';
      supportWrapper.subType = null;
      supportWrapper.description = 'description';
      // Call the method to be tested
      Test.startTest();
      Id caseId = BI_PSPB_CreateSupportCaseCtrl.createCase(
        supportWrapper,
        fileIds
      );
      List<Case> leadRecord = [
        SELECT Id
        FROM Case
        WHERE Id = :caseId
      ];
      assert.areEqual(1, leadRecord.size(), 'Case should have been created');
      Test.stopTest();
    } 
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
   
  @isTest
  static void testDraftCase() {
    try {
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
			Username = System.now().millisecond() + 'test220@test.com',
			Alias = 'batman',
			Email = 'brucemess120.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess10',
			LastName = 'Waynemess10',
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
				FirstName = 'Brucemess10',
				LastName = 'Waynemess10',
				PersonEmail = 'brucemess120.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test12045@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test123',
				Email = 'test12045@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
      List<ContentVersion> testFiles = new List<ContentVersion>();
      for (Integer i = 0; i < 3; i++) {
        ContentVersion file = new ContentVersion(
          Title = 'Test File ' + i,
          PathOnClient = 'TestPathOnClient' + i + '.txt',
          VersionData = Blob.valueOf('Test File Content ' + i)
        );
        testFiles.add(file);
      }
      insert testFiles;
      // Call the method to be tested
      List<String> fileIds = new List<String>();
      for (ContentVersion file : testFiles) {
        fileIds.add(file.ContentDocumentId);
      }
      BI_PSPB_CreateSupportCaseCtrl.LeadWrapper supportWrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();
      supportWrapper.accountId = cpe.Id;
      supportWrapper.type = 'Medical Information Enquiry';
      supportWrapper.subType = 'Treatment';
      supportWrapper.description = 'description';
      // Call the method to be tested
      Test.startTest();
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(supportWrapper, fileIds);
      Test.stopTest();
    } 
    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  } 
  @isTest
  static void testcaseDraft() {
    try {
      Test.startTest();
      BI_PSPB_CreateSupportCaseCtrl.caseDraft(null, null);  
      Test.stopTest();
        List<Case> cases = [SELECT Id, Status FROM Case WHERE Status = 'Draft'];
         Assert.areEqual(1, cases.size(), 'Expected one case to be created.');
         Assert.areEqual('Draft', cases[0].Status, 'Case status should be Draft.');

    } catch (Exception e) {
      Assert.areEqual(
        'Script-thrown exception',
        e.getMessage(),
        'Method thrown exception'
      );
    }
  }
    
 

@isTest
static void testCareProgramRecordIsNull() {
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
			Username = System.now().millisecond() + 'test226@test.com',
			Alias = 'batman',
			Email = 'brucemess126.wayne@wayneenterprises.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'Brucemess16',
			LastName = 'Waynemess16',
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
				FirstName = 'Brucemess16',
				LastName = 'Waynemess16',
				PersonEmail = 'brucemess126.wayne@wayneenterprises.com',
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
				Username = System.now().millisecond() + 'test16045@test.com',
				ContactId = personContact.Id,
				ProfileId = portalProfile.Id,
				Alias = 'test623',
				Email = 'test16045@test.com',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Account',
				FirstName = 'Test',
				CommunityNickname = 'test1e45',
				TimeZoneSidKey = 'America/Los_Angeles',
				LocaleSidKey = 'en_US',
				LanguageLocaleKey = 'en_US'
			);

			insert user1;
      CareProgram testCP = new CareProgram(Name = 'Test Enrollee');
      insert testCP;
      CareProgramEnrollee cpe = new CareProgramEnrollee(
        AccountId = account.Id,
        Name = 'Test Enrollee',
        CareProgramId = testCP.Id
      );
      insert cpe;
BI_PSPB_CreateSupportCaseCtrl.LeadWrapper wrapper = new BI_PSPB_CreateSupportCaseCtrl.LeadWrapper();


wrapper.type = 'Medical Information Enquiry';
wrapper.subType = 'Treatment';
wrapper.description = 'Test description';
    List<String> fileIds = new List<String>();
    Test.startTest();
    Test.stopTest();
    System.assertNotEquals(null, fileIds, 'fileIds list should not be null.');
        
 } 
}
}