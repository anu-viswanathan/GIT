global class icScheduleLMSTrainingsCRC implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
      Database.executeBatch(new LearningTracAssignmentBatchCRC(), LearningTracAssignmentBatchCRC.batchChunkSize);
    }
}