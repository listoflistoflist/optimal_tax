clear all
set more off
set scheme s1mono
set varabbrev on

/*Options*/
global justgross 1 /*1: Use only those who perceive their gross income as just.
					0: Additionally Use just net incomes of those who perceive their gross income as unjust and 
					 apply it to those with a gross income similar to the just gross incomes.*/
global groups 5 /*number of income groups*/
global sample 1 /*1: all without children, 2: only women, 3: only men, 4: lone mothers; 
5-9: party affiliation, see 2_dataprocessing; 10: east; 11: west. 12: satisfied with gross income */
/*we use 1,2,3,5,6,8,9, 10, 11,12*/

*do 1_data.do
do 2_dataprocessing.do
do 3_descriptive.do

