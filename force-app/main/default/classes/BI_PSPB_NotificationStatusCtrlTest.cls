@IsTest
/**
* @description This class contains test methods to verify the behaviour of updating 
status of the tasks.
* @author Niyas
* @Last Modified On  08/15/2024
* @Last Modified By   Niyas
*/
public class BI_PSPB_NotificationStatusCtrlTest {
	@TestSetup
	static void setup() {
		Task testTask = new Task(Subject = 'Test Task', Status = 'UnRead');
		insert testTask;
	}
	@IsTest
	static void testMarkTaskReadValidId() {
		Task testTask = [SELECT Id, Status FROM Task LIMIT 1];
		List<Task> updatedTasks = BI_PSPB_NotificationStatusCtrl.markTaskRead(
			testTask.Id
		);
		Assert.areEqual(
			1,
			updatedTasks.size(),
			'Only one task should be updated.'
		);
		Assert.areEqual(
			BI_PSPB_NotificationConstantsCtrl.actionTypeRead,
			updatedTasks[0].Status,
			'The task status should be updated to Read.'
		);
	}

	@IsTest
	static void testMarkTaskReadInvalidId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskRead(
				'InvalidTaskId'
			);
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}

	@IsTest
	static void testMarkTaskCompletedValidId() {
		Task testTask = [SELECT Id, Status FROM Task LIMIT 1];
		List<Task> updatedTasks = BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
			testTask.Id
		);
		Assert.areEqual(
			1,
			updatedTasks.size(),
			'Only one task should be updated.'
		);
		Assert.areEqual(
			BI_PSPB_NotificationConstantsCtrl.notificationStatusComplete,
			updatedTasks[0].Status,
			'The task status should be updated to Completed.'
		);
	}

	@IsTest
	static void testMarkTaskCompletedInvalidId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
				'InvalidTaskId'
			);
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
	@IsTest
	static void testMarkTaskReadNullId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskRead(
				''
			);
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}

	@IsTest
	static void testMarkTaskCompletedNullId() {
		try {
			BI_PSPB_NotificationStatusCtrl.markTaskCompleted(
				null
			);
		} catch (Exception e) {
			/*  While running negative scenario, the flow goes to catch.
				Thus resulting in throwing exception and so assertion is done
				for Exception only.*/
			Assert.areEqual(
				'Script-thrown exception',
				e.getMessage(),
				'Method thrown exception'
			);
		}
	}
}