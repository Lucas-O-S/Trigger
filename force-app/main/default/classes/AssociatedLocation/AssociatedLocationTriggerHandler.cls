public with sharing class AssociatedLocationTriggerHandler {
    private static Boolean isEnabled;
    static{
        isEnabled=true;
    }

    public static Boolean IsTriggerEnabled(){
        return isEnabled;
    }

    public static Boolean DisableTrigger(){
        return isEnabled = false;
    }

    public static Boolean EnableTrigger(){
        return isEnabled = true;
    }

    List<AssociatedLocation> oldRecordList { get; set; }
	List<AssociatedLocation> newRecordList { get; set; }
	Map<Id, AssociatedLocation> oldRecordMap { get; set; }
	Map<Id, AssociatedLocation> newRecordMap { get; set; }
    
    public AssociatedLocationTriggerHandler(
		List<AssociatedLocation> oldRecordList,
		List<AssociatedLocation> newRecordList,
		Map<Id, AssociatedLocation> oldRecordMap,
		Map<Id, AssociatedLocation> newRecordMap
	) 
    {
		this.oldRecordList = oldRecordList;
		this.newRecordList = newRecordList;
		this.oldRecordMap = oldRecordMap;
		this.newRecordMap = newRecordMap;
	}

    public void AfterInsert() {
        AssociatedLocationTriggerHelper.handleInsertAccountTeamMember(newRecordList);
    }


    public void AfterUpdate() {
        // lógica para after update
    }


    public void AfterDelete() {
        AssociatedLocationTriggerHelper.handleDeleteTeamMenber(oldRecordList);
    }


}

