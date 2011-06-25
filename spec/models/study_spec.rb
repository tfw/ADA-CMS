require 'spec_helper'

describe Study, "The local respresentation of an ASSDA study" do
  
  context "integrating via ActiveRecord to the Nesstar mysql db" do
    
    it "should take a hash of attributes, underscore the keys, and create a study" do
      study = Study.create_or_update_from_nesstar(data)
      study.should_not be_nil
      debugger
      study.abstract_text.should == data[:abstractText]
    end

    it "should take a hash of attributes, underscore the keys, and update an existing study" do
      study = Study.create_or_update_from_nesstar(data)
      study.should_not be_nil
      study.abstract_text.should == data[:abstractText]
      data[:abstractText] = "foo"
      study = Study.create_or_update_from_nesstar(data)
      study.abstract_text.should == "foo"
    end
    
    def data
       {"abstractText"=>"This is the first wave in a series of six surveys conducted monthly from July to December 1974 commissioned by 'The Age' and undertaken by Australian Sales Research Bureau Pty. Ltd., with the cooperation of the Political Science Department of the Melbourne University. The purpose of the survey was to investigate respondent's attitudes toward the economic and political systems. \n\nThe main variables included voting preferences in the previous federal election, attitudes toward party leader's popularity, and voting intentions in the next federal election.\n\nBackground variables of respondents  include age, sex, place of birth, marital status, location, demographic, occupation, income, education, religious affiliation, telephone renting and self-rated social class.",
        "accessConditions"=>nil, "accessPlace"=>nil, "analyticUnit"=>"Individual", "availability"=>nil, "collMode"=>"Oral Interview", "collectionEnd"=>nil, 
        "collectionStart"=>nil, "comment"=>"This is the first wave in a series of six surveys conducted monthly from July to December 1974 commissioned by 'The Age' and undertaken by Australian Sales Research Bureau Pty. Ltd., with the cooperation of the Political Science Department of the Melbourne University. The purpose of the survey was to investigate respondent's attitudes toward the economic and political systems. \n\nThe main variables included voting preferences in the previous federal election, attitudes toward party leader's popularity, and voting intentions in the next federal election.\n\nBackground variables of respondents  include age, sex, place of birth, marital status, location, demographic, occupation, income, education, religious affiliation, telephone renting and self-rated social class.",
        "dataCollector"=>"Australian Sales Research Bureau", "dataKind"=>"Survey", "distributionDate"=>nil, "distributor"=>nil, "docAltTitl"=>nil, "docAuthEntity"=>nil, "docBiblCit"=>"Irving Saulwick and Associates. Age Poll, Wave 1, 1974. [Computer File]. Canberra: Australian Data Archive, The Australian National University, 2004.", "docBiblCitFormat"=>nil, "docCopyright"=>"Copyright 2008, The Australian National University. All rights reserved.", "docDistDate"=>nil, "docDistributor"=>nil, "docEngTitle"=>nil, "docLang"=>nil, 
        "docProducer"=>"Australian Data Archive", "docSubTitl"=>nil, "docTitle"=>"Age Poll, July 1974", "engAbstract"=>nil, "engWeight"=>"The responses are unweighted.", "externalId"=>"au.edu.anu.ada.ddi.00001", "geographicalCover"=>"National", "geographicalUnit"=>"Federal metropolitan and non-metropolitan electorates", "id"=>"au.edu.anu.ada.ddi.00001", "keywords"=>"Attitudes;Economic conditions;Political parties;Politicians;Politics;Economics;Elections;Trade unions;Lobbying;Social conditions", "label"=>"Age Poll, July 1974", "language"=>"en", 
        "limitations"=>nil, "methodNotes"=>nil, "nation"=>"Australia", "pDFFile"=>nil, "periodEnd"=>nil, "periodStart"=>nil, "researchInstr"=>"Structured", "response"=>nil, "sampling"=>"area - cluster sample\n\nThe sampling procedure, firstly,  involved the selection from the electoral roll of 13 starting points in each metropolitan electorate and 12starting points in each non-metropolitan electorate. Second, two interviews were performed per starting point, with only one interview per dwelling. Third, the interview was conducted with the youngest adult over the age of 18 available, subject to a sex quota of one male:one female at each starting point. \n\nThere were 1,963 survey respondents, the target sample size was 2012 respondents.", 
        "scheduleCatalogID"=>nil, "scheduleDate"=>nil, "scheduleEmailText"=>nil, "seriesID"=>nil, "seriesName"=>"Age Poll", "site"=>nil, "source"=>nil, "stdyAltTitl"=>nil, "stdyAuthEntity"=>"Irving Saulwick and Associates", 
        "stdyBiblCit"=>"Irving Saulwick and Associates. Age Poll, Wave 1, 1974. [Computer File]. Canberra: Australian Data Archive, The Australian National University, 2004.", "stdyClass"=>"Level 2", "stdyContact"=>"Department of Political Science University of Melbourne Parkville, VIC 3052", "stdyContactAffiliation"=>"Department of Political Science, University of Melbourne", "stdyContactEmail"=>nil, "stdyContributor"=>nil, "stdyCopyright"=>"Copyright 1974-2004, University of Melbourne. All rights reserved.", "stdyDataAppraisal"=>nil, "stdyDataCollFreq"=>nil, 
        "stdyDepositor"=>"Department of Political Science University of Melbourne Parkville, VIC 3052", "stdyEngTitle"=>nil, "stdyID"=>"au.edu.anu.ada.ddi.00001", "stdyLang"=>nil, "stdyParTitl"=>nil, "stdyProdAgency"=>nil, "stdyProducer"=>"The Age", "stdyProducerAbbr"=>nil, "stdyStatus"=>"Level 2", "stdySubTitl"=>nil, "stdyVersion"=>"Version 2. 26 August, 2004.", "stdyVersionNotes"=>nil, "stdyVersionResponsibility"=>"Australian Data Archive", "stdyVersionType"=>nil, "subStudy"=>false, "subcat"=>"Australian studies;Poll;1970 - 79", "timeMeth"=>"Trend Study (6 waves)", "title"=>"Age Poll, July 1974", "universe"=>"The universe sample for this survey constituted adults over the age of 18 in 80 federal electorates -  46 metropolitan (including the ACT) electorates and 34 nonmetropolitan electorates.", 
        "weight"=>"The responses are unweighted."} 
      end
  end
  
 it "should validate the presence of a label and a ddi_id" do
   study = Study.new()
   study.valid?.should == false
   
   study.stdy_id = "au.edu.anu.ada.ddi.00154"
   study.valid?.should == true
 end
 
 it "should offer an abbreviated form of the label" do
   study = Study.make(:label => " 1 2 3 4 5 6 7 8")
   shortened_label = study.friendly_label
   shortened_label.split(/\W/).size.should eql 9
 end
 
 specify "that for_archive(archive) returns a matching archive_study" do
   archive_study = ArchiveStudy.make
   archive = archive_study.archive
   study = archive_study.study
   [1..9].each {ArchiveStudy.make(:study => study)} #make loads of them with the same study
   
   study.for_archive(archive).should == archive_study
 end
end
