trigger DealReviewHandlerClass on Opportunity (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        DealReviewHandlerClass.DealReview(trigger.new, trigger.oldMap);
    }
}