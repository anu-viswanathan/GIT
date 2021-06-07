@isTest
public class icTestObjectFactory {

	private static Object instantiatorReturn = new DummyMock();

	private class DummyMock implements icTestObjectFactoryDummyClass.IClass { }
	private class DummyMockInstantiator implements icObjectFactory.IMockCreator
	{
		public Object CreateMockInstance(String className)
		{
			return instantiatorReturn;
		}
	}

	@isTest
	private static void GetSingletonInstance_getsInstanceByClassName()
	{
		icTestObjectFactoryDummyClass.IClass instance =
			(icTestObjectFactoryDummyClass.IClass) icObjectFactory.GetSingletonInstance('icTestObjectFactoryDummyClass');
		System.assertNotEquals(null, instance);
	}

	@isTest
	private static void GetSingletonInstance_alwaysReturnsTheSameInstance()
	{
		icTestObjectFactoryDummyClass.IClass instanceOne =
			(icTestObjectFactoryDummyClass.IClass) icObjectFactory.GetSingletonInstance('icTestObjectFactoryDummyClass');
		icTestObjectFactoryDummyClass.IClass instanceTwo =
			(icTestObjectFactoryDummyClass.IClass) icObjectFactory.GetSingletonInstance('icTestObjectFactoryDummyClass');
		System.assertEquals(instanceOne, instanceTwo);
	}

	@isTest
	private static void GetInstance_returnsANewInstanceEachTime()
	{
		icTestObjectFactoryDummyClass.IClass instanceOne =
			(icTestObjectFactoryDummyClass.IClass) icObjectFactory.GetInstance('icTestObjectFactoryDummyClass');
		icTestObjectFactoryDummyClass.IClass instanceTwo =
			(icTestObjectFactoryDummyClass.IClass) icObjectFactory.GetInstance('icTestObjectFactoryDummyClass');
		System.assertNotEquals(instanceOne, instanceTwo);
	}

	@isTest
	private static void MockSingletonInstance_correctlySetsMock()
	{
		DummyMock mock = new DummyMock();
		icObjectFactory.MockSingletonInstance('DummyClass', mock);

		System.assertEquals(mock, icObjectFactory.getSingletonInstance('DummyClass'));
	}

	@isTest
	private static void SetMockInstantiator_futureInstancesAreCreatedByInstantiator()
	{
		icObjectFactory.SetMockInstantiator(new DummyMockInstantiator());

		System.assertEquals(instantiatorReturn, icObjectFactory.getInstance('test'));
	}

	@isTest
	private static void ResetFactory_clearsSetMocks()
	{
		DummyMock mock = new DummyMock();
		icObjectFactory.MockSingletonInstance('DummyClass', mock);
		System.assert(icObjectFactory.globalObjects.containsKey('DummyClass'));

		icObjectFactory.ResetFactory();

		System.assert(!icObjectFactory.globalObjects.containsKey('DummyClass'));
	}
}