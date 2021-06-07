global class icScheduleLMSTrainings implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
      Database.executeBatch(new LearningTracAssignmentBatch(), LearningTracAssignmentBatch.batchChunkSize);
    }
}