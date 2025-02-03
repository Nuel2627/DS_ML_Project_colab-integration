

data St_Joseph;
input Disease $ Gender $ Mortality;
datalines;
AMI	Female 5
AMI	Male 12
COPD Female 9
COPD Male 2
CABG Female	0
CABG Male 2
Heart Female 14
Heart Male 17
Pneumonia Female 8
Pneumonia Male 23
Sepsis Female 64
Sepsis Male	93
Stroke Female 13
Stroke Male 12
;
run;


/*a. Descriptive statistics */
proc means data=finaldata;
  var Measurement;
  class Age Sex;
run;



proc glm data=St_Joseph;
class Disease Gender;
Model Mortality = Disease Gender Disease*Gender/solution;
lsmeans Disease Gender; 
run;


/* Define the dataset with Disease, Gender, and Mortality */
data St_Joseph;
input Disease $ Gender $ Mortality;
datalines;
AMI Female 5
AMI Male 12
COPD Female 9
COPD Male 2
CABG Female 0
CABG Male 2
Heart Female 14
Heart Male 17
Pneumonia Female 8
Pneumonia Male 23
Sepsis Female 64
Sepsis Male 93
Stroke Female 13
Stroke Male 12
;
run;

/* Perform ANOVA using PROC GLM */
proc glm data=St_Joseph;
class Disease Gender;
model Mortality = Disease Gender / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Disease Gender / stderr cl;
lsmeans Gender / pdiff adjust=tukey cl;
lsmeans Disease / pdiff adjust=tukey cl;
run;

