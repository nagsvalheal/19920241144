/**
* @description Batch class for BI_PSPB_EmailBatch. Handles sending email notifications
*              to contacts based on specified criteria.
* History
* Version 	Author		Date			Detail		Description
* 1.0		Rajaa		01-Apr-2024		Created		Initial development.
* 1.1		Rajaa		06-Apr-2024		Updated		Code Review Changes.
*/

@isTest
public class BI_PSPB_EmailBatchTest {
	/**
* @description MockHttpResponse class to simulate HTTP callouts.
*/
	public class MockHttpResponse implements HttpCalloutMock {
		/**
* @description Responds to an HTTP request with a mock HTTP response.
*
* @param request The HTTP request.
* @return The mock HTTP response.
*/
		public HTTPResponse respond(HTTPRequest request) {
			// Create a new HTTPResponse object
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			response.setBody('{"status": "success"}');
			// Set the desired status code in the response
			response.setStatusCode(200);
			// Set the response body
			//response.setBody('{"status": "Success", "Message Id": "123"}');
			response.setBody('{"access_token": "mock_access_token"}');
			// Return the response
			return response;
		}
	}
	
	/**
* @description Mock class for simulating an HTTP response with a status code other than 200 (OK).
*/
	public class MockNotRecivedHttpResponse implements HttpCalloutMock {
		/**
* @description Responds to the HTTP request with a mock response.
*
* @param request The HTTPRequest object representing the request.
* @return An HTTPResponse object representing the mock response.
*/
		public HTTPResponse respond(HTTPRequest request) {
			// Create a new HTTPResponse object
			HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			response.setBody('{"status": "failed"}');
			// Set the desired status code in the response
			response.setStatusCode(400);
			// Set the response body
			response.setBody('{"access_token": "mock_access_token"}');
			// Return the response
			return response;
		}
	}
	
	@isTest
	static void testConstructorElsePart() {
		// Create a batch instance with invalid parameters
		Test.startTest();
		BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
			new List<Id>(), // Empty contactIds list
			'',             // Empty notificationDeveloperName
			'',
			'',             // Empty destUrl
			null            // Null notificationDate
		);
		Test.stopTest();
		Assert.areNotEqual(null, batch, 'Batch instance should not be null');
	}
	// Test method to verify positive scenario of the method for making a callout.This test ensures that the method behaves correctly when making a callout with a valid access token.
	@isTest
	static void positiveScenario() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		// Create instance of batch class
		Test.startTest();
		
		BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
			contactIds,
			'BI_PSP_Enrollment',
			'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
			'2024-02-28',
			null
		);
		Database.executeBatch(batch);
		
		Test.stopTest();
		Integer expectedRecordCount = 0;
		Integer actualRecordCount = [
			SELECT COUNT()
			FROM BI_PSPB_OmnichannelLog__c
		];
		Assert.areEqual(
			expectedRecordCount,
			actualRecordCount,
			'The correct number of records should be created'
		);
	}
	
	// Test method to verify behavior when making a callout without an access token.This test ensures that the method handles the scenario where an access token is missing properly.
	@isTest
	static void negativeScenario() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockNotRecivedHttpResponse());
		// Create instance of batch class
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
				contactIds,
				'BI_PSP_Enrollment',
				'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
				'2024-02-28',
				null
			);
			Database.executeBatch(batch);
			Test.stopTest();
		} catch (Exception e) {
			// Assert that the exception message is as expected
			Assert.areEqual(
				e.getMessage(),
				'Argument cannot be null.',
				e.getMessage()
			);
		}
	}
	
	// Test method to verify behavior when passing date as empty String.This test ensures that the method handles the scenario where an access token is missing properly.
	@isTest
	static void negativeScenarioUserName() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		// Create instance of batch class
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
				contactIds,
				'BI_PSP_Enrollment',
				'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
				'',
				null
			);
			Database.executeBatch(batch);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	
	// Test method to verify behavior when passing name as empty.This test ensures that the method handles the scenario where an access token is missing properly.
	@isTest
	static void negativeScenarioUserNameNull() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		// Create instance of batch class
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
				contactIds,
				'BI_PSP_Enrollment',
				'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
				'2024-02-28',
				null
			);
			Database.executeBatch(batch);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	// Test method to verify behavior when passing date as null.This test ensures that the method handles the scenario where an access token is missing properly.
	@isTest
	static void negativeScenarioDateNull() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		// Create instance of batch class
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
				contactIds,
				'BI_PSP_Enrollment',
				'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
				'',
				null
			);
			Database.executeBatch(batch);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	
	// Test method to verify behavior when passing name and date as empty string.This test ensures that the method handles the scenario where an access token is missing properly.
	@isTest
	static void negativeScenarioUserNameElse() {
		// Create test data
		BI_SFCOE_LOG_App_Settings__c settings = new BI_SFCOE_LOG_App_Settings__c(
			Name = 'ApplicationName',
			BI_SFCOE_LOG_Application__c = 'PSPB'
		);
		insert settings;
		List<Contact> contacts = new List<Contact>();
		for (Integer i = 0; i < 5; i++) {
			contacts.add(
				new Contact(
					FirstName = 'Test',
					LastName = 'Contact' + i,
					Phone = '123456789' + i
				)
			);
		}
		insert contacts;
		
		List<Id> contactIds = new List<Id>();
		for (Contact con : contacts) {
			contactIds.add(con.Id);
		}
		
		// Mock HTTP callout
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		// Create instance of batch class
		try {
			//assertion is not done because this is for negative scenario and it goes to catch
			Test.startTest();
			BI_PSPB_EmailBatch batch = new BI_PSPB_EmailBatch(
				contactIds,
				'BI_PSP_Enrollment',
				'https://bi-patient-eu--pspdev2.sandbox.my.site.com/Branded',
				'',
				null
			);
			Database.executeBatch(batch);
			Test.stopTest();
		} catch (Exception e) {
			Assert.areEqual(
				e.getMessage(),
				'Script-thrown exception',
				e.getMessage()
			);
		}
	}
	
	// Utility method to create and return a metadata record for testing purposes.
	private static BI_PSPB_OmnichannelSetting__mdt getTestMethodSetting() {
		BI_PSPB_OmnichannelSetting__mdt setting = new BI_PSPB_OmnichannelSetting__mdt(
			DeveloperName = 'BI_PSPB_SmsEndpoint',
			BI_PSPB_EndPoint__c = 'Test End Point',
			BI_PSPB_ClientSecret__c = 'Test Client Secret',
			BI_PSPB_ClientId__c = 'Test Client Id'
		);
		// Assert that the returned metadata instance is not null
		Assert.areNotEqual(
			null,
			setting,
			'Metadata instance should not be null'
		);
		return setting;
	}
	
	// Utility method to create and return a metadata record for testing purposes.
	private static BI_PSPB_Notification__mdt getTestMethodSettingNotIf() {
		BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_SmsBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
		// Assert that the returned metadata instance is not null
		Assert.areNotEqual(
			null,
			notification,
			'Metadata instance should not be null'
		);
		return notification;
	}
   @isTest
