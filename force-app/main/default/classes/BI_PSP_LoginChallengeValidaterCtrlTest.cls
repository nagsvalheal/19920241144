/**
 * @description Test class for the BI_PSP_LoginChallengeValidaterCtrl Apex controller.
 * This test class verifies the behavior of the methods in the `BI_PSP_LoginChallengeValidaterCtrl` class,
 * specifically focusing on the validation of login history and article likes by different challenge levels.
 *
 * The test methods cover scenarios for validating login history and article likes across multiple levels:
 * - Test cases with sufficient and insufficient article likes.
 * - Different challenge levels, such as Level One, Level Two, and Level Three.
 * - Handling unmatched care plans.
 *
 * Reason for using @isTest is to ensure that the test methods are isolated and do not affect or interact with live data,
 * allowing for accurate and reliable validation of the Apex methods.
 * 
 * History:
 * Version    Author      Date              Detail         Description
 * 1.0        Nandha      14-Aug-2024       Created        Initial development test class
 */

@IsTest
public class BI_PSP_LoginChallengeValidaterCtrlTest {
    /**
     * @method setup
     * @description Test setup method that creates and inserts necessary test data for the test methods. 
     * This includes Care Programs, Care Plan Templates, Accounts, Care Program Enrollees, and related records.
     */
    @TestSetup
    static void setup() {
         // Create Care Program
        CareProgram careProgram = new CareProgram(
            Name = 'Beyond GPP: The Spevigo® (Spesolimab) Patient Support Program',
            StartDate = Date.today()
        );
        insert careProgram;
        // Create test data
        HealthCloudGA__CarePlanTemplate__c carePlanLevelOne = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.iamRegularLevelOne,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelOne
        );
        insert carePlanLevelOne;

        HealthCloudGA__CarePlanTemplate__c carePlanLevelTwo = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.iamRegularLevelTwo,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelTwo
        );
        insert carePlanLevelTwo;

        HealthCloudGA__CarePlanTemplate__c carePlanLevelThree = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.iamRegularLevelThree,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelThree
        );
        insert carePlanLevelThree;
                // Create Care Program Plan Template
                HealthCloudGA__CareProgramPlanTemplate__c careProgramPlan = new HealthCloudGA__CareProgramPlanTemplate__c(
                    HealthCloudGA__CareProgram__c = careProgram.Id,
                    HealthCloudGA__CarePlanTemplate__c = carePlanLevelOne.Id
                );
                insert careProgramPlan;
         // Create Account
        Account patientAccount = new Account(
            LastName = 'Patient User',
            PersonEmail = 'testuser@example.com'
        );
        insert patientAccount;

        // Create Care Program Enrollee
        CareProgramEnrollee enrollee = new CareProgramEnrollee(
            Name = 'CPE',
            AccountId = patientAccount.Id,
            CareProgramId = careProgram.Id,
            BI_PSP_Challenge_Rank__c = 'GPP beginner'
        );
        insert enrollee;
        
         // Create test data for Care Plan Templates
        HealthCloudGA__CarePlanTemplate__c carePlanGppLevelOne = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.gppExpertLevelOne,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelOne
        );
        insert carePlangppLevelOne;
        
        HealthCloudGA__CarePlanTemplate__c carePlanGppLevelTwo = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.gppExpertLevelTwo,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelTwo
        );
        insert carePlanGppLevelTwo;

        HealthCloudGA__CarePlanTemplate__c carePlanGppLevelThree = new HealthCloudGA__CarePlanTemplate__c(
            HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.gppExpertLevelThree,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelThree
        );
        insert carePlanGppLevelThree;

 // Create Award records
        Award awardOne = new Award(
            Name = 'Award One',
            BI_PSP_Care_Program_Enrollee__c = enrollee.Id,
            BI_PSP_Care_Program_Plan_Template__c = careProgramPlan.Id,
            BI_PSP_Status__c = 'Active',
            BI_PSP_Reward_Points__c = 60
        );
        insert awardOne;


          // Create BI_PSPB_Article_like__c records
        List<BI_PSPB_Article_like__c> articleLikes = new List<BI_PSPB_Article_like__c>();
        for (Integer i = 0; i < 10; i++) {
            articleLikes.add(new BI_PSPB_Article_like__c(
                BI_PSPB_CareProgramEnrollee__c = awardOne.BI_PSP_Care_Program_Enrollee__c, // Use the field directly
                BI_PSPB_Reaction__c = BI_PSP_ChallengeConstantCtrl.view
            ));
        }
        insert articleLikes;
    }