data Overall_Mortality;
input Disease $	Age_Group $	Facility_Age $	Mortality_by_Age;
datalines;
AMI	18-20	St_Joseph	0
AMI	21-30	St_Joseph	0
AMI	31-40	St_Joseph	0
AMI	41-50	St_Joseph	0
AMI	51-60	St_Joseph	2
AMI	61-70	St_Joseph	4
AMI	71-80	St_Joseph	8
AMI	80+	St_Joseph	3
COPD	18-20	St_Joseph	0
COPD	21-30	St_Joseph	0
COPD	31-40	St_Joseph	1
COPD	41-50	St_Joseph	0
COPD	51-60	St_Joseph	1
COPD	61-70	St_Joseph	4
COPD	71-80	St_Joseph	2
COPD	80+	St_Joseph	3
CABG	18-20	St_Joseph	0
CABG	21-30	St_Joseph	0
CABG	31-40	St_Joseph	0
CABG	41-50	St_Joseph	0
CABG	51-60	St_Joseph	0
CABG	61-70	St_Joseph	1
CABG	71-80	St_Joseph	1
CABG	80+	St_Joseph	0
Heart_Failure	18-20	St_Joseph	0
Heart_Failure	21-30	St_Joseph	1
Heart_Failure	31-40	St_Joseph	0
Heart_Failure	41-50	St_Joseph	0
Heart_Failure	51-60	St_Joseph	3
Heart_Failure	61-70	St_Joseph	6
Heart_Failure	71-80	St_Joseph	11
Heart_Failure	80+	St_Joseph	10
Pneumonia	18-20	St_Joseph	0
Pneumonia	21-30	St_Joseph	0
Pneumonia	31-40	St_Joseph	1
Pneumonia	41-50	St_Joseph	3
Pneumonia	51-60	St_Joseph	1
Pneumonia	61-70	St_Joseph	7
Pneumonia	71-80	St_Joseph	10
Pneumonia	80+	St_Joseph	9
Severe_Sepsis	18-20	St_Joseph	0
Severe_Sepsis	21-30	St_Joseph	2
Severe_Sepsis	31-40	St_Joseph	2
Severe_Sepsis	41-50	St_Joseph	9
Severe_Sepsis	51-60	St_Joseph	14
Severe_Sepsis	61-70	St_Joseph	42
Severe_Sepsis	71-80	St_Joseph	53
Severe_Sepsis	81+	St_Joseph	35
Stroke	18-20	St_Joseph	0
Stroke	21-30	St_Joseph	1
Stroke	31-40	St_Joseph	1
Stroke	41-50	St_Joseph	2
Stroke	51-60	St_Joseph	7
Stroke	61-70	St_Joseph	6
Stroke	71-80	St_Joseph	5
Stroke	80+	St_Joseph	3
AMI	18-20	Candler	0
AMI	21-30	Candler	0
AMI	31-40	Candler	0
AMI	41-50	Candler	0
AMI	51-60	Candler	0
AMI	61-70	Candler	0
AMI	71-80	Candler	0
AMI	80+	Candler	1
COPD	18-20	Candler	0
COPD	21-30	Candler	0
COPD	31-40	Candler	0
COPD	41-50	Candler	0
COPD	51-60	Candler	0
COPD	61-70	Candler	2
COPD	71-80	Candler	0
COPD	80+	Candler	1
CABG	18-20	Candler	0
CABG	21-30	Candler	0
CABG	31-40	Candler	0
CABG	41-50	Candler	0
CABG	51-60	Candler	0
CABG	61-70	Candler	0
CABG	71-80	Candler	0
CABG	80+	Candler	0
Heart_Failure	18-20	Candler	0
Heart_Failure	21-30	Candler	0
Heart_Failure	31-40	Candler	0
Heart_Failure	41-50	Candler	0
Heart_Failure	51-60	Candler	0
Heart_Failure	61-70	Candler	3
Heart_Failure	71-80	Candler	4
Heart_Failure	80+	Candler	4
Pneumonia	18-20	Candler	0
Pneumonia	21-30	Candler	0
Pneumonia	31-40	Candler	0
Pneumonia	41-50	Candler	1
Pneumonia	51-60	Candler	5
Pneumonia	61-70	Candler	11
Pneumonia	71-80	Candler	12
Pneumonia	80+	Candler	3
Severe_Sepsis	18-20	Candler	1
Severe_Sepsis	21-30	Candler	0
Severe_Sepsis	31-40	Candler	5
Severe_Sepsis	41-50	Candler	4
Severe_Sepsis	51-60	Candler	23
Severe_Sepsis	61-70	Candler	40
Severe_Sepsis	71-80	Candler	51
Severe_Sepsis	81+	Candler	24
Stroke	18-20	Candler	0
Stroke	21-30	Candler	0
Stroke	31-40	Candler	0
Stroke	41-50	Candler	0
Stroke	51-60	Candler	0
Stroke	61-70	Candler	0
Stroke	71-80	Candler	0
Stroke	80+	Candler	0
;
run;


/*a. Descriptive statistics */
proc means data=Overall_Mortality;
  var Mortality_by_Age;
  class Disease 	Age_Group 	Facility_Age;
  run;

  /*Test of effect of Diseases on Mortality*/
  proc glm data=Overall_Mortality;
class Disease 	Age_Group 	Facility_Age;
model Mortality_by_Age = Disease 	Age_Group 	Facility_Age / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Disease 	Age_Group 	Facility_Age / stderr cl;
run;


