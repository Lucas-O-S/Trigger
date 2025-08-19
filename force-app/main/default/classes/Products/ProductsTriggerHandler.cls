public with sharing class ProductsTriggerHandler implements TriggerHandler {

    public void beforeInsert(List<Product2> newList) {

    }

    public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
      
    }

    public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
        // lógica para after update
    }

    public void beforeDelete(List<SObject> oldList) {
        // lógica para before delete
    }

    public void afterDelete(List<SObject> oldList) {
        // lógica para after delete
    }

    public void afterInsert(List<Product2> newList) {
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        List<CurrencyType> currencies = [
            SELECT IsoCode 
            FROM CurrencyType 
            WHERE IsActive = true
        ];
        Pricebook2 standardPriceBook = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1];

        for(Product2 iProdudct : newList){
            for(CurrencyType iCurrency: currencies ){
                PricebookEntry temp = new PricebookEntry(Product2Id=iProdudct.Id,
                    Pricebook2Id=standardPriceBook.Id,
                    CurrencyIsoCode=iCurrency.IsoCode,
                    UnitPrice=0,
                    IsActive = true
                );
                priceBookEntries.add(temp);
            }
        }
        if(!priceBookEntries.isEmpty()){
            Insert priceBookEntries;

        }
    }
}