/**
     * @method testValidateLoginHistoryByLevel
     * @description Tests the validateLoginHistoryByLevel method from BI_PSP_LoginChallengeValidaterCtrl.
     * It verifies that the method correctly calculates completion percentages for different care plan levels
     * and handles various scenarios.
     */
    @IsTest
    static void testValidateLoginHistoryByLevel() {
        
        HealthCloudGA__CarePlanTemplate__c carePlanLevelOne = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.iamRegularLevelOne LIMIT 1];
        HealthCloudGA__CarePlanTemplate__c carePlanLevelTwo = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.iamRegularLevelTwo LIMIT 1];
        HealthCloudGA__CarePlanTemplate__c carePlanLevelThree = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.iamRegularLevelThree LIMIT 1];
        Award award = [SELECT Id,Name,BI_PSP_Care_Program_Enrollee__r.Id,BI_PSP_Care_Program_Plan_Template__c,BI_PSP_Status__c,BI_PSP_Reward_Points__c FROM Award LIMIT 1];
        
        BI_PSP_ChallengeCtrl.ChallengeWrapper successMessage = new BI_PSP_ChallengeCtrl.ChallengeWrapper();

        // Test Level One
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultOne = BI_PSP_LoginChallengeValidaterCtrl.validateLoginHistoryByLevel(carePlanLevelOne, UserInfo.getUserId(), award, successMessage);
        Assert.areEqual(100, resultOne.percentage, 'Expected 100% completion for Level One');

        // Test Level Two
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultTwo = BI_PSP_LoginChallengeValidaterCtrl.validateLoginHistoryByLevel(carePlanLevelTwo, UserInfo.getUserId(), award, successMessage);
       Assert.areEqual(100, resultTwo.percentage, 'Expected 100% completion for Level Two');

       BI_PSP_LoginChallengeValidaterCtrl.validateLoginHistoryByLevel(carePlanLevelThree, UserInfo.getUserId(), award, successMessage);
      
    }

  /**
     * @method testValidateArticleLikeByLevel
     * @description Tests the validateArticleLikeByLevel method from BI_PSP_LoginChallengeValidaterCtrl.
     * It verifies that the method correctly calculates completion percentages based on article likes 
     * for different care plan levels and handles scenarios with sufficient and insufficient likes.
     */
    @IsTest
    static void testValidateArticleLikeByLevel() {
        // Retrieve the test data
        HealthCloudGA__CarePlanTemplate__c carePlanLevelOne = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.gppExpertLevelOne LIMIT 1];
        HealthCloudGA__CarePlanTemplate__c carePlanLevelTwo = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.gppExpertLevelTwo LIMIT 1];
        HealthCloudGA__CarePlanTemplate__c carePlanLevelThree = [SELECT Id,Name,BI_PSP_Challenge_Reward_Points__c, HealthCloudGA__Description__c, BI_PSP_Challenge_Level__c FROM HealthCloudGA__CarePlanTemplate__c WHERE HealthCloudGA__Description__c = :BI_PSP_ChallengeConstantCtrl.gppExpertLevelThree LIMIT 1];
        Award award = [SELECT Id, BI_PSP_Care_Program_Enrollee__r.Id FROM Award LIMIT 1];
        
        // Test level one with sufficient likes
        BI_PSP_ChallengeCtrl.ChallengeWrapper successMessageLevelOne = new BI_PSP_ChallengeCtrl.ChallengeWrapper();
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultOne = BI_PSP_LoginChallengeValidaterCtrl.validateArticleLikeByLevel(carePlanLevelOne, award, successMessageLevelOne);
        Assert.areEqual(100, resultOne.percentage, 'Expected 100% completion for Level One with sufficient likes');
        
        // Test level two with insufficient likes
        delete [SELECT Id FROM BI_PSPB_Article_like__c WHERE BI_PSPB_CareProgramEnrollee__c = :award.BI_PSP_Care_Program_Enrollee__r.Id];
        List<BI_PSPB_Article_like__c> insufficientArticleLikes = new List<BI_PSPB_Article_like__c>();
        for (Integer i = 0; i < 4; i++) {
            insufficientArticleLikes.add(new BI_PSPB_Article_like__c(
                BI_PSPB_CareProgramEnrollee__c = award.BI_PSP_Care_Program_Enrollee__r.Id,
                BI_PSPB_Reaction__c = BI_PSP_ChallengeConstantCtrl.view
            ));
        }
        insert insufficientArticleLikes;
        
        BI_PSP_ChallengeCtrl.ChallengeWrapper successMessageLevelTwo = new BI_PSP_ChallengeCtrl.ChallengeWrapper();
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultTwo = BI_PSP_LoginChallengeValidaterCtrl.validateArticleLikeByLevel(carePlanLevelTwo, award, successMessageLevelTwo);
        Assert.areEqual(80, resultTwo.percentage, 'Expected 0% completion for Level Two with insufficient likes');
      	Boolean containsErrorMessage = resultTwo.error != null && resultTwo.error.contains('likes needed');
    	Assert.areEqual(false, containsErrorMessage, 'Expected error message for insufficient likes');
       
        // Test level two with sufficient likes (restore likes)
        delete [SELECT Id FROM BI_PSPB_Article_like__c WHERE BI_PSPB_CareProgramEnrollee__c = :award.BI_PSP_Care_Program_Enrollee__r.Id];
       

        // Test level three with sufficient likes
        BI_PSP_ChallengeCtrl.ChallengeWrapper successMessageLevelThree = new BI_PSP_ChallengeCtrl.ChallengeWrapper();
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultThree = BI_PSP_LoginChallengeValidaterCtrl.validateArticleLikeByLevel(carePlanLevelThree, award, successMessageLevelThree);
        Assert.areEqual(0, resultThree.percentage, 'Expected 100% completion for Level Three with sufficient likes');
        
        // Test with a care plan that does not match any level
        HealthCloudGA__CarePlanTemplate__c carePlanUnmatched = new HealthCloudGA__CarePlanTemplate__c(
             HealthCloudGA__Description__c = BI_PSP_ChallengeConstantCtrl.iamRegularLevelThree,
            BI_PSP_Challenge_Level__c = BI_PSP_ChallengeConstantCtrl.challengeLevelThree
        );
        insert carePlanUnmatched;

        BI_PSP_ChallengeCtrl.ChallengeWrapper successMessageUnmatched = new BI_PSP_ChallengeCtrl.ChallengeWrapper();
        BI_PSP_ChallengeCtrl.ChallengeWrapper resultUnmatched = BI_PSP_LoginChallengeValidaterCtrl.validateArticleLikeByLevel(carePlanUnmatched, award, successMessageUnmatched);
        Assert.areEqual(null, resultUnmatched.percentage, 'Expected 0% completion for unmatched care plan');
    }
}