data Overall;
input Disease $	Age $	St_JosephMortality	Candler_Mortality;
datalines;
AMI	18-20	0	0
AMI	21-30	0	0
AMI	31-40	0	0
AMI	41-50	0	0
AMI	51-60	2	0
AMI	61-70	4	0
AMI	71-80	8	0
AMI	80+	3	1
COPD	18-20	0	0
COPD	21-30	0	0
COPD	31-40	1	0
COPD	41-50	0	0
COPD	51-60	1	0
COPD	61-70	4	2
COPD	71-80	2	0
COPD	80+	3	1
CABG	18-20	0	0
CABG	21-30	0	0
CABG	31-40	0	0
CABG	41-50	0	0
CABG	51-60	0	0
CABG	61-70	1	0
CABG	71-80	1	0
CABG	80+	0	0
Heart_Failure	18-20	0	0
Heart_Failure	21-30	1	0
Heart_Failure	31-40	0	0
Heart_Failure	41-50	0	0
Heart_Failure	51-60	3	0
Heart_Failure	61-70	6	3
Heart_Failure	71-80	11	4
Heart_Failure	80+	10	4
Pneumonia	18-20	0	0
Pneumonia	21-30	0	0
Pneumonia	31-40	1	0
Pneumonia	41-50	3	1
Pneumonia	51-60	1	5
Pneumonia	61-70	7	11
Pneumonia	71-80	10	12
Pneumonia	80+	9	3
Severe_Sepsis	18-20	0	1
Severe_Sepsis	21-30	2	0
Severe_Sepsis	31-40	2	5
Severe_Sepsis	41-50	9	4
Severe_Sepsis	51-60	14	23
Severe_Sepsis	61-70	42	40
Severe_Sepsis	71-80	53	51
Severe_Sepsis	81+	35	24
Stroke	18-20	0	0
Stroke	21-30	1	0
Stroke	31-40	1	3
Stroke	41-50	2	10
Stroke	51-60	7	24
Stroke	61-70	6	42
Stroke	71-80	5	27
Stroke	80+	3	26
;
run;

/*a. Descriptive statistics */
proc means data=Overall;
  var St_JosephMortality	Candler_Mortality;
  class Disease	Age;
  run;

  /*Test of effect of Age and Diseases on Mortality*/
proc glm data=Overall;
class Disease (ref='AMI') Age (ref='18-20');
model St_JosephMortality	Candler_Mortality = Disease Age / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Disease Age / stderr cl;
run;

data Race;
input Disease $	Race_Mortality $	St_Joseph	Candler;
datalines;
AMI	African_American	5	0
AMI	American_Indian	0	0
AMI	Asian	0	0
AMI	Cacasian	11	1
AMI	Pacific_Islander	0	0
AMI	Other	1	0
COPD	African_American	2	1
COPD	American_Indian	0	0
COPD	Asian	0	0
COPD	Cacasian	9	8
COPD	Pacific_Islander	0	0
COPD	Other	0	0
CABG	African_American	0	0
CABG	American_Indian	0	0
CABG	Asian	0	0
CABG	Cacasian	2	0
CABG	Pacific_Islander	0	0
CABG	Other	0	0
Heart_Failure	African_American	8	10
Heart_Failure	American_Indian	0	0
Heart_Failure	Asian	0	0
Heart_Failure	Cacasian	23	22
Heart_Failure	Pacific_Islander	0	0
Heart_Failure	Other	0	0
Pneumonia	African_American	5	10
Pneumonia	American_Indian	0	0
Pneumonia	Asian	0	0
Pneumonia	Cacasian	25	22
Pneumonia	Pacific_Islander	0	0
Pneumonia	Other	1	0
Severe_Sepsis	African_American	42	56
Severe_Sepsis	American_Indian	1	0
Severe_Sepsis	Asian	0	1
Severe_Sepsis	Cacasian	109	90
Severe_Sepsis	Pacific_Islander	0	0
Severe_Sepsis	Other	5	1
Stroke	African_American	6	0
Stroke	American_Indian	0	0
Stroke	Asian	2	0
Stroke	Cacasian	16	1
Stroke	Pacific_Islander	0	0
Stroke	Other	1	0
;
run;

proc contents data=race;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=Race;
class  Disease Race_Mortality;
model St_Joseph	Candler = Disease Race_Mortality / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Disease Race_Mortality / stderr cl;
run;


data Joe_CLABSI;
input CAUTI_Clabsi $	Race_Mortality $	St_Joseph_CAUTI	St_Joseph_cLABSI;
datalines;
CAUTI_Clabsi 	American_Indian	0	0
CAUTI_Clabsi	Asian	0	0
CAUTI_Clabsi	Black	3	1
CAUTI_Clabsi	White	5	1
CAUTI_Clabsi	Unable_to_identify	0	0
;
run;

