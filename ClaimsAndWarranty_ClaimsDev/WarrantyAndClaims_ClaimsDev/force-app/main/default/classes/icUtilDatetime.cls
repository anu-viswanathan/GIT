public class icUtilDatetime {

	public static Datetime getLocalDateTime(Datetime inputDT) {
		Datetime outputDT = inputDT.Date();
		outputDT = outputDT.addHours(inputDT.hour());
		outputDT = outputDT.addMinutes(inputDT.minute());
		outputDT = outputDT.addSeconds(inputDT.second());
		return outputDT;
	}
}