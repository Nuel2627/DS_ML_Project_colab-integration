dm 'log;clear;output;clear;odsresults;clear';
options mprint nodate pageno=1;
%SYSMSTORECLEAR; 

libname Nhis "C:\Users\ea07407\OneDrive - Georgia Southern University\Fall 2024\Research 2024";


PROC IMPORT OUT= NHIS.NHIS04 
            DATAFILE= "C:\Users\ea07407\OneDrive - Georgia Southern University\Fall 2024\Research 2024\NHISO4.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;



%let macrodir = C:\Users\ea07407\OneDrive - Georgia Southern University\SAS\SAS macros\;/*path for the sas macros folder*/

%include "&macrodir.DESCRIPTIVE V15.sas";
%include "&macrodir.MULTIPLE_PHREG V20.sas";
%include "&macrodir.PHREG_SEL V22.sas";
%include "&macrodir.UNI_CAT V30.sas";
%include "&macrodir.UNI_PHREG V25.sas";
%include "&macrodir.PlSurvivalTemp V4.sas";
%include "&macrodir.KM_PLOT V22.sas";
%include "&macrodir.STD_DIFF V3.sas";
%include "&macrodir.CALC_PS V6.sas";
%include "&macrodir.GREEDMATCH V1.sas";
%include "&macrodir.SELECTION_DIAGRAM.sas";

Data NHIS.New;
set NHIS.NHIS04;
run;


COMMENT Load Original NHIS Data and Format file; 
LIBNAME  NHIS  "C:\Users\ea07407\OneDrive - Georgia Southern University\Fall 2024\Research 2024";

COMMENT Load all needed SAS macros; 
%include "C:\Users\ea07407\OneDrive - Georgia Southern University\SAS\SAS macros\Macro Library.sas";
* This SAS file lists all avaiable current version SAS macros, and you can complie them all at 
		one time so that they are ready whenever needed; 

COMMENT Set Up Working Directory that you will refer to save all output tables; 
%let dir = C:\Users\ea07407\OneDrive - Georgia Southern University\SAS\;

options msglevel=I;

proc contents data = NHIS.New;
run;

proc freq data=NHIS.New;
tables LACHRC20 LACHRC5;
run;


/*Step 1: Data Preparation*/

/*a. check the variables*/

TITLE 'Table 1. Descriptive Statistics for all original variables';
%DESCRIPTIVE(
	 DATASET=NHIS.New, 
     CLIST=  MORTSTAT 
             DODQTR
             DODYEAR
			 INTV_QRT


             SEX  
             RACERPI2
			 EDUC1
             CDCMSTAT 
             
             ORIGIN_I
			 REGION

			 SMKSTAT2
             ALCSTAT
             MODFREQW

            
             HYPEV
             CHDEV  
			 STREV
             CANEV   

			 INSLN
			 DIBPILL

			 MEDICARE
			 MEDICAID
			 PRIVATE
			 SCHIP
			 MILITARY
			 IHS

             SLEEP 
		    , 
     NLIST =AGE_P
			BMI
            
			 , 

	 Dictionary = F,
     OUTPATH=&dir, 
     FNAME=Table 1. Descriptive Statistics for all original variables,
	 DEBUG = F);