/*transform wide data to long data*/
data Clabsi2;
set Joe_CLABSI;
array vars[2] 	St_Joseph_CAUTI		St_Joseph_cLABSI;
do i=1 to 2;
Mortality = vars[i];
Groups = i;
output;
end;
drop i 	Candler_CAUTI Candler_CLABSI;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=CLABSI2;
class  Groups Race_Mortality (ref='American');
model Mortality= Groups Race_Mortality / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Race_Mortality Groups / stderr cl;
run;


data Candler_CLABSi;
input CAUTI_Clabsi $	Race_Mortality $	Candler_CAUTI	Candler_CLABSI;
datalines;
CAUTI_Clabsi 	American_Indian	0	0
CAUTI_Clabsi	Asian	0	0
CAUTI_Clabsi	Black	6	4
CAUTI_Clabsi	White	2	6
CAUTI_Clabsi	Unable_to_identify	1	1
;
run;


/*transform wide data to long data*/
data Clabsi3;
set Candler_CLABSI;
array vars[2] 	Candler_CAUTI		Candler_cLABSI;
do i=1 to 2;
Mortality = vars[i];
Groups = i;
output;
end;
drop i 	Candler_CAUTI Candler_CLABSI;
run;

proc freq data=CLABSI;
   tables CAUTI_Clabsi Race_Mortality;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=CLABSI3;
class  Groups Race_Mortality (ref='American');
model Mortality= Groups Race_Mortality / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Race_Mortality Groups / stderr cl;
run;


data CLABSI_Gender;
input Gender $	St_Joseph_CAUTI	St_Joseph_cLABSI;
datalines;
Female	5	2
Male	3	1
;
run;


/*transform wide data to long data*/
data Clabsi_Gender2;
set CLABSI_Gender;
array vars[2] 	St_Joseph_CAUTI	St_Joseph_cLABSI;
do i=1 to 2;
CLABSI = vars[i];
Groups = i;
output;
end;
drop i 	St_Joseph_CAUTI	St_Joseph_cLABSI;
run;

proc means data=Clabsi_Gender2;
  var CLABSI;
  class Gender;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=CLABSI_Gender2;
class  Groups Gender ;
model CLABSI= Groups Gender / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Gender Groups / stderr cl;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=CLABSI_Gender2;
class  Groups Race_Mortality (ref='American');
model Mortality= Groups Race_Mortality / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Race_Mortality Groups / stderr cl;
run;


data CLABSI_CANGender;
input Gender $	Candler_CAUTI	Candler_CLABSI;
datalines;
Female	5	7
Male	4	4
;
run;

/*transform wide data to long data*/
data Clabsi_CANGender2;
set CLABSI_CANGender;
array vars[2] 	Candler_CAUTI	Candler_CLABSI;
do i=1 to 2;
Disease = vars[i];
Candler = i;
output;
end;
drop i 	Candler_CAUTI	Candler_CLABSI;
run;

proc print data =  Clabsi_CANGender2;
run;
/*Test of effect of Race and Diseases on Mortality*/
proc glm data=CLABSI_CANGender2;
class  Gender Candler;
model Disease= Gender Candler / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Gender Candler / stderr cl;
run;

data Age_CLABSI;
input Gender $	Candler_CAUTI	Candler_CLABSI;
datalines;
CAUTI/Clabsi	Age	St_Joseph_CAUTI	Candler_CAUTI	St_Joseph_cLABSI	Candler_CAUTI
CAUTI/Clabsi	18-20	0	1	0	0
CAUTI/Clabsi	21-30	0	0	0	1
CAUTI/Clabsi	31-40	0	1	0	2
CAUTI/Clabsi	41-50	1	3	1	1
CAUTI/Clabsi	51-60	2	1	0	1
CAUTI/Clabsi	61-70	3	2	1	3
CAUTI/Clabsi	71-80	1	1	0	3
CAUTI/Clabsi	81+	1	0	0	0
;

