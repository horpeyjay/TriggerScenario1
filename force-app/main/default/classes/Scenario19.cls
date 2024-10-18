public with sharing class Scenario19 {
    /* validate the offer price based on the offer type. it should ensure that when a product has offer available, the appropriate discount is provided and valid. for each offer type, the discount must be specified and the price must be calculated based on the original price and discount provided */
    public static void preventProduct(List<Product__c> newProductsList) {

        if(!newProductsList.isEmpty()){
            for(Product__c p : newProductsList){
                if (p.Offer_Available__c == true){
                    if (p.Offer_Type__c == 'Flat'){
                        if(p.Flat_Discount__c== null){
                            p.Flat_Discount__c.addError('Please enter the flat discount amount');
                        }else if(p.Flat_Discount__c < 0){
                            p.Flat_Discount__c.addError('Flat Discount must be greater than 0');
                        }else{
                            p.Offer_Price__c = p.Original_Price__c - p.Flat_Discount__c;
                        }
                    }else if(p.Offer_Type__c == 'Percentage'){
                        if(p.Percentage_Discount__c == null){
                            p.Percentage_Discount__c.addError('Please enter the percentage discount');
                        }else if(p.Percentage_Discount__c < 0){
                            p.Percentage_Discount__c.addError('Enter a positive value for the discount');
                        }else{
                            p.Offer_Price__c = p.Original_Price__c - (p.Original_Price__c * p.Percentage__c /100);
                        }
                    }
                }else{
                    p.Offer_Available__c.addError('The offer available checkbox must be checked');
                }
            }
        }

    }
}