/*b. delete missing*/
*NB the cond and lab in the below statement are numbered. 
The total number of cond will be needed in the selection/exclusion diagram below;
data NHIS.New2;
   set NHIS.New; 
    /*Survival*/
	If MORTSTAT in ('.') then delete; 
    %let cond1 = %str(If MORTSTAT in ('.') then delete;);
	%let lab1 = %str(exclude Ineligible, under age 18);

    /*demographic*/
    If EDUC1 in ('96 Child under 5 years old' '97 Refused' '98 Not ascertained' '99 Don''t know' '.') then delete;
	%let cond2 = %str(If EDUC1 in ('96 Child under 5 years old' '97 Refused' '98 Not ascertained' '99 Don''t know' '.') then delete;); 
	%let lab2 = %str(exclude education child under 5 years old/refused/not ascetained/unknown);

    If CDCMSTAT in ('9 Unknown marital status' '.') then delete;
	%let cond3 = %str(If CDCMSTAT in ('9 Unknown marital status' '.') then delete;); 
	%let lab3 = %str(exclude martial stauts unknown);
	
	/*lifestyle*/
    If SMKSTAT2 in ('5 Smoker, current status unknown' '9 Unknown if ever smoked' '.') then delete;
	%let cond4 = %str(If SMKSTAT2 in ('5 Smoker, current status unknown' '9 Unknown if ever smoked' '.') then delete;); 
	%let lab4 = %str(exclude smoking unknown);

    If ALCSTAT in ('10 Drinking status unknown' '.') then delete;
	%let cond5 = %str(If ALCSTAT in ('10 Drinking status unknown' '.') then delete;); 
	%let lab5 = %str(exclude drinking status unknown);

    If MODFREQW in ('95 Never''96 Unable to do light or moderate activity''97 Refused' '98 Not ascertained' '99 Don''t know' '.') then delete;
	%let cond6 = %str(If MODFREQW in ('95 Never''96 Unable to do light or moderate activity''97 Refused' '98 Not ascertained' '99 Don''t know' '.') then delete;); 
	%let lab6 = %str(exclude Light/moderate activity refused/not ascetained/unknown);

	/*Cardiovascular disease*/
    If HYPEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond7 = %str( If HYPEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab7 = %str(exclude hypertension refused/not ascetained/unknown);

    If CHDEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If CHDEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude cornary heart disease refused/not ascetained/unknown);

	If MIEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If MIEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude heart attack disease refused/not ascetained/unknown);

	If STREV in ('7 Refused' '8' '9 Don''t know' '.') then delete;/*cancer? add it or not?*/
    %let cond10 = %str(If STREV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab10 = %str(exclude stroke refused/not ascetained/unknown);

	If ANGEV in ('7' '8' '9' '.') then delete;
    %let cond10 = %str(If ANGEV in ('7' '8' '9' '.') then delete;); 
	%let lab10= %str(exclude angina pectoris refused/not ascetained/unknown);

	/*Endocrine and coexisting*/

	If DIBEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If DIBEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude diabetes disease refused/not ascetained/unknown);

	If ULCEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If ULCEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude ulcer disease refused/not ascetained/unknown);

	If AHEP in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If AHEP in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude hepatitis disease refused/not ascetained/unknown);

	/*Respiratory Disease*/
	If AASMEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If AASMEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude asthma disease refused/not ascetained/unknown);

	If CBRCHYR in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If CBRCHYR in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude chronic bronchitis disease refused/not ascetained/unknown);

	If EPHEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If EPHEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude emphysema disease refused/not ascetained/unknown);

	/*Muskoskeletal diseases*/
	If ARTH1 in ('7 Refused' '8' '9 Don''t know' '.') then delete;
    %let cond8 = %str(If ARTH1 in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab8 = %str(exclude arthritis disease refused/not ascetained/unknown);

	If STREV in ('7 Refused' '8' '9 Don''t know' '.') then delete;/*stroke? add it or not?*/
    %let cond10 = %str(If STREV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab10 = %str(exclude stroke refused/not ascetained/unknown);
	
    /*Cancer*/
    If CANEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;/*cancer? add it or not?*/
    %let cond9 = %str(If CANEV in ('7 Refused' '8' '9 Don''t know' '.') then delete;); 
	%let lab9 = %str(exclude cancer refused/not ascetained/unknown);   


     /*sleep*/

    If SLEEP in ('97 Refused' '98 Not ascertained' '99 Don''t know' '.') then   delete;
	%let cond11 = %str(If SLEEP in ('97 Refused' '98 Not ascertained' '99 Don''t know' '.') then delete;); 
	%let lab11 = %str(exclude sleep refused/not ascetained/unknown);

   /*continuous*/

    If AGE_P in ('.') then  delete;
    %let cond12 = %str(If AGE_P in ('.') then delete;); 
	%let lab12 = %str(exclude AGE_P unknown);

    If BMI in ('99.99'  '.') then  delete;
    %let cond13 = %str(If BMI in ('99.99' '.') then delete;); 
	%let lab13 = %str(exclude BMI unknown);

run;
TITLE "Selection/Exclusion Diagram";
%SELECTION_DIAGRAM(DATASET=New, cancer=MORTSTAT,num_cond = 20, OUTPATH = &dir, 
				   FNAME = Table 2. Diagram of Study Population Selection);


/*c. check variabls after deleting missing*/
TITLE 'Table 3. Descriptive Statistics for variables after deleting missing';
%DESCRIPTIVE(
	 DATASET=NHIS.New2, 
     CLIST=  MORTSTAT 
             DODQTR
             DODYEAR
			 INTV_QRT


             SEX  
             RACERPI2
			 EDUC1
             CDCMSTAT 
             
             ORIGIN_I
			 REGION

			 SMKSTAT2 
             ALCSTAT
             MODFREQW

            
             HYPEV
             CHDEV  
			 STREV
             CANEV
			AASMEV
			ARTH1
			MIEV
			AHEP
			ULCEV
			DIBEV
			 
             SLEEP 
		    , 
     NLIST =AGE_P
			BMI
            
			 , 

	 Dictionary = F,
      OUTPATH=&dir, 
     FNAME=Table 3. Descriptive Statistics for variables after deleting missing,
	 DEBUG = F);



/*d. regroup variables/create formats*/
proc format ;
value racec         1='White' 2='Black/African American' 3 ='others';
value educationc    1='less than high school' 2='high school' 3='more than high school';
value Maritalc		1='Married' 2= 'Seperated/divorced/widowed' 3='Single/never married';


value smokec        1='current' 2='former' 3='never';
value drinkingc     1='current' 2='former' 3='never';
value activityc     1='never or unable to do light or moderate' 2='light or moderate';


value CARDIOc   	0='without heart disease history' 1='have heart disease history';
value RESPIc        1='Had been told have respiratory disease history' 2='Had not been told have respiratory disease history';
value CANEVc        1='Had been told have cancer' 2='Had not been told have cancer';
value COENDOc       1='Had been told have coexisting endocrine history' 2='Had not been told have coexisting endocrine history';
value MUSKOc		1='Had been told have muskoskeletal disease history' 2='Had not been told have muskoskeletal disease history';

value sleeptimec    1='1–4 h (short sleep)'  2='5-6 h'   3='7-8 h' 4='9h' 5='>=10 h (long sleep)';
value BMIc           1='Normal/Underweight' 2='Pre-Obese' 3='Obese';
value AGEc           1='<40'  2='40-<60' 3='>=60';
run;


/*e. Define Variables*/
data NHIS.New3;
  set NHIS.New2;
	if MORTSTAT = 1 then os_censor = 1;
    else if MORTSTAT = 0 then os_censor = 0;

	/*Define Total Survmonth from 2004.1*/

	if DODQTR='January-March' then Survmonth=3;
	else if DODQTR='April-June' then Survmonth=6;
	else if DODQTR='July-September' then Survmonth=9;
	else IF DODQTR='October-December' then Survmonth=12;
	else Survmonth=0;

	if DODYEAR=2004 then TotalSurvmonth=Survmonth;
	else if DODYEAR=2005 then TotalSurvmonth=Survmonth+12;
	else if DODYEAR=2006 then TotalSurvmonth=Survmonth+12*2;
	else if DODYEAR=2007 then TotalSurvmonth=Survmonth+12*3;
	else if DODYEAR=2008 then TotalSurvmonth=Survmonth+12*4;
	else if DODYEAR=2009 then TotalSurvmonth=Survmonth+12*5;
	else if DODYEAR=2010 then TotalSurvmonth=Survmonth+12*6;
	else if DODYEAR=2011 then TotalSurvmonth=Survmonth+12*7;
	else if DODYEAR=2012 then TotalSurvmonth=Survmonth+12*8;
	else if DODYEAR=2013 then TotalSurvmonth=Survmonth+12*9;
	else if DODYEAR=2014 then TotalSurvmonth=Survmonth+12*10;
	else if DODYEAR=2015 then TotalSurvmonth=Survmonth+12*11;
	else if DODYEAR=2016 then TotalSurvmonth=Survmonth+12*12;
	else if DODYEAR=2017 then TotalSurvmonth=Survmonth+12*13;
	else if DODYEAR=2018 then TotalSurvmonth=Survmonth+12*14;
	else if DODYEAR=2019 then TotalSurvmonth=Survmonth+12*15;
	else if DODYEAR=. then TotalSurvmonth = 12*16;
   
    if INTV_QRT='1 Quarter 1' then INTV_Month=3;
    else if INTV_QRT='2 Quarter 2' then INTV_Month=6;
    else if INTV_QRT='3 Quarter 3' then INTV_Month=9;
    else if INTV_QRT='4 Quarter 4' then INTV_Month=12;


    os = TotalSurvmonth- INTV_Month;
  	label os = "Overall Survival (Months)";


	/*race*/

	if RACERPI2= 1 then race_cat =1;     
	else if RACERPI2= 2 then race_cat = 2;
    else race_cat = 3;                
	Format race_cat racec.;

   	/*educ*/
 	if EDUC1 in ('00 Never attended/kindergarten only' '01 1st grade' '02 2nd grade' '03 3rd grade' '04 4th grade' 
	'05 5th grade' '06 6th grade' '07 7th grade' '08 8th grade' '09 9th grade' '10th grade' '11th grade' '12th grade, no diploma' 
    '96 Child under 5 years old') then education_cat =1;     /*<high school*/
	else if EDUC1 in ('13 GED or equivalent' '14 High School Graduate') then education_cat = 2;                         /*high school*/
    else if EDUC1 in ('15 Some college, no degree' '16 Associate degree: occupational, technical, or vocat' '17 Associate degree: academic program' 
    '18 Bachelor''s degree (Example: BA, AB, BS, BBA)' '19 Master''s degree (Example: MA, MS, MEng, MEd, MBA)' '20 Professional School degree (Example: MD, DDS, DVM,'
    '21 Doctoral degree (Example: PhD, EdD)') then education_cat = 3;                                                          /*>high school*/
	Format education_cat educationc.;

 /*marital status*/;
    if CDCMSTAT = '3 Married' then Marital = 1;      /*Married*/
    else if CDCMSTAT in('1 Separated' '2 Divorced' '5 Widowed') then Marital = 2;/*Seperated/divorced/widowed/*/
    else if CDCMSTAT ='4 Single/never married' then Marital = 3;  /*Single/never married*/
    Format Marital Maritalc.;

   /*smoking*/
    if SMKSTAT2=5 then smoke_cat = .;/*question?? smoker:current status unkown??*/
    else if SMKSTAT2 in ('1 Current every day smoker' '2 Current some day smoker') then smoke_cat =1;/*current */
    else if SMKSTAT2 ='3 Former smoker' then smoke_cat =2;      /*former*/
    else if SMKSTAT2 ='4 Never smoker' then smoke_cat =3;  /*never*/
    Format smoke_cat smokec.;

    /*Drinking*/
	if ALCSTAT=1 then drinking_cat =1;/*never*/
    else if ALCSTAT in ('02 Former infrequent' '03 Former regular' '04 Former, unknown frequency') then drinking_cat =2; /*former*/
    else if ALCSTAT in ('05 Current infrequent' '06 Current light' '07 Current moderate' '08 Current heavier' '09 Current drinker, frequency/level unknown') then drinking_cat =3;  /*current*/
	else if ALCSTAT in ('10 Drinking status unknown') then drinking_cat =.;
    Format drinking_cat drinkingc.;
    
	/*Light/moderate activity(times per wk)*/
	if MODFREQW in ('00 Less than once per week' '2' '3' '4' '5' '6' '7' '10' '14' '21' '28')then activity_cat=2;     /*light or moderate*/
	else if MODFREQW in('95 Never' '96 Unable to do light or moderate activity') then activity_cat=1;                    /*never or unable to do light or moderate*/
	Format activity_cat activityc.;

    /* Endocrine coexisting conditions */
    if DIBEV = ' ' AND ULCEV= ' ' and AHEP=' ' then Coendo_cat =.;         
    else if DIBEV = '1 Ye' and ULCEV='1 Ye' and AHEP='1 Ye' then Coendo_cat = 1;   /* Had been told have diabetes */
    else Coendo_cat = 2;                         /* Had not been told have diabetes */
    format Coendo_cat COENDOc.;

	 /* Check for missing values */
    if CHDEV = ' ' and ANGEV = ' ' and MIEV = ' ' and HYPEV= '' and STREV='' then Cardio_cat = .;
    /* Patients without history of diseases */
    else if CHDEV = '2 No' and ANGEV = '2 No' and MIEV = '2 No' and HYPEV='2 No' and STREV='2 No' then Cardio_cat = 0;
    /* All other cases: patients with history of diseases */
    else Cardio_cat = 1;
    format Cardio_cat CARDIOc.;

	  /* Respistory */
    if AASMEV= '' and CBRCHYR='' and EPHEV='' then Respi_cat =.;         
    else if AASMEV = '1 Ye' AND CBRCHYR='1 Ye' and EPHEV='1 Ye' then Respi_cat = 1;   /* Had been told have respitroy */
    else Respi_cat = 2;                         /* Had not been told have respitory */
    format Respi_cat RESPIc.;

	/*MUSKOSKELETAL*/
    if ARTH1='' then MUSKO_cat =.;         
    else if ARTH1 = '1 Yes' then MUSKO_cat = 1;   /* Had been told have Muskoskeletal history*/
    else MUSKO_cat = 2;                         /* Had not been told have Muskoskeletal history */
    format MUSKO_cat MUSKOc.;

    /* Cancer */
    if CANEV = '' then CANEV_cat = .;
    else if CANEV = '1 Yes' then CANEV_cat = 1;  /* Had been told have cancer */
    else CANEV_cat = 2;                         /* Had not been told have cancer */
    format CANEV_cat Canevc.;

    /*BMI*/;
	If BMI<25 then BMI_cat=1;/*Normal/Underweight*/
    else if BMI<=30 then BMI_cat=2;/*Overweight*/
    else if BMI>30 then BMI_cat=3;/*Underweight*/
	Format BMI_cat BMIc.;


	/*age*/
    if AGE_P<40 then AGE_cat=1;
	else if AGE_P<60 then AGE_cat=2;
    else AGE_cat=3;/*>=60*/
	Format AGE_cat AGEc.;
	
	/*sleep duration*/
    If SLEEP=. then sleeptime_cat=.;
	else If SLEEP in(1 2 3 4) then sleeptime_cat=1;  
	else if SLEEP in(5 6) then sleeptime_cat=2; 
	else if SLEEP in(7 8) then sleeptime_cat=3;  
	else if SLEEP in(9) then sleeptime_cat=4;  
	else sleeptime_cat=5;  
    Format sleeptime_cat sleeptimec.;

run;


proc freq data=NHIS.New3;
    tables Dibev AHEP ULCEV coendo_cat ;
run;

proc freq data=NHIS.New3;
table DODQTR os;
run;

proc contents data=NHIS.New3 order=varnum;
run;

/*f. subset data, as required. These variables were selected from literature*/

data NHIS.nEW4 (keep= os os_censor sleeptime_cat
SEX
             age_cat
			 Marital

             smoke_cat
             drinking_cat
             activity_cat
			 Cardio_cat
             Respi_cat
             Coendo_cat
			 Musko_cat
			 CANEV_cat
             
			 BMI_cat
			 race_cat age_p sleep age_CAT);
set NHIS.NEW3;
run;

/* Generate frequency table for individuals with cardiovascular conditions who survived */
proc freq data=nhis.new4;
    tables sleeptime_cat / missing;
    where cardio_cat = 1 and os_censor = 1;
run;


/* Generate frequency tables for multiple conditions with sleeptime_cat for individuals who survived */
proc freq data=nhis.new4;
    tables sleeptime_cat*(Cardio_cat Respi_cat Coendo_cat Musko_cat CANEV_cat) / missing;
    where os_censor = 1;
run;

proc freq data=NHIS.new4;
  tables os os_censor sleeptime_cat
SEX
             age_cat
			 Marital

             smoke_cat
             drinking_cat
             activity_cat
			 Cardio_cat
             Respi_cat
             Coendo_cat
			 Musko_cat
			 CANEV_cat
             
			 BMI_cat
			 race_cat sleep age_CAT;
run;


/*g. check variables*/
TITLE 'Table 4A. Descriptive Statistics for regroup variables';
%DESCRIPTIVE(
	 DATASET=NHIS.new3, 
     CLIST=  os_censor
	      
             sleeptime_cat
SEX
             age_cat
			 Marital

             smoke_cat
             drinking_cat
             activity_cat
			 Cardio_cat
             Respi_cat
             Coendo_cat
			 Musko_cat
			 CANEV_cat
             
			 BMI_cat
			 race_cat sleep age_CAT
		    , 
     NLIST =os
	        
			 , 

	 Dictionary = F,
     OUTPATH=&dir, 
     FNAME=Table 1A. Descriptive Statistics for regroup variables,
	 DEBUG = F);

proc contents data=NHIS.nhis04c;
run;

proc freq data = NHIS.new4;
tables SEX race_cat CHDEV_cat
			 HYPEV_cat         
			 CANEV_cat
             STREV_cat;
run;
/*Step 2: Analysis begins*/

/*a. model selection. using the variables from the literature, we fit our model usin elimination/selection method*/

proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates & Sleep time';
	class sleeptime_cat (Ref='7-8 h')
			SEX (ref='1 Male')
             			 
             Marital(ref='Married')
             smoke_cat(ref='never')
 		     drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')
             
			 Cardio_cat
             Respi_cat
             Coendo_cat
			 Musko_cat
			 CANEV_cat
             
			 Age_cat (Ref='<40')
             BMI_cat (Ref ='Normal/Underweight');
	model os* os_censor(0)= sleeptime_cat Cardio_cat
             Respi_cat
             Coendo_cat
			 Musko_cat
			 CANEV_cat SEX smoke_cat
             activity_cat
			 drinking_cat
 			 BMI_cat
			 age_cat/selection=backwards slstay=0.1;
	run;



/*Table 1: Baseline data of participants by Sleep time groups*/

*AGE;

%macro phreg(var);
ODS RTF FILE = "&dir.Table A2. describe categorical varibles= &var by sleeping time_cat.doc";

proc freq data=NHIS.new4;
table &var*sleeptime_cat/ CHISQ;
run;
ODS RTF CLOSE;
%mend;

%phreg(os_censor) 
%phreg(SEX) 
%phreg(education_cat) 
%phreg(Marital) 

%phreg(smoke_cat) 
%phreg(drinking_cat) 
%phreg(age_cat)  
%phreg(Cardio_cat)
%phreg(CANEV_cat)
%phreg( Respi_cat)
%phreg(Musko_cat)
%phreg(Coendo_cat)
%phreg(BMI_cat)  




%macro phreg(var);
ODS RTF FILE = "&dir. Table A4. describe continous varibles=&var by sleeping time_cat.doc";
proc means data=NHIS.new4;
   class age_cat;
   var &var;
run;
ODS RTF CLOSE;
%mend;
%phreg(os) 
%phreg(AGE_P)
%phreg(sleep) 


*RACE;


%macro phreg(var);
ODS RTF FILE = "&dir.Table R2. describe categorical varibles= &var by sleeping time_cat.doc";

proc freq data=NHIS.new4;
table &var*race_cat/ CHISQ;
run;
ODS RTF CLOSE;
%mend;

%phreg(SEX) 
%phreg(Marital) 

%phreg(smoke_cat) 
%phreg(drinking_cat) 
%phreg(activity_cat) 

%phreg(HisDisease_cat)  
%phreg(HYPEV_cat)
%phreg(CHDEV_cat)
%phreg(STREV_cat)
%phreg(CANEV_cat)

%phreg(ORIGIN_I) 
 
%phreg(BMI_cat)  


%macro phreg(var);
ODS RTF FILE = "&dir. Table A4. describe continous varibles=&var by sleeping time_cat.doc";
proc means data=NHIS.new4;
   class sleeptime_cat;
   var &var;
run;
ODS RTF CLOSE;
%mend;
%phreg(os) 
%phreg(AGE_P)
%phreg(sleep) 

%macro phreg(var);
ODS RTF FILE = "&dir. Table A4. describe continous varibles=&var by sleeping time_cat.doc";
proc means data=NHIS.new4;
   class sleeptime_cat;
   var &var;
run;
ODS RTF CLOSE;
%mend;
%phreg(AGE_P)




/* Table 2: Sleep duration and assumed number of deceased individuals by race*/

ODS RTF FILE = "&dir.Table A1. histogram for sleeptime vs Cardio group.doc";
proc freq data=NHIS.new4;
where os_censor=1;
tables sleeptime_cat*Cardio_cat/plots=freqplot(twoway=grouphorizontal)chisq;
format sleeptime_cat sleeptimec. Cardio_cat Cardioc.;
run;
ODS RTF CLOSE;




/* Table 3: Sleep duration and assumed number of deceased individuals by age*/

ODS RTF FILE = "&dir.Table A1. histogram for sleeptime vs Respiratory group.doc";
proc freq data=NHIS.new4;
where os_censor=1;
tables sleeptime_cat*Respi_cat/plots=freqplot(twoway=grouphorizontal)chisq;
format sleeptime_cat sleeptimec. Respi_cat Respic.;
run;
ODS RTF CLOSE;



/*Figure 1: Association between sleep duration and mortality in the general population*/

proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') ;
	model os* os_censor(0)= sleeptime_cat /rl;
run;
quit;

proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class Cardio_cat (ref = 'without heart disease history') ;
	model os* os_censor(0)= Cardio_cat /rl;
run;
quit;

/*Table 4: Sleep duration and mortality relationship by age group*/

*Model 1;

ODS RTF FILE = "&dir.Table A3. Unadjusted model.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') Cardio_cat (ref = 'without heart disease history');
	model os* os_censor(0)= sleeptime_cat|Cardio_cat/rl;
hazardratio  sleeptime_cat /diff=ref;
run;
quit;
ODS RTF CLOSE;

ODS RTF FILE = "&dir.Table A3. Unadjusted model for Respiratory.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') Respi_cat (ref = 'Had not been told have respiratory disease history');
	model os* os_censor(0)= sleeptime_cat|Respi_cat/rl;
hazardratio  sleeptime_cat /diff=ref;
run;
quit;
ODS RTF CLOSE;

ODS RTF FILE = "&dir.Table A3. Unadjusted model for Cancer.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') CANEV_cat (ref = 'Had not been told have cancer');
	model os* os_censor(0)= sleeptime_cat|CANEV_cat/rl;
hazardratio  sleeptime_cat /diff=ref;
run;
quit;
ODS RTF CLOSE;

ODS RTF FILE = "&dir.Table A3. Unadjusted model for Coexisting endocrine problems.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') Coendo_cat(ref = 'Had not been told have coexisting endocrine history');
	model os* os_censor(0)= sleeptime_cat|Coendo_cat/rl;
hazardratio  sleeptime_cat /diff=ref;
run;
quit;
ODS RTF CLOSE;

ODS RTF FILE = "&dir.Table A3. Unadjusted model for Muskoskeletal problems.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Unadjusted model';
	class sleeptime_cat (Ref='7-8 h') Musko_cat(ref = 'Had not been told have muskoskeletal disease history');
	model os* os_censor(0)= sleeptime_cat|Musko_cat/rl;
hazardratio  sleeptime_cat /diff=ref;
run;
quit;
ODS RTF CLOSE;

proc freq data=nhis.new4;
tables musko_cat;
run;

*Model 2 Other covariates excluding other diseases groups;
ODS RTF FILE = "&dir.Table A4. Model of sleep and Cardio with Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Cardio_cat
              BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Cardio_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
              BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 3 Including other disease groups;
ODS RTF FILE = "&dir.Table A4a. Model Including other diseases and Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   

			 BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Cardio_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   


			 BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 2 Respiratory Other covariates excluding other diseases groups;
ODS RTF FILE = "&dir.Table A4. Model of sleep and respiratory with Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Respi_cat
              BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Respi_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Respi_cat
              BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 3 Including other disease groups;
ODS RTF FILE = "&dir.Table A4a. Respiratory Model Including other diseases and Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Respi_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   

			 BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Respi_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   


			 BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;


	
*Model 2 Cancer covariates excluding other diseases groups;
ODS RTF FILE = "&dir.Table A4. Model of sleep and cancerSignificant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Canev_cat
              BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Canev_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Respi_cat
              BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 3 Including other disease groups;
ODS RTF FILE = "&dir.Table A4a. Respiratory Model Including other diseases and Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Respi_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   

			 BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|Canev_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   


			 BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

		
*Model 2 Cancer covariates excluding other diseases groups;
ODS RTF FILE = "&dir.Table A4. Model of sleep and coendo Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             coendo_cat
              BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|coendo_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             coendo_cat
              BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 3 Including other disease groups;
ODS RTF FILE = "&dir.Table A4a. coendo Model Including other diseases and Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Respi_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   

			 BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|coendo_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat   


			 BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;


			
*Model 2a Musculoskeletal covariates excluding other diseases groups;
ODS RTF FILE = "&dir.Table A4. Models of sleep and Musculoskeletal Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             musko_cat
              BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|musko_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             musko_cat
              BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;

*Model 3 Including other disease groups;
ODS RTF FILE = "&dir.Table A4a. Musculoskeletal Model Including other diseases and Significant Covariates.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             
			 Marital(ref='Married')

             smoke_cat(ref='never')
             drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             Respi_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat
			 musko_cat 

			 BMI_cat (ref='Normal/Underweight')
				Age_cat;
	model os* os_censor(0)= sleeptime_cat|musko_cat
SEX
             
			 Marital
			 age_cat

             smoke_cat
             drinking_cat
             activity_cat

             Cardio_cat
             Respi_cat 
			 Coendo_cat
             Canev_cat
			 musko_cat 


			 BMI_cat /rl;
 			 HAZARDRATIO sleeptime_cat / diff=ref;
	run;
	ODS RTF CLOSE;


*Model 3;
	ODS RTF FILE = "&dir.Table A5. Model with Significant Covariates & Disease History.doc";
proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates & History';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             race_cat
			 
             Marital(ref='Married')

             smoke_cat(ref='never')
			  drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             HYPEV_cat
             DIBEV_cat
			ULCEV_cat
			AHEP_cat
			ARTH1_cat
			AASMEV_cat
			 CANEV_cat
             STREV_cat   

			 Age_cat 
             BMI_cat
				HisDisease_cat;
	model os* os_censor(0)= sleeptime_cat|HisDisease_cat
SEX
             race_cat
			
             Marital

             smoke_cat
             activity_cat
			 drinking_cat

			Age_cat 
			hypev_cat
			CANEV_cat
             STREV_cat
			 DIBEV_cat
			ULCEV_cat
			AHEP_cat
			ARTH1_cat
			AASMEV_cat


			 BMI_cat/rl;
			 HAZARDRATIO sleeptime_cat/ diff=ref;
	run;
	ODS RTF CLOSE;

/*Table 5: Sleep duration and mortality relationship by race groups*/

*Model 1;

ODS RTF FILE = "&dir.Table R3. Unadjusted Model for Disease History.doc";
proc phreg data= NHIS.new4;
	Title 'Unadjusted Model';
	class sleeptime_cat (Ref='7-8 h') HisDisease_cat;
	model os* os_censor(0)= sleeptime_cat|HisDisease_cat /rl;
	hazardratio sleeptime_cat/diff=ref;
run;
	ODS RTF CLose;

	/*Table 6: Sleep duration and mortality relationship by Cancer*/

*Model 1;

ODS RTF FILE = "&dir.Table M3. Unadjusted Model for Cancer.doc";
proc phreg data= NHIS.new4;
	Title 'Unadjusted Model';
	class sleeptime_cat (Ref='7-8 h') CANEV_cat;
	model os* os_censor(0)= sleeptime_cat|CANEV_cat /rl;
	hazardratio sleeptime_cat/diff=ref;
run;
	ODS RTF CLose;
*Model 5;
	ODS RTF FILE = "&dir.Table M5. Model with Significant Covariates.doc";

proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
		class sleeptime_cat (Ref='7-8 h')
			
             HYPEV_cat
             HisDisease_cat 
			 CANEV_cat
             STREV_cat   
			 DIBEV_cat
			AHEP_cat
			
             BMI_cat
				race_cat;
	model os* os_censor(0)= sleeptime_cat| CANEV_cat
			
             HYPEV_cat
             HisDisease_cat 
			 CANEV_cat
             STREV_cat   
			 DIBEV_cat
			AHEP_cat
 
			 BMI_cat/ rl;
	  	HAZARDRATIO sleeptime_cat / diff=ref;
	run;
ODS RTF CLOSE;

*Model 2;
	ODS RTF FILE = "&dir.Table R4. Model with Significant Covariates.doc";

proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates';
		class sleeptime_cat (Ref='7-8 h')
			
             HYPEV_cat
             HisDisease_cat 
			 CANEV_cat
             STREV_cat   
			 DIBEV_cat
			AHEP_cat
			
             BMI_cat
				race_cat;
	model os* os_censor(0)= sleeptime_cat|HisDisease_cat
			
             HYPEV_cat
             HisDisease_cat 
			 CANEV_cat
             STREV_cat   
			 DIBEV_cat
			AHEP_cat
 
			 BMI_cat/ rl;
	  	HAZARDRATIO sleeptime_cat / diff=ref;
	run;
ODS RTF CLOSE;

*Model 3;
	ODS RTF FILE = "&dir.Table R5. Model with Significant Covariates & Cancer.doc";

proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates & Age';
	class sleeptime_cat (Ref='7-8 h')
			          
             HYPEV_cat
             HisDisease_cat 
			 CANEV_cat
             STREV_cat   
			 DIBEV_cat
			AHEP_cat 

             BMI_cat
				race_cat;
	model os* os_censor(0)= sleeptime_cat|CANEV_cat
			
             HYPEV_cat
             HisDisease_cat 
			 STREV_cat   
			 DIBEV_cat
			AHEP_cat
 
			 BMI_cat/ rl;
			HAZARDRATIO sleeptime_cat / diff=ref;
	run;
ODS RTF CLOSE;

/*Supplemental Table: fully adjusted model for the general population*/

proc phreg data= NHIS.new4 plots=survival;
Title 'Model with Significant Covariates & Race';
	class sleeptime_cat (Ref='7-8 h')
			SEX
             race_cat
             Marital(ref='Married')

             smoke_cat(ref='never')
			  drinking_cat(ref='never')
             activity_cat(ref='never or unable to do light or moderate')

             CHDEV_cat
			 HYPEV_cat
             
			 CANEV_cat
             STREV_cat   

			 ORIGIN_I 
			 Age_cat 
             BMI_cat
				HisDisease_cat;
	model os* os_censor(0)= sleeptime_cat
			 Age_cat
	         SEX
             race_cat
			
             Marital

             smoke_cat
             activity_cat
			 drinking_cat

			HisDisease_cat 
			hypev_cat
			CHDEV_cat

			 CANEV_cat
             STREV_cat

			 ORIGIN_I 
			 BMI_cat/rl;
			 HAZARDRATIO sleeptime_cat/ diff=ref;
	run;

	proc print data = NHIS.NEW2;
	var CANEV;
	where CANEV = '1';
	run;

	proc format;
value sleep 1= "1-4 h (short sleep)" 2="5-6 h" 4="9 h" 5=">=10 h (long sleep)";
run;

Data nhis.forest_t;
input Subgroup HRA CILA	CIUA;
format subgroup sleep.;
	HRCI = put (HRA, 4.2) || " (" || put(CILA, 4.2) || ", " || put(CIUA, 4.2) || ")";
	Squaresize = ((26915)/2184) * 12;
row = _n_;
cards;
   1 1.768 1.522 2.053
   2 1.042 0.974 1.115
   3 1.856 1.659 2.076
   4 2.794 2.515 3.104
   ;
run;

/*--Used for Subgroup labels in column 1--*/ 
data nhis.anno_t; 
 set nhis.forest_t(keep=row subgroup rename=(row=y1));
retain Function 'Text ' ID 'id1' X1Space 'DataPercent' 
 Y1Space 'DataValue ' x1 x2 2 TextSize 7 Width 100 Anchor 'Left ';
run;

data nhis.forest_t2(drop=flag);
 set nhis.forest_t nobs=nobs;
 Head = not indent;
 retain flag 0;
 if head then flag = mod(flag + 1, 2);
 if flag then ref=row;
run;

/*--Define template for Forest Plot--*/
/*--Template uses a Layout Lattice of 8 columns--*/
proc template;
define statgraph nhis.Forest;
dynamic /*_show_bands*/ _color _thk;
begingraph;
discreteattrmap name='text';
value '1' / textattrs=(weight=bold); value 'other' / textattrs=(size=8) ;
enddiscreteattrmap;
discreteattrvar attrvar=type var=head attrmap='text';
layout lattice / columns=3 columnweights=(0.10 0.10 0.20);
/*--Column headers--*/
sidebar / align=top;
layout lattice / rows=1 columns=3 columnweights=(0.10 0.10 0.20);
entry textattrs=(size=8) halign=left "Sleep Duration*";
entry textattrs=(size=8) halign=left "HR (95% CI)**";
endlayout;
endsidebar;
/*--First column, shows only the Y2 axis--*/
layout overlay / walldisplay=none xaxisopts=(display=none) 
yaxisopts=(reverse=true display=none tickvalueattrs=(weight=bold));
annotate / id='id1';
referenceline y=ref / lineattrs=(thickness=_thk color=_color);
axistable y=row value=subgroup / display=(values) textgroup=type;
endlayout;
/*--Second column showing PCIGroup--*/
layout overlay / x2axisopts=(display=none) 
yaxisopts=(reverse=true display=none) walldisplay=none;
referenceline y=ref / lineattrs=(thickness=_thk color=_color);
axistable y=row value= HRCI / display=(values);
endlayout;
/*--Third column showing Hazard ratio graph with 95% error bars--*/
layout overlay / xaxisopts=(type=log label=' ' labelattrs=(size=10)
logopts=(tickvaluepriority=true tickvaluelist=(0.5 1.0 1.5 2.0 2.5 3.0 3.5)))
yaxisopts=(reverse=true display=none) walldisplay=none;
annotate / id='id2';
referenceline y=ref / lineattrs=(thickness=_thk color=_color);
scatterplot y=row x=HRA / xerrorlower=CILA xerrorupper=CIUA 
sizeresponse=SquareSize sizemin=4 sizemax=12
markerattrs=(symbol=squarefilled);
referenceline x=1;
endlayout;
endlayout;
entryfootnote halign=left textattrs=(size=7) 
'* Reference category= 7-8 h';
entryfootnote halign=left textattrs=(size=7) 
'** Unadjusted Model';
endgraph;
end;
run;


/* Define image dimensions */
%let w=550;  %let h=250;

ods html close;
ods listing gpath="C:\Users\ea07407\OneDrive - Georgia Southern University\SAS\" image_dpi=300;
ods graphics / reset noscale IMAGEFMT=PNG width=&w height=&h imagename='Forest';

proc sgrender data=nhis.Forest_t2 template=nhis.Forest sganno=nhis.anno_t;
dynamic _color='white' _thk=12; 
format subgroup sleep.;
run;