data Age_CLABSI;
input Facility $	AgeGroup $ Patients;
datalines;
St_Joseph	18-20	0
St_Joseph	21-30	0
St_Joseph	31-40	0
St_Joseph	41-50	1
St_Joseph	51-60	2
St_Joseph	61-70	3
St_Joseph	71-80	1
St_Joseph	81+	1
Candler	18-20	1
Candler	21-30	0
Candler	31-40	1
Candler	41-50	3
Candler	51-60	1
Candler	61-70	2
Candler	71-80	1
Candler	81+	0
St_Joseph	18-20	0
St_Joseph	21-30	0
St_Joseph	31-40	0
St_Joseph	41-50	1
St_Joseph	51-60	0
St_Joseph	61-70	1
St_Joseph	71-80	0
St_Joseph	81+	0
Candler	18-20	0
Candler	21-30	1
Candler	31-40	2
Candler	41-50	1
Candler	51-60	1
Candler	61-70	3
Candler	71-80	3
Candler	81+	0
;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=Age_CLABSI;
class  Facility AgeGroup;
model Patients = Facility AgeGroup / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Facility AgeGroup / stderr cl;
run;

data SDOH;
input SDOH_Facility $	Gender $	patients;
datalines;
St_Joseph	Female	61
St_Joseph	Male	137
Candler	Female	71
Candler	Male	153
;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=SDOH;
class  SDOH_Facility	Gender (ref = 'Female');
model Patients = SDOH_Facility	Gender / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans SDOH_Facility	Gender / stderr cl;
run;

data SDOHRace;
input Facility $	SDOH_by_Race $	Patients;
datalines;
St_Joseph	American_Indian	1
St_Joseph	Asian	3
St_Joseph	Black	57
St_Joseph	White	133
St_Joseph	Other	4
Candler	American_Indian	1
Candler	Asian	0
Candler	Black	84
Candler	White	137
Candler	Other	2
;
run;

/*Test of effect of Race and Diseases on Mortality*/
proc glm data=SDOHRace;
class  Facility 	SDOH_by_Race;
model Patients = Facility 	SDOH_by_Race / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Facility 	SDOH_by_Race / stderr cl;
run;

data SDOHAge;
input SDOH_Facility $	SDOH_Age $	Patients;
datalines;
St_Joseph	18-20	2
St_Joseph	21-30	9
St_Joseph	31-40	23
St_Joseph	41-50	43
St_Joseph	51-60	45
St_Joseph	61-70	42
St_Joseph	71-80	21
St_Joseph	80+	13
Candler	18-20	2
Candler	21-30	15
Candler	31-40	27
Candler	41-50	35
Candler	51-60	75
Candler	61-70	41
Candler	71-80	21
Candler	80+	8
;
run;


/*Test of effect of Race and Diseases on Mortality*/
proc glm data=SDOHAge;
class  SDOH_Facility	SDOH_Age;
model Patients = SDOH_Facility	SDOH_Age / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans SDOH_Facility	SDOH_Age / stderr cl;
run;




