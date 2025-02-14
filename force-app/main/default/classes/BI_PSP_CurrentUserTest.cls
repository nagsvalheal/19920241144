/** 
 * @description       : A BI_PSP_CurrentUserTest Utility Class for determining user type whether it is a patient or caregiver 
                       and capturing console messages while performing DMLs.
 * History:
 * Version  Author      Date            Detail          Description.
 * 1.0      Abinsha     10-Jul-2024     Created         Initial development.

 */
@isTest
private class BI_PSP_CurrentUserTest {
        @isTest
    static void testReturnTheAccountsAsPatient() {
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
    // Retrieve the Record Type ID for Person Accounts
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
    
    // Create Person Account
    Account portalAccount1 = new Account(
        FirstName = 'Test',
        LastName = 'Account',
        PersonEmail = 'currrent@user.com',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );
    
    insert portalAccount1;

    // Create user associated with Person Account
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
	Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
    User user1 = new User(
        Username = System.now().millisecond() + 'currrent@user.com',
        ContactId = personContact.Id,
        ProfileId = portalProfile.Id,
        Alias = 'Cuse',
        Email = 'currrent@user.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Account',
        FirstName = 'Test',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );

    insert user1;


        //User testUser = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        System.runAs(user1) {
            try{
                Test.startTest();
                List<Account> accounts = BI_PSP_CurrentUser.returnTheAccounts();
                Test.stopTest();
    
                Assert.areEqual(1, accounts.size(),'The number of accounts returned should be 1.');
            }
            catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(
					e.getMessage(),
					'Script-thrown exception',
					e.getMessage()
				);
			}
        }
}
    }

    @isTest
    static void testReturnTheAccountsAsCaregiver() {
        
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
    // Retrieve the Record Type ID for Person Accounts
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
    
    // Create Person Account
    Account portalAccount1 = new Account(
        FirstName = 'Test',
        LastName = 'Account',
        PersonEmail = 'currrent1@user.com',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );
    
    insert portalAccount1;

    // Create user associated with Person Account
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
	Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
    User user1 = new User(
        Username = System.now().millisecond() + 'currrent1@user.com',
        ContactId = personContact.Id,
        ProfileId = portalProfile.Id,
        Alias = 'Due',
        Email = 'currrent1@user.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Account',
        FirstName = 'Test',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );

    insert user1;

        System.runAs(user1) {
            try{
                Test.startTest();
                List<Account> accounts = BI_PSP_CurrentUser.returnTheAccounts();
                Test.stopTest();
    
                Assert.areEqual(1, accounts.size(),'The number of accounts returned should be 1.');
            }
            catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(
					e.getMessage(),
					'Script-thrown exception',
					e.getMessage()
				);
			}

        }
    }
    }
    @isTest
    static void testGetEnrolleeRecordsAsCaregiver() {
        
     		 UserRole portalRole = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];



Profile profile1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2@test.com',
    Alias = 'batmans',
    Email = 'bruce.wayne@wayneenterprises.com',
    EmailEncodingKey = 'UTF-8',
    FirstName = 'Bruceq',
    LastName = 'Wayneq',
    LanguageLocaleKey = 'en_US',
    LocaleSidKey = 'en_US',
    TimeZoneSidKey = 'America/Chicago'
);

insert portalAccountOwner1;

