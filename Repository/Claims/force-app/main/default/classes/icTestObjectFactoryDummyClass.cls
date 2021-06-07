@isTest
public class icTestObjectFactoryDummyClass implements icIClass {

	public Object GetInstance()
	{
		return new Impl();
	}

	public Interface IClass { }

	public class Impl implements IClass { }
}