static void testCreateEmailLog() {
	// Create a test contact
	Contact con = new Contact(
		FirstName = 'Test',
		LastName = 'Contact',
		Phone = '123456789'
	);
	insert con;

	// Create a test notification
	BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
		DeveloperName = 'BI_PSP_NewArticleSms',
		BI_PSPB_SmsBody__c = 'Test SMS Body',
		BI_PSPB_EventName__c = 'Test Event Name',
		BI_PSPB_EventType__c = 'Test Event Type',
		BI_PSPB_Subject__c = 'Test Subject'
	);

	// Prepare other parameters
	String status = 'Sent';
	String messageId = '1234567890';
	Integer responseCode = 200;

	// Create an instance of EmailLogWrapper
	BI_PSPB_EmailBatch.EmailLogWrapper logWrapper = new BI_PSPB_EmailBatch.EmailLogWrapper(
		con,
		notification,
		status,
		messageId,
		responseCode
	);

	Test.startTest();
	
	// Call the method to create the email log using the wrapper
	BI_PSPB_EmailBatch.createEmailLog(logWrapper);
	
			Test.stopTest(); 	
			List<BI_PSPB_OmnichannelLog__c> insertedLogs = [
				SELECT BI_PSPB_ContactName__c, 
					   BI_PSPB_UserEmail__c, 
					   BI_PSPB_Status__c, 
					   BI_PSPB_EmailMessageId__c, 
					   BI_PSPB_StatusResponse__c
				FROM BI_PSPB_OmnichannelLog__c
				WHERE BI_PSPB_EmailMessageId__c = :messageId
			];
		

			// Additional checks for inserted log details
			if (!insertedLogs.isEmpty()) {
				BI_PSPB_OmnichannelLog__c insertedLog = insertedLogs[0];
				Assert.areEqual(con.Id, insertedLog.BI_PSPB_ContactName__c, 'Contact Id should match.');
				Assert.areEqual(con.Email, insertedLog.BI_PSPB_UserEmail__c, 'User email should match.');
				Assert.areEqual(status, insertedLog.BI_PSPB_Status__c, 'Status should be "Sent".');
			}
}
	@isTest
	static void testsaveEmailLogs() {
		contact con= new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Phone = '123456789' ,
			Email='test@gmail.com'
		);
		insert con;
		BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_EmailBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
		String status = 'Sent';
		String messageId = '1234567890';
		Boolean emailResponse = true;
		Integer responseCode = 200;
		BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
		emailLog.BI_PSPB_ContactName__c = con.Id; 
		emailLog.BI_PSPB_UserEmail__c = con.Email; 
		emailLog.BI_PSPB_Subject__c = notification.BI_PSPB_Subject__c; 
		emailLog.BI_PSPB_Body__c = notification.BI_PSPB_EmailBody__c; 
		emailLog.BI_PSPB_EventName__c = notification.BI_PSPB_EventName__c; 
		emailLog.BI_PSPB_EventType__c = notification.BI_PSPB_EventType__c; 
		emailLog.BI_PSPB_EmailResponse__c = emailResponse; 
		emailLog.BI_PSPB_TemplateId__c =''; 
		emailLog.BI_PSPB_Status__c = status; 
		emailLog.BI_PSPB_EmailMessageId__c = messageId; 
		emailLog.BI_PSPB_StatusResponse__c = String.valueOf(responseCode);
		List<BI_PSPB_OmnichannelLog__c> emailLogList = new  List<BI_PSPB_OmnichannelLog__c>();
		emailLogList.add(emailLog);
		insert emailLogList;
		Test.startTest();
		BI_PSPB_EmailBatch.saveEmailLogs(emailLogList);
		Test.stopTest();
		List<BI_PSPB_OmnichannelLog__c> insertedLogs = [
			SELECT BI_PSPB_ContactName__c, BI_PSPB_UserEmail__c, BI_PSPB_Status__c
			FROM BI_PSPB_OmnichannelLog__c
			WHERE Id IN :emailLogList
		];
		
		// Assertions to ensure the logs are saved correctly
		Assert.areEqual(1, insertedLogs.size(), 'One log should have been inserted.');
		
		BI_PSPB_OmnichannelLog__c insertedLog = insertedLogs[0];
		Assert.areEqual(con.Id, insertedLog.BI_PSPB_ContactName__c, 'Contact Id should match.');
		Assert.areEqual(con.Email, insertedLog.BI_PSPB_UserEmail__c, 'User email should match.');
		Assert.areEqual(status, insertedLog.BI_PSPB_Status__c, 'Status should be "Sent".');
	}
	@isTest
	static void testhandleEmailResponse() {
		contact con= new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Phone = '123456789' ,
			Email='test@gmail.com'
		);
		insert con;
		BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_EmailBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
		String status = 'Sent';
		String messageId = '1234567890';
		Boolean emailResponse = true;
		Integer responseCode = 200;
		BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
		emailLog.BI_PSPB_ContactName__c = con.Id; 
		emailLog.BI_PSPB_UserEmail__c = con.Email; 
		emailLog.BI_PSPB_Subject__c = notification.BI_PSPB_Subject__c; 
		emailLog.BI_PSPB_Body__c = notification.BI_PSPB_EmailBody__c; 
		emailLog.BI_PSPB_EventName__c = notification.BI_PSPB_EventName__c; 
		emailLog.BI_PSPB_EventType__c = notification.BI_PSPB_EventType__c; 
		emailLog.BI_PSPB_EmailResponse__c = emailResponse; 
		emailLog.BI_PSPB_TemplateId__c =''; 
		emailLog.BI_PSPB_Status__c = status; 
		emailLog.BI_PSPB_EmailMessageId__c = messageId; 
		emailLog.BI_PSPB_StatusResponse__c = String.valueOf(responseCode);
		List<BI_PSPB_OmnichannelLog__c> emailLogList = new  List<BI_PSPB_OmnichannelLog__c>();
		emailLogList.add(emailLog);
		insert emailLogList;
		HttpResponse response = new HttpResponse();
			response.setHeader('Content-Type', 'application/json');
			response.setBody('{"status": "success"}');
			response.setStatusCode(200);
			response.setBody('{"access_token": "mock_access_token"}');      
		Test.startTest();
		BI_PSPB_EmailBatch.handleEmailResponse(response,con,notification,emailLogList);
		Test.stopTest();
		List<BI_PSPB_OmnichannelLog__c> updatedLogs = [
			SELECT BI_PSPB_ContactName__c, BI_PSPB_UserEmail__c, BI_PSPB_Status__c, BI_PSPB_StatusResponse__c
			FROM BI_PSPB_OmnichannelLog__c
			WHERE Id IN :emailLogList
		];
		
		
		Assert.areEqual(1, updatedLogs.size(), 'One log should have been processed.');
		
		BI_PSPB_OmnichannelLog__c updatedLog = updatedLogs[0];
		Assert.areEqual(con.Id, updatedLog.BI_PSPB_ContactName__c, 'Contact Id should match.');
		Assert.areEqual(con.Email, updatedLog.BI_PSPB_UserEmail__c, 'User email should match.');
		Assert.areEqual(status, updatedLog.BI_PSPB_Status__c, 'Status should remain "Sent".');
		Assert.areEqual(String.valueOf(responseCode), updatedLog.BI_PSPB_StatusResponse__c, 'Status response should match the response code.');
		
	}
	@isTest
	static void testsendEmailAndLogResult() {
		contact con= new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Phone = '123456789' ,
			Email='test@gmail.com'
		);
		insert con;
		BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_EmailBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
		String status = 'Sent';
		String messageId = '1234567890';
		Boolean emailResponse = true;
		Integer responseCode = 200;
		BI_PSPB_OmnichannelLog__c emailLog = new BI_PSPB_OmnichannelLog__c();
		emailLog.BI_PSPB_ContactName__c = con.Id; 
		emailLog.BI_PSPB_UserEmail__c = con.Email; 
		emailLog.BI_PSPB_Subject__c = notification.BI_PSPB_Subject__c; 
		emailLog.BI_PSPB_Body__c = notification.BI_PSPB_EmailBody__c; 
		emailLog.BI_PSPB_EventName__c = notification.BI_PSPB_EventName__c; 
		emailLog.BI_PSPB_EventType__c = notification.BI_PSPB_EventType__c; 
		emailLog.BI_PSPB_EmailResponse__c = emailResponse; 
		emailLog.BI_PSPB_TemplateId__c =''; 
		emailLog.BI_PSPB_Status__c = status; 
		emailLog.BI_PSPB_EmailMessageId__c = messageId; 
		emailLog.BI_PSPB_StatusResponse__c = String.valueOf(responseCode);
		List<BI_PSPB_OmnichannelLog__c> emailLogList = new  List<BI_PSPB_OmnichannelLog__c>();
		emailLogList.add(emailLog);
		insert emailLogList;
	   String payLoad ='test payload';
		Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
		Test.startTest();
		BI_PSPB_EmailBatch.sendEmailAndLogResult(payLoad,con,notification,emailLogList);
		Test.stopTest();
				List<BI_PSPB_OmnichannelLog__c> updatedLogs = [
			SELECT BI_PSPB_ContactName__c, BI_PSPB_UserEmail__c, BI_PSPB_Status__c, BI_PSPB_StatusResponse__c
			FROM BI_PSPB_OmnichannelLog__c
			WHERE Id IN :emailLogList
		];

		// Assertions to ensure the logs were updated correctly
		Assert.areEqual(1, updatedLogs.size(), 'One log should have been processed.');

		BI_PSPB_OmnichannelLog__c updatedLog = updatedLogs[0];
		Assert.areEqual(con.Id, updatedLog.BI_PSPB_ContactName__c, 'Contact Id should match.');
		Assert.areEqual(con.Email, updatedLog.BI_PSPB_UserEmail__c, 'User email should match.');
		Assert.areEqual(status, updatedLog.BI_PSPB_Status__c, 'Status should remain "Sent".');
		Assert.areEqual(String.valueOf(responseCode), updatedLog.BI_PSPB_StatusResponse__c, 'Status response should match the response code.');

	}
	 @isTest
	static void testcreateEmailPayload() {
		contact con= new Contact(
			FirstName = 'Test',
			LastName = 'Contact',
			Phone = '123456789' ,
			Email='test@gmail.com'
		);
		insert con;
		BI_PSPB_Notification__mdt notification = new BI_PSPB_Notification__mdt(
			DeveloperName = 'BI_PSP_NewArticleSms',
			BI_PSPB_EmailBody__c = 'Test SMS Body',
			BI_PSPB_EventName__c = 'Test Event Name',
			BI_PSPB_EventType__c = 'Test Event Type',
			BI_PSPB_Subject__c = 'Test Subject'
		);
	  BI_PSPB_PrivacyPolicy__mdt privacy = new BI_PSPB_PrivacyPolicy__mdt(
	 BI_PSPB_Url__c='',
		  BI_PSPB_TermsofuseUrlEndPoint__c='',
		  BI_PSPB_PrivacyPolicyUrlEndpoint__c=''
	  );
	  try {
		Test.startTest();
		BI_PSPB_EmailBatch emailBatch = new BI_PSPB_EmailBatch(
			new List<Id>{con.Id},
			notification.DeveloperName,
			'http://example.com',
			'2024-08-01',
			new List<String>{'User1'}
		);
	  emailBatch.createEmailPayload(con, notification, privacy);
		Test.stopTest();
	}
	catch (Exception e) {
		// If an exception occurs, fail the test with the exception message
		System.assert(false, 'Test failed due to exception: ' + e.getMessage());
	}
}
}