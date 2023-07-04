/**
 * Tests for {@link SObjectUtil}.
 */
@IsTest(IsParallel=true)
private class SObjectUtilTest {
  @IsTest
  private static void collectIds_idField_collectsAndReturnsIds() {
    List<User> users = new List<User>{ new User(Id = UserInfo.getUserId()) };
    SObjectField field = User.Id;

    List<Id> userIds = SObjectUtil.collectIds(users, field);

    Assert.areEqual(1, userIds.size());
    Assert.areEqual(UserInfo.getUserId(), userIds[0]);
  }

  @IsTest
  private static void collectIds_otherTypeOfField_throws() {
    List<User> users = new List<User>{
      new User(LastName = UserInfo.getLastName())
    };
    SObjectField field = User.LastName;
    AssertThrows.Throwing throwing = AssertThrows.with(
      IllegalArgumentException.class,
      'Expected the field to be of type: {ID, REFERENCE}. Found: STRING'
    );

    try {
      SObjectUtil.collectIds(users, field);
      throwing.shouldHaveThrown();
    } catch (Exception e) {
      throwing.threw(e);
    }

    throwing.assertHasThrown();
  }

  @IsTest
  private static void generateFakeId() {
    SObjectType sobjectType = Account.SObjectType;

    String id1 = SObjectUtil.generateFakeId(sobjectType);
    String id2 = SObjectUtil.generateFakeId(sobjectType);
    String id3 = SObjectUtil.generateFakeId(sobjectType);

    Assert.areEqual('001000000000001AAA', id1);
    Assert.areEqual('001000000000002AAA', id2);
    Assert.areEqual('001000000000003AAA', id3);
  }

  @IsTest
  private static void setReadOnlyFields() {
    UserLicense userLicense = new UserLicense();
    Map<String, Object> fieldValues = new Map<String, Object>{
      'UsedLicenses' => 10
    };

    userLicense = (UserLicense) SObjectUtil.setReadOnlyFields(
      userLicense,
      fieldValues
    );

    Assert.areEqual(10, userLicense.UsedLicenses);
  }
}