System.runAs(portalAccountOwner1) {
    // Retrieve the Record Type ID for Person Accounts
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
    
    // Create Person Account
    Account portalAccount1 = new Account(
        FirstName = 'Test',
        LastName = 'Account',
        PersonEmail = 'currrent2@user.com',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );
    
    insert portalAccount1;

    // Create user associated with Person Account
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
	Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
    User user1 = new User(
        Username = System.now().millisecond() + 'currrent2@user.com',
        ContactId = personContact.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test123',
        Email = 'currrent2@user.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Account',
        FirstName = 'Test',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );

    insert user1;


		//Creating Care program to insert careProgram Enrollee
		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;
		//To create Care Program Enrollee for Assessment
		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = portalAccount1.Id,
			CareProgramId = carePrgm.Id
		);
		insert testCpeOne;
        System.runAs(user1) {
            Test.startTest();
            List<CareProgramEnrollee> enrollees = BI_PSP_CurrentUser.getEnrolleeRecords();
            Test.stopTest();

            Assert.areEqual(1, enrollees.size(),'The number of accounts returned should be 1.');
			Assert.areEqual('TestCpa111', enrollees[0].Name,'Name shold be TestCpa111');
        }
    }
    }
         @isTest
    static void testGetEnrolleeRecordsAsCaregiverAndEnrollee() {
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
    // Retrieve the Record Type ID for Person Accounts
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
    
    // Create Person Account
    Account portalAccount1 = new Account(
        FirstName = 'Te',
        LastName = 'Account',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );
    
    insert portalAccount1;

    // Create user associated with Person Account
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
	Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
    User user1 = new User(
        Username = System.now().millisecond() + 'currrent3@user.com',
        ContactId = personContact.Id,
        BI_PSPB_Caregiver__c = true,
        ProfileId = portalProfile.Id,
        Alias = 'tew',
        Email = 'currrent3@user.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Account',
        FirstName = 'Test',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );

    insert user1;


		Account testAccountOne = new Account(
            FirstName ='Test',
			Lastname = 'Account',
			PersonEmail = 'test12345@test.com',
			RecordTypeId = personAccountRecordType.id,
            BI_PSPB_Selected_Patient_ID__c=portalAccount1.id
		);
		insert testAccountOne;

		//Creating Care program to insert careProgram Enrollee
		CareProgram carePrgm = new CareProgram(
			Name = 'testcp',
			StartDate = Date.valueOf('2024-02-28')
		);

		insert carePrgm;
		//To create Care Program Enrollee for Assessment
		CareProgramEnrollee testCpeOne = new CareProgramEnrollee(
			Name = 'TestCpa111',
			AccountId = portalAccount1.Id,
			CareProgramId = carePrgm.Id
          
		);
		insert testCpeOne;
        System.runAs(user1) {
            try{
                Test.startTest();
                List<Account> account = BI_PSP_CurrentUser.returnTheAccounts();
                Test.stopTest();
    
                Assert.areEqual(1, account.size(),'The number of accounts returned should be 1.');
            }
             catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(
					e.getMessage(),
					'Script-thrown exception',
					e.getMessage()
				);
			}
        }
    }
    }
    
          @isTest
    static void testGetEnrolleeRecordsAsCaregiverNegative() {
     
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
    // Retrieve the Record Type ID for Person Accounts
    RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1];
    
    // Create Person Account
    Account portalAccount1 = new Account(
        FirstName = 'Test',
        LastName = 'Account',
        PersonEmail = 'currrent4@user.com',
        OwnerId = portalAccountOwner1.Id,
        RecordTypeId = personAccountRecordType.Id
    );
    
    insert portalAccount1;

    // Create user associated with Person Account
    Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'BI_PSP_Patient Profile' LIMIT 1];
	Contact personContact = [SELECT Id FROM Contact WHERE AccountId = :portalAccount1.Id LIMIT 1];
    User user1 = new User(
        Username = System.now().millisecond() + 'currrent4@user.com',
        ContactId = personContact.Id,
        ProfileId = portalProfile.Id,
        Alias = 'teo',
        Email = 'currrent4@user.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Account',
        FirstName = 'Test',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
    );

    insert user1;

    
        System.runAs(user1) {
            try{
                Test.startTest();
                List<CareProgramEnrollee> account = BI_PSP_CurrentUser.getEnrolleeRecords();
                Test.stopTest();
    
                Assert.areEqual(1, account.size(),'The number of accounts returned should be 1.');
            }
            catch (Exception e) {
				// Assert that the exception message is as expected
				Assert.areEqual(
					e.getMessage(),
					'Script-thrown exception',
					e.getMessage()
				);
			}
        }
    }

    
}
     @isTest
    static void testGetSelectedPatientAccount() {
        // Create test data
        Account testAccount = new Account(
            FirstName = 'Test Account',
            LastName ='test',
            PersonEmail = 'test.email1@example.com',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account' LIMIT 1].Id
        );
        insert testAccount;
        
        // Call the method with the test data
        Account result = BI_PSP_CurrentUser.getSelectedPatientAccount(testAccount.Id);
        
        // Assertions
        assert.areNotEqual(null, result, 'The Account should not be null.');
        Assert.areEqual(testAccount.Id, result.Id, 'The Account ID should match.');
        assert.areNotEqual(testAccount.Name, result.Name, 'The Account Name should match.');
        Assert.areEqual(testAccount.PersonEmail, result.PersonEmail, 'The Person Email should match.');
    }
}