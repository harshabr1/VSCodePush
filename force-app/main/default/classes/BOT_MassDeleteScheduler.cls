/*
Name			: BOT_MassDeleteScheduler
Created By		: Sreenivasulu A
Created Date	: 28-MAR-2019
Overview		: This class is written by BusinessOne Technologies Inc. It is used to schedule the Delted All feature on BOT_Mass_Delete Page.
*/
global class BOT_MassDeleteScheduler implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        BOT_MassDeleteCtrl clsMassDeleteCtrl = new BOT_MassDeleteCtrl();
        clsMassDeleteCtrl.deleteAll();
        clsMassDeleteCtrl.deleteCoveragePolicy();
    }
}