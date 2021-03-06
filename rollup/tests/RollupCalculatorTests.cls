@isTest
private class RollupCalculatorTests {
  // TODO - refactor RollupTests so that the different *calculator type*-based tests live here instead

  /** FIRST / LAST operations */
  @isTest
  static void shouldReturnDefaultWhenNoCalcItemsFirst() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(new List<Opportunity>(), new Map<Id, SObject>());

    System.assertEquals(0, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnDefaultWhenNoCalcItemsAverage() {
    Rollup__mdt metadata = new Rollup__mdt();
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.Average,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(new List<Opportunity>(), new Map<Id, SObject>());

    System.assertEquals(0, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnFirstValueBasedOnMetadataField() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    // the important part is that the middle item is the one used, to prove that sorting occurred
    // this will be true for all the first/last tests in this class
    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1, CloseDate = System.today().addDays(2)),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15, CloseDate = System.today().addDays(1))
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnLastValueBasedOnMetadataField() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.LAST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1, CloseDate = System.today().addDays(-15)),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15, CloseDate = System.today().addDays(-2))
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnFirstValueIfOtherOrderByValueIsNull() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15, CloseDate = System.today().addDays(2))
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnMiddleValueWhenFirstAndLastAreNull() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnFirstValueWhenMiddleAndLastAreNull() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(1, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnLastValueIfOtherOrderByValueIsNull() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, CloseDate = System.today()),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldNotSortAtAllIfOrderByValuesAreNull() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'CloseDate');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    List<Opportunity> opps = new List<Opportunity>{
      new Opportunity(Id = '0066g00003VDGbF001', Amount = 1),
      new Opportunity(Id = '0066g00003VDGbF002', Amount = 2),
      new Opportunity(Id = '0066g00003VDGbF003', Amount = 15)
    };

    calc.performRollup(opps, new Map<Id, SObject>());

    System.assertEquals(opps[0].Amount, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnFirstString() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Name');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1, Name = 'b'),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, Name = 'a'),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15, Name = 'c')
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnLastString() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Name');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.LAST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 1, Name = 'b'),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 2, Name = 'c'),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15, Name = 'a')
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(2, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnFirstNumber() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Amount');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 2),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 1),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 15)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(1, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void shouldReturnLastNumber() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Amount');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.LAST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 2),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 16),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 1)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(16, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void regressionShouldRollupFirstLastWithQueriedOrderBy() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Name');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 2, Name = 'b'),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 16, Name = 'a'),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 1, Name = 'c')
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(16, (Decimal) calc.getReturnValue());
  }

  @isTest
  static void regressionShouldExcludeCurrentItemsOnFirstLastDelete() {
    Rollup__mdt metadata = new Rollup__mdt(OrderByFirstLast__c = 'Name');
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.DELETE_FIRST,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Account.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 2, Name = 'b'),
        new Opportunity(Id = '0066g00003VDGbF002', Amount = 16, Name = 'a'),
        new Opportunity(Id = '0066g00003VDGbF003', Amount = 1, Name = 'c')
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(0, calc.getReturnValue(), 'Delete should exclude current values :(');
  }

  // AVERAGE tests

  @isTest
  static void shouldNotTryToAverageNull() {
    Rollup__mdt metadata = new Rollup__mdt();
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.AVERAGE,
      Opportunity.Amount,
      Account.AnnualRevenue,
      metadata,
      '0011g00003VDGbF002',
      Opportunity.Id
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Id = '0066g00003VDGbF001', Amount = 2),
        new Opportunity(Id = '0066g00003VDGbF002'),
        new Opportunity(Id = '0066g00003VDGbF003'),
        new Opportunity(Id = '0066g00003VDGbF004', Amount = 2)
      },
      new Map<Id, SObject>()
    );

    System.assertEquals(1, (Decimal) calc.getReturnValue(), 'Nulls should be treated as zeros for average!');
  }

  // COUNT tests

  @isTest
  static void shouldReturnNewValOnCountChangeIfReparenting() {
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      0,
      Rollup.Op.UPDATE_COUNT,
      Opportunity.Amount,
      Account.AnnualRevenue,
      new Rollup__mdt(),
      '0011g00003VDGbF002',
      Opportunity.AccountId
    );
    Opportunity opp = new Opportunity(Id = '0066g00003VDGbF001', Amount = 2, AccountId = '0016g00003VDGbF001');
    calc.performRollup(new List<Opportunity>{ opp }, new Map<Id, SObject>{ opp.Id => new Opportunity(AccountId = '0016g00003VDGbF002', Amount = 1) });

    System.assertEquals(opp.Amount, (Decimal) calc.getReturnValue(), 'New value should be returned on reparenting update!');
  }

  // CONCAT tests

  @isTest
  static void shouldConcatDistinctProperly() {
    String distinct = 'distinct';
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      distinct,
      Rollup.Op.CONCAT_DISTINCT,
      Opportunity.Name,
      Account.Name,
      new Rollup__mdt(),
      '0011g00003VDGbF002',
      Opportunity.AccountId
    );
    Opportunity opp = new Opportunity(Id = '0066g00003VDGbF001', Name = distinct, AccountId = '0016g00003VDGbF001');
    Opportunity nonDistinctOpp = new Opportunity(Id = '0066g00003VDGbF001', Name = 'non' + distinct, AccountId = '0016g00003VDGbF001');
    calc.performRollup(new List<Opportunity>{ opp, nonDistinctOpp }, new Map<Id, SObject>());

    System.assertEquals(
      distinct +
      ', ' +
      nonDistinctOpp.Name,
      (String) calc.getReturnValue(),
      'Value containing original distinct value should also be concatenated'
    );
  }

  @isTest
  static void shouldUseCustomConcatDelimiterWhenSupplied() {
    String distinct = 'distinct';
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      distinct,
      Rollup.Op.CONCAT_DISTINCT,
      Opportunity.Name,
      Account.Name,
      new Rollup__mdt(ConcatDelimiter__c = ';'),
      '0011g00003VDGbF002',
      Opportunity.AccountId
    );
    Opportunity opp = new Opportunity(Id = '0066g00003VDGbF001', Name = distinct, AccountId = '0016g00003VDGbF001');
    Opportunity nonDistinctOpp = new Opportunity(Id = '0066g00003VDGbF001', Name = 'non' + distinct, AccountId = '0016g00003VDGbF001');
    calc.performRollup(new List<Opportunity>{ opp, nonDistinctOpp }, new Map<Id, SObject>());

    System.assertEquals(
      distinct +
      '; ' +
      nonDistinctOpp.Name,
      (String) calc.getReturnValue(),
      'distinct values should be concatenated with custom delimiter!'
    );
  }

  // PICKLIST tests

  @isTest
  static void shouldConcatenateProperlyToMultiSelectPicklist() {
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      '',
      Rollup.Op.CONCAT,
      Opportunity.Name,
      QuickText.Channel,
      new Rollup__mdt(),
      QuickText.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12),
      QuickText.Name
    );

    calc.performRollup(
      new List<Opportunity>{
        new Opportunity(Name = 'Hello'),
        new Opportunity(Name = 'World, I know'),
        new Opportunity(Name = 'And'),
        new Opportunity(Name = 'SSK')
      },
      new Map<Id, SObject>()
    );

    System.assertEquals('And;Hello;SSK;World, I know', (String) calc.getReturnValue(), 'Multi-select should use ; to concat');
  }

  @isTest
  static void shouldMinOnMultiSelectPicklist() {
    Rollup__mdt metadata = new Rollup__mdt();
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      '',
      Rollup.Op.MIN,
      QuickText.Channel,
      Opportunity.Name,
      metadata,
      Opportunity.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12),
      QuickText.Name
    );

    List<Schema.PicklistEntry> picklistVals = QuickText.Channel.getDescribe().getPicklistValues();
    if (picklistVals.size() < 3) {
      return;
    }

    String firstVal = picklistVals[0].getValue();
    String secondVal = picklistVals[1].getValue();
    String thirdVal = picklistVals[2].getValue();

    calc.performRollup(
      new List<QuickText>{ new QuickText(Channel = firstVal + ';' + secondVal), new QuickText(Channel = secondVal + ';' + thirdVal) },
      new Map<Id, SObject>()
    );

    System.assertEquals(firstVal + ';' + secondVal, calc.getReturnValue(), 'Min should take first entries for multi-select picklists');
  }

  // MIN / MAX

  @isTest
  static void shouldDefaultToMaxNumberOnMinIfNoMatchingItems() {
    Rollup__mdt metadata = new Rollup__mdt();
    Date today = System.today();
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      today,
      Rollup.Op.UPDATE_MIN,
      Task.ActivityDate, // not a "MIN"-able field in SOQL; crucial for this test
      QuickText.Channel,
      metadata,
      QuickText.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12),
      Task.WhatId
    );

    // the important things here: the current date is greater than both the passed in date (the "current" value on the lookup object)
    // AND that the "current" value matches what's on the old item
    Task t = new Task(ActivityDate = today.addDays(1), Id = Task.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12));

    calc.performRollup(new List<Task>{ t }, new Map<Id, SObject>{ t.Id => new Task(ActivityDate = today) });

    Datetime expectedDt = Datetime.newInstance(RollupFieldInitializer.Current.maximumLongValue);

    System.assertEquals(
      Datetime.newInstanceGmt(expectedDt.yearGmt(), expectedDt.monthGmt(), expectedDt.dayGmt(), 0, 0, 0),
      calc.getReturnValue(),
      'Should have hours/minutes/seconds lopped off since we are operating on a Date field'
    );
  }

  @isTest
  static void shouldDefaultToMinNumberOnMaxIfNoMatchingItems() {
    Rollup__mdt metadata = new Rollup__mdt();
    Date today = System.today();
    RollupCalculator calc = RollupCalculator.Factory.getCalculator(
      today,
      Rollup.Op.UPDATE_MAX,
      Task.ActivityDate, // not a "MAX"-able field in SOQL; crucial for this test
      QuickText.Channel,
      metadata,
      QuickText.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12),
      Task.WhatId
    );

    // the important things here: the current date is less than both the passed in date (the "current" value on the lookup object)
    // AND that the "current" value matches what's on the old item
    Task t = new Task(ActivityDate = today.addDays(-1), Id = Task.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12));

    calc.performRollup(new List<Task>{ t }, new Map<Id, SObject>{ t.Id => new Task(ActivityDate = today) });

    Datetime expectedDt = Datetime.newInstance(RollupFieldInitializer.Current.minimumLongValue);

    System.assertEquals(
      Datetime.newInstanceGmt(expectedDt.yearGmt(), expectedDt.monthGmt(), expectedDt.dayGmt(), 0, 0, 0),
      calc.getReturnValue(),
      'Should have hours/minutes/seconds lopped off since we are operating on a Date field'
    );
  }

  // Factory tests

  @isTest
  static void shouldThrowExceptionIfTypeNotSupported() {
    Exception ex;

    try {
      RollupCalculator calc = RollupCalculator.Factory.getCalculator(
        Blob.valueOf(''), // unsupported type
        Rollup.Op.CONCAT,
        Opportunity.Name,
        QuickText.Channel,
        new Rollup__mdt(),
        QuickText.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12),
        QuickText.Name
      );
    } catch (Exception e) {
      ex = e;
    }

    System.assertNotEquals(null, ex, 'Exception should have been thrown');
  }

  @isTest
  static void shouldInvokeNoOpMethodsWithoutFail() {
    RollupCalculator calc = new RollupCalcEmptyMock();
    calc.handleCountDistinct(null);
    calc.handleUpdateCountDistinct(null, null);
    calc.handleSumOrCount(null);
    calc.handleUpdateSumOrCount(null, null);
    calc.handleDeleteSumOrCount(null);
    calc.handleMin(null);
    calc.handleMax(null);
    calc.handleUpdateMinOrMax(null, null);
    calc.handleConcat(null);
    calc.handleUpdateConcat(null, null);
    calc.handleDeleteConcat(null);

    System.assert(true, 'Should make it here');
  }

  private class RollupCalcEmptyMock extends RollupCalculator {
    public RollupCalcEmptyMock() {
      super(0, Rollup.Op.LAST, null, null, null, null, null);
    }
  }
}
