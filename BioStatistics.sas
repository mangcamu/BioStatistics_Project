/* Part 1 */
proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=StudentsData
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="student-por";
run;

proc freq data=StudentsData;
   tables gender address schoolsup activities nursery Final_grade goout freetime famrel;
run;

proc univariate data = StudentsData;
	var age failures traveltime studytime;
run;

/* Part 2*/
proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=Gender
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="Gender";
run;

proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=Address
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="Address";
run;

proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=Schoolsup
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="Schoolsup";
run;

proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=Nursery
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="Nursery";
run;

proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=Activities
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="Activities";
run;

title'Gender as Categorical variable of interest and Final_grade as the response variable';
proc freq data=Gender order=data;
	tables gender*Final_grade/ nocol nopct chisq cmh; 
run;

title'Address as Categorical variable of interest and Final_grade as the response variable';
proc freq data= Address order=data;
	tables address*Final_grade/ nocol nopct chisq cmh;
run;

title'Schoolsup as Categorical variable of interest and Final_grade as the response variable';
proc freq data= Schoolsup order=data;
	tables schoolsup*Final_grade/ nocol nopct chisq cmh;
run;

title'Activities as Categorical variable of interest and Final_grade as the response variable';
proc freq data= Activities order=data;
	tables activities*Final_grade/ nocol nopct chisq cmh;
run;

title'Nursery as Categorical variable of interest and Final_grade as the response variable';
proc freq data= Nursery order=data; 
	tables nursery*Final_grade/ nocol nopct chisq cmh;
run;

/* Part 3 */
proc import datafile="/home/u63784591/STAT305/Assignment/dataset.xlsx"
    out=StudentsData
    dbms=xlsx
    replace;
    getnames = yes;
    sheet="student-por";
run;

/* Fitted using all the variables from the dataset */
/* Best fitted model */
ods graphics on;
proc logistic data=StudentsData plots=all order=data;
	class final_grade gender(ref="M") address(ref="Rural") schoolsup(ref="no") activities(ref="no") nursery(ref="no") famsize(ref="More than 3")/ 
	param=reference;
	model final_grade (event="Pass") = gender address schoolsup activities nursery famsize age failures famrel traveltime studytime /
	aggregate scale=none clparm=wald clodds=pl rsquare lackfit;
	**output out=results predicted=pihat dfbetas=_all_ difchisq=chisq reschi=pearsonr resdev=g2res;
run;
ods graphics off;

/*Fitted using significant variables*/
ods graphics on;
proc logistic data=StudentsData plots=all order=data;
	class final_grade address(ref="Rural") schoolsup(ref="no")/ param=reference;
	model final_grade (event="Pass") = address schoolsup /aggregate scale=none clparm=wald clodds=pl rsquare lackfit influence;
run;
ods graphics off;

/*Fitted using relevant categorical explanatory variables*/
ods graphics on;
proc logistic data=StudentsData plots=all order=data;
	class final_grade gender(ref="M") address(ref="Rural") schoolsup(ref="no") activities(ref="no") nursery(ref="no") famsize(ref="More than 3");
	model final_grade (event="Pass") = gender address schoolsup activities nursery famsize /aggregate scale=none clparm=wald clodds=pl rsquare lackfit influence;
run;
ods graphics off;