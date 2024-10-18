public with sharing class Scenario12 {
    /* automates linking candidate and skills records. it should read skills in a text area field on Candidate, match them with existing skills and conect them using a junction object called Candidate skill. ALso, if a skill doesn't exist then create the skill before establishing the connection */
    public static void candidateJuncObject(List<Candidate__c> candList) {
        //map to store skills and name
        Map<String, Skills__c> skillMap = new Map<String, Skills__c>();

        //Map for candidate and skills
        Map<String, Candidate__c> candidateSkillsMap = new Map<String, Candidate__c>();

        List<Candidate_Skill__c> csToInsert = new List<Candidate_Skill__c>();

        List<Skills__c> skillsInsert = new List<Skills__c>();

        for(Skills__c existingskill : [Select Id, Name From Skills__c]){
            skillMap.put(existingskill.Name, existingskill);
        }
        if(!candList.isEmpty()){
            for(Candidate__c cand : candList){
                string[] skillNames = cand.Skill_Set__c.split(',');
                for (String skilname : skillNames){
                    if(!candidateSkillsMap.containsKey(skilname)){
                        candidateSkillsMap.put(skilname, cand);
                    }
                }
            }
            for(String skill : candidateSkillsMap.keyset()){
                if(skillMap.containsKey(skill)){
                    Candidate_Skill__c cs = new Candidate_Skill__c();
                    cs.Candidate__c = candidateSkillsMap.get(skill).Id;
                    cs.Name = skill;
                    cs.Skill__c = skillMap.get(skill).Id;
                    csToInsert.add(cs);
                }else{
                    Skills__c skc = new Skills__c(Name = skill);
                    skillsInsert.add(skc);
                }
            }

            if(!skillsInsert.isEmpty()){
                insert skillsInsert;

                for(Skills__c sk : skillsInsert){ 
                    Candidate_Skill__c cs = new Candidate_Skill__c();
                    cs.Candidate__c = candidateSkillsMap.get(sk.Name).Id;
                    cs.Name = sk.Name;
                    cs.Skill__c = sk.Id;

                    csToInsert.add(cs);
                }
            }

            if(!csToInsert.isEmpty()){
                insert csToInsert;
            }
        }  
    }
}