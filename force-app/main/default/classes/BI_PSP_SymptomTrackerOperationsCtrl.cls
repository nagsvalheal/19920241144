/**
 * @description This class provides functionality for getLastCareTemplate  getLastEntryDate for Symptom Tracker module.
 * @history
 * Version    Author           Date           Detail    Description
 * 1.0        Karthikeyan      23-Jul-2024    Created   Initial development.
 */
public with sharing class BI_PSP_SymptomTrackerOperationsCtrl {

	/**            
    @description    Retrieves the last 10 CarePlanTemplate records
    USER_MODE cannot be implemented here, as it is querying health cloud object.         
    @return         last 10 record return .This return values pass to bipspbiPspbSymptomTracker this components              
  */

	@AuraEnabled(cacheable=true)
	public static List<HealthCloudGA__CarePlanTemplate__c> getLastCareTemplate() {
		try {
			// Convert the variable to a string
			String symptomRecordTypeValue = String.valueOf(
				BI_PSP_SymptomTrackerConstant.symptomRecordType
			);

			// Construct the dynamic query string
			String queryString =
				'SELECT Id, BI_PSP_Symptom_image__c, Name, RecordTypeId ' +
				'FROM HealthCloudGA__CarePlanTemplate__c ' +
				'WHERE RecordType.Name = \'' +
				symptomRecordTypeValue +
				'\' ' +
				'ORDER BY CreatedDate DESC ' +
				'LIMIT 10';

			// Execute the query

			List<HealthCloudGA__CarePlanTemplate__c> results = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);

			if (results.isEmpty()) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.error,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			return results;
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.error,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
		return new List<HealthCloudGA__CarePlanTemplate__c>();
	}

	/**
                
    @description    Deletes ContentDocumentLink records linked to Symptom Tracker records.
    @param         symptomTrackerId  details based on the provided user ID
  */

	@AuraEnabled
	public static void deleteContentDocumentLinks(Id symptomTrackerId) {
		try {
			if (String.isBlank(symptomTrackerId)) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Query for the first ContentDocumentLink related to the symptomTrackerId
			String queryString =
				'SELECT Id ' +
				'FROM ContentDocumentLink ' +
				'WHERE LinkedEntityId = \'' +
				symptomTrackerId +
				'\' ' +
				'LIMIT 1';

			// Execute the query using the common query utility
			List<ContentDocumentLink> linksToDelete = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);

			BI_PSP_DatabaseOperationsUtility.deleteOperation(
				linksToDelete,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				false
			);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.applicationPhotoMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
	}

	/**
    @description      Retrieves details of the latest Symptom Tracker record for a CareProgramEnrollee.
                USER_MODE cannot be implemented here, as it is querying health cloud object.
    @param          careProgramEnrolleeId  
    @return         This return values pass to bipspbiPspbSymptomTracker this components 
    */

	@AuraEnabled(cacheable=true)
	public static Map<String, Object> getSymptomTrackerDetails(
		Id careProgramEnrolleeId
	) {
		try {
			if (String.isBlank(careProgramEnrolleeId)) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.careProgramErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Debug log to check the value of careProgramEnrolleeId
			String sObjectType = 'BI_PSP_Symptom_Tracker__c';
			String fields = 'Id, BI_PSP_EditEntrydates__c, LastModifiedDate';
			String conditions =
				'BI_PSP_Care_Program_Enrollee__c = \'' +
				careProgramEnrolleeId +
				'\' AND BI_PSP_Symptom_Staus__c != \'' +
				BI_PSP_SymptomTrackerConstant.inActiveRecord +
				'\'  ORDER BY LastModifiedDate DESC LIMIT 1 ';
			Boolean withUserMode = false;

			List<BI_PSP_Symptom_Tracker__c> record = BI_PSP_CommonQueryUtility.executeQuery(
				sObjectType,
				fields,
				conditions,
				withUserMode
			);

			if (record.isEmpty()) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.error,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Create a map to store the result
			Map<String, Object> result = new Map<String, Object>();
			result.put('recordId', record[0].Id);
			result.put('lastModifiedDate', record[0].LastModifiedDate);
			result.put('lasttime', record[0].LastModifiedDate);
			return result;
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}

		return null;
	}

	/**
    @description   fetchAccountDetails Person Gender Identity.
    @param         careProgramEnrolleeId
    @return        enrollees Person Gender Identity.This return values pass to bipspbiPspbSymptomTracker this components 
      */

	@AuraEnabled(cacheable=true)
	public static List<CareProgramEnrollee> fetchAccountDetails(
		String careProgramEnrolleeId
	) {
		List<CareProgramEnrollee> enrollees = new List<CareProgramEnrollee>();
		try {
			if (String.isBlank(careProgramEnrolleeId)) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.careProgramErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
			// Perform SOQL query to fetch CareProgramEnrollee and related Account fields
			String queryString =
				'SELECT Id, AccountId, Account.Name, Account.HealthCloudGA__Gender__pc FROM CareProgramEnrollee WHERE Id = \'' +
				careProgramEnrolleeId +
				'\' LIMIT 1';

			enrollees = BI_PSP_CommonQueryUtility.executeComplexQuery(
				queryString,
				false
			);
		} catch (Exception ex) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.patientErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				ex
			);
		}
		return enrollees;
	}
	/**
	 * @description This method extracts the file type from a base64-encoded content string by checking the MIME type.
	 *
	 * @param base64Content The base64-encoded content string, which includes the MIME type and encoded file data.
	 * @return String The file type based on the MIME type (e.g., 'png', 'jpeg', 'pdf'), or null if the format is invalid or unsupported.
	 */
	@AuraEnabled
	public static String getFileTypeFromBase64(String base64Content) {
		if (String.isBlank(base64Content)) {
			BI_PSP_LogMessagesUtility.logError(
				BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				true,
				BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
			);
			return null;
		}

		// Find the position of the comma
		Integer commaIndex = base64Content.indexOf(',');
		if (commaIndex == -1) {
			// No comma found, invalid format
			BI_PSP_LogMessagesUtility.logError(
				BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				true,
				BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
			);
			return null;
		}

		// Extract MIME type from the part before the comma
		String dataUriPrefix = base64Content.substring(0, commaIndex);
		Integer colonIndex = dataUriPrefix.indexOf(':');
		Integer semicolonIndex = dataUriPrefix.indexOf(';');

		if (
			colonIndex == -1 ||
			semicolonIndex == -1 ||
			semicolonIndex <= colonIndex
		) {
			// Invalid format for MIME type
			BI_PSP_LogMessagesUtility.logError(
				BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				true,
				BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
			);
			return null;
		}

		String mimeType = dataUriPrefix.substring(
			colonIndex + 1,
			semicolonIndex
		);

		if (mimeType == 'image/png') {
			return 'png';
		} else if (mimeType == 'image/jpeg') {
			return 'jpeg';
		} else if (mimeType == 'application/pdf') {
			return 'pdf';
		}

		return null;
	}

	/**
 * @description This method takes a list of Base64-encoded file contents and a parent record ID,
 *              saves them as `ContentVersion` records, and returns the corresponding `ContentDocumentId`s.
 *
 * @param fileContents A list of Base64-encoded strings representing the files to be uploaded.
 *                     The format of each string should follow the standard data URI format: 'data:[mimeType];base64,[data]'.
 * @param parentId The ID of the record (e.g., Case, Account) where the files will be associated (FirstPublishLocationId).
 * @param fileName The name to be used for the files being uploaded (without the extension).
 *
 * @return A list of `ContentDocumentId`s for the successfully inserted files.
 **/
	@AuraEnabled
	public static List<String> saveFiles(
		List<String> fileContents,
		String parentId,
		String fileName
	) {
		List<String> contentDocumentIds = new List<String>();

		if (
			fileContents == null ||
			fileContents.isEmpty() ||
			String.isBlank(parentId) || fileName == null
		) {
			BI_PSP_LogMessagesUtility.logError(
				BI_PSP_SymptomTrackerConstant.applicationPhotoMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				true,
				BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
			);
			return contentDocumentIds;
		}

		List<ContentVersion> contentVersionsToInsert = new List<ContentVersion>();

		for (Integer i = 0; i < fileContents.size(); i++) {
			String fileContent = fileContents[i];
			try {
				// Ensure the fileContent contains a comma
				Integer commaIndex = fileContent.indexOf(',');
				if (commaIndex == -1) {
					BI_PSP_LogMessagesUtility.logError(
						BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
						BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
						true,
						BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
					);
				}

				// Extract Base64 data from fileContent
				String base64Data = fileContent.substring(commaIndex + 1);
				Blob fileBlob = EncodingUtil.base64Decode(base64Data);

				// Determine the file type using a simplified method
				String fileType = getFileTypeFromBase64(fileContent);

				if (fileType == null) {
					BI_PSP_LogMessagesUtility.logError(
						BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
						BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
						true,
						BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
					);
				}

				// Create ContentVersion record
				ContentVersion contentVersion = new ContentVersion();
				contentVersion.VersionData = fileBlob;
				contentVersion.Title = fileName + fileType;
				contentVersion.PathOnClient = 'File.' + fileType;
				contentVersion.FirstPublishLocationId = parentId;
				contentVersionsToInsert.add(contentVersion);
			} catch (Exception e) {
				BI_PSP_LogMessagesUtility.logError(
					BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
					BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
					true,
					BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
				);
			}
		}

		if (!contentVersionsToInsert.isEmpty()) {
			Database.SaveResult[] insertResults = Database.insert(
				contentVersionsToInsert,
				false
			);
			List<Id> contentVersionIds = new List<Id>();
			for (Database.SaveResult result : insertResults) {
				if (result.isSuccess()) {
					contentVersionIds.add(result.getId());
				}
			}
			if (!contentVersionIds.isEmpty()) {
				List<ContentVersion> insertedVersions = [
					SELECT ContentDocumentId
					FROM ContentVersion
					WHERE Id IN :contentVersionIds
				];
	
				// Add the ContentDocumentIds to the result list
				for (ContentVersion insertedVersion : insertedVersions) {
					contentDocumentIds.add(insertedVersion.ContentDocumentId);
				}
			}
		}

		return contentDocumentIds;
	}

	/**
	 * @description This method creates `ContentDocumentLink` records to associate files with a symptom tracker record.
	 *              It links each file (via `ContentDocumentId`) to the specified `symptomTrackerId`.
	 *
	 * @param fileIds A list of file `ContentDocumentId`s that need to be linked to the symptom tracker.
	 * @param symptomTrackerId The ID of the symptom tracker record (LinkedEntityId) to which the files will be linked.
	 * */

	@AuraEnabled(cacheable=true)
	public static void createContentDocumentLinks(
		List<String> fileIds,
		Id symptomTrackerId
	) {
		try {
		if (
			fileIds == null ||
			fileIds.isEmpty() ||
			String.isBlank(symptomTrackerId)
		) {
			BI_PSP_LogMessagesUtility.logError(
				BI_PSP_SymptomTrackerConstant.symptomErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				true,
				BI_PSP_SymptomTrackerConstant.LOG_SEVERITY_ERROR
			);
		}

		List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();

		for (String fileId : fileIds) {
			ContentDocumentLink link = new ContentDocumentLink();
			link.ContentDocumentId = fileId;
			link.LinkedEntityId = symptomTrackerId;
			link.ShareType = 'I';
			fileLinks.add(link);
		}
		BI_PSP_DatabaseOperationsUtility.insertOperation(
			fileLinks,
			BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
			false
		);
		
		} catch (Exception e) {
			BI_PSP_LogMessagesUtility.exceptionLogMessage(
				BI_PSP_SymptomTrackerConstant.patientErrorMsg,
				BI_PSP_SymptomTrackerOperationsCtrl.class.toString(),
				e
			);
		}
	}
}