data Mortality;
input Disease $	AgeGroup $	Facility $	Mortality;
datalines;
AMI	18-20	St_Joseph	0
AMI	21-30	St_Joseph	0
AMI	31-40	St_Joseph	0
AMI	41-50	St_Joseph	0
AMI	51-60	St_Joseph	2
AMI	61-70	St_Joseph	4
AMI	71-80	St_Joseph	8
AMI	80+	St_Joseph	3
COPD	18-20	St_Joseph	0
COPD	21-30	St_Joseph	0
COPD	31-40	St_Joseph	1
COPD	41-50	St_Joseph	0
COPD	51-60	St_Joseph	1
COPD	61-70	St_Joseph	4
COPD	71-80	St_Joseph	2
COPD	80+	St_Joseph	3
CABG	18-20	St_Joseph	0
CABG	21-30	St_Joseph	0
CABG	31-40	St_Joseph	0
CABG	41-50	St_Joseph	0
CABG	51-60	St_Joseph	0
CABG	61-70	St_Joseph	1
CABG	71-80	St_Joseph	1
CABG	80+	St_Joseph	0
Heart_Failure	18-20	St_Joseph	0
Heart_Failure	21-30	St_Joseph	1
Heart_Failure	31-40	St_Joseph	0
Heart_Failure	41-50	St_Joseph	0
Heart_Failure	51-60	St_Joseph	3
Heart_Failure	61-70	St_Joseph	6
Heart_Failure	71-80	St_Joseph	11
Heart_Failure	80+	St_Joseph	10
Pneumonia	18-20	St_Joseph	0
Pneumonia	21-30	St_Joseph	0
Pneumonia	31-40	St_Joseph	1
Pneumonia	41-50	St_Joseph	3
Pneumonia	51-60	St_Joseph	1
Pneumonia	61-70	St_Joseph	7
Pneumonia	71-80	St_Joseph	10
Pneumonia	80+	St_Joseph	9
Severe_Sepsis	18-20	St_Joseph	0
Severe_Sepsis	21-30	St_Joseph	2
Severe_Sepsis	31-40	St_Joseph	2
Severe_Sepsis	41-50	St_Joseph	9
Severe_Sepsis	51-60	St_Joseph	14
Severe_Sepsis	61-70	St_Joseph	42
Severe_Sepsis	71-80	St_Joseph	53
Severe_Sepsis	81+	St_Joseph	35
Stroke	18-20	St_Joseph	0
Stroke	21-30	St_Joseph	1
Stroke	31-40	St_Joseph	1
Stroke	41-50	St_Joseph	2
Stroke	51-60	St_Joseph	7
Stroke	61-70	St_Joseph	6
Stroke	71-80	St_Joseph	5
Stroke	80+	St_Joseph	3
AMI	18-20	Candler	0
AMI	21-30	Candler	0
AMI	31-40	Candler	0
AMI	41-50	Candler	0
AMI	51-60	Candler	0
AMI	61-70	Candler	0
AMI	71-80	Candler	0
AMI	80+	Candler	1
COPD	18-20	Candler	0
COPD	21-30	Candler	0
COPD	31-40	Candler	0
COPD	41-50	Candler	0
COPD	51-60	Candler	0
COPD	61-70	Candler	2
COPD	71-80	Candler	0
COPD	80+	Candler	1
CABG	18-20	Candler	0
CABG	21-30	Candler	0
CABG	31-40	Candler	0
CABG	41-50	Candler	0
CABG	51-60	Candler	0
CABG	61-70	Candler	0
CABG	71-80	Candler	0
CABG	80+	Candler	0
Heart_Failure	18-20	Candler	0
Heart_Failure	21-30	Candler	0
Heart_Failure	31-40	Candler	0
Heart_Failure	41-50	Candler	0
Heart_Failure	51-60	Candler	0
Heart_Failure	61-70	Candler	3
Heart_Failure	71-80	Candler	4
Heart_Failure	80+	Candler	4
Pneumonia	18-20	Candler	0
Pneumonia	21-30	Candler	0
Pneumonia	31-40	Candler	0
Pneumonia	41-50	Candler	1
Pneumonia	51-60	Candler	5
Pneumonia	61-70	Candler	11
Pneumonia	71-80	Candler	12
Pneumonia	80+	Candler	3
Severe_Sepsis	18-20	Candler	1
Severe_Sepsis	21-30	Candler	0
Severe_Sepsis	31-40	Candler	5
Severe_Sepsis	41-50	Candler	4
Severe_Sepsis	51-60	Candler	23
Severe_Sepsis	61-70	Candler	40
Severe_Sepsis	71-80	Candler	51
Severe_Sepsis	81+	Candler	24
Stroke	18-20	Candler	0
Stroke	21-30	Candler	0
Stroke	31-40	Candler	0
Stroke	41-50	Candler	0
Stroke	51-60	Candler	0
Stroke	61-70	Candler	0
Stroke	71-80	Candler	0
Stroke	80+	Candler	0
;
run;



/*Test of effect of Race and Diseases on Mortality*/
proc glm data=Mortality;
class  Disease (ref = 'AMI')	AgeGroup (ref = '18-20')	Facility;
model Mortality = Disease	AgeGroup	Facility / solution; /* Include intercept implicitly */

/* Calculate least squares means with standard errors and confidence limits */
lsmeans Disease	AgeGroup	Facility / stderr cl;
run;
