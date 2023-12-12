# optimal_tax
Replication files for **Optimal Taxation When the Tax Burden Matters**

# abstract
Survey evidence shows that the magnitude of the tax liability plays a role in value judgements about which groups deserve tax breaks. We demonstrate that the German taxtransfer system conflicts with a welfarist inequality averse social planner. It is consistent with a planner who is averse to both inequality and high tax liabilities. The tax-transfer schedule reflects non-welfarist value judgements of citizens or non-welfarist aims of policy makers. We extend our analysis to several European countries and the USA to show that their redistributive systems can be rationalized with an inequality averse social planner for whom the tax burden matters.

# how to cite
Jessen, R., Metzing, M., and Rostam-Afschar, D. (2022). Optimal taxation when the tax burden matters. Finanzarchiv/Public Finance Analysis, 78(3), pp. 312-340 (29). [https://doi.org/10.1628/fa-2022-0004](https://doi.org/10.1628/fa-2022-0004).

# files
- solve_weights_final.nb
  _calulate relative generalized marginal social welfare weights for different concepts of justness (Table 2), the absolut tax burden approach in 18 countries (Table 3), for an inequality-neutral planner (Table 4), for women without children (Table 6), for men without children (Table 7), for East Germany (Table 8), for West Germany (Table 9), and for different values of the loss function parameters gamma and delta (Tables 10, 11, 12). Also calculate the optimal welfarist tax schedule (Table 5)._
- Crosscountry_final.xlsx _Relative weights for the absolute tax burden approach for various countries (Table 3)_
- Stata code
  - 0_master.do
  - 1_data.do _data from SOEP_
  - 2_dataprocessing.do _variable definitions and sample restrictions_
  - 3_descriptive.do _summary statistics (Table 1)_
- Stata output
  - elasticities1.xls _income mobility elasticities (change in share in income group when annual net income increases by 10%), see Table 2._ 
  - groups1.xls _resulting relative weights as well as the estimated function parameters (Table 4). Columns are Group, Gross Income, Net Income, relative weights when absolute tax burden matters, relative weights when relative tax burden matters._
