Set
   t 'periods'       / 12pm-6am, 6am-9am, 9am-3pm, 3pm-6pm, 6pm-12pm /
   g 'generators'    / type-1, type-2, type-3 /
   k 'parameters'    / min-pow,  max-pow,  cost-min,  cost-inc,  start,   number/
;

Parameter
   dem(t)  'demand     (1000mw)' / 12pm-6am 15, 6am-9am 30, 9am-3pm 25, 3pm-6pm 40, 6pm-12pm 27 /
   dur(t)  'duration    (hours)' / 12pm-6am  6, 6am-9am  3, 9am-3pm  6, 3pm-6pm  3, 6pm-12pm  6 /
;

Table data(g,k) 'generation data'
            min-pow  max-pow  cost-min  cost-inc  start   number
   type-1       .85     2.0       1000       2.0   2000       12
   type-2      1.25     1.75      2600       1.3   1000       10
   type-3      1.5      4.0       3000       3.0    500        5
;

Variable
   O(g,t)     'generator output'
   Gen(g,t)   'number of generators in use'
   S(g,t)     'number of generators started up'
   Z          'total operating cost'
;

Integer Variable Gen;
Positive Variable S;

Equation
   dem_pow(t)    'demand for power              (1000mw)'
   reserve(t)    'spinning reserve requirements (1000mw)'
   start_up(g,t) 'start-up definition'
   min_out(g,t)  'minimum generation level      (1000mw)'
   max_out(g,t)  'maximum generation level      (1000mw)'
   cost          'cost definition'
;

dem_pow(t)..  sum(g, O(g,t)) =g= dem(t);

reserve(t)..  sum(g, data(g,"max-pow")*Gen(g,t)) =g= 1.15*dem(t);

start_up(g,t).. S(g,t) =g= Gen(g,t) - Gen(g,t--1);

min_out(g,t).. O(g,t) =g= data(g,"min-pow")*Gen(g,t);

max_out(g,t).. O(g,t) =l= data(g,"max-pow")*Gen(g,t);

cost ..    Z =e=   sum((g,t), dur(t)*data(g,"cost-min")*Gen(g,t) + data(g,"start")*S(g,t)
                   + 1000*dur(t)*data(g,"cost-inc")*(O(g,t)-data(g,"min-pow")*Gen(g,t)));

Gen.up(g,t) = data(g,"number");

* now to sum it up:

Model Power_Geneneration / all /;
Power_Geneneration.optCr = 0;

* Now we do the Sensitivity Analysis: (the result of this step is available in the "Solution Report" provided by GAMS)

$onecho > cplex.opt
objrng all
rhsrng all
$offecho
Power_Geneneration.optfile = 1;

* and at last to solve the model we have:

solve Power_Geneneration minimizing Z using mip;
display O.l,Gen.l,S.l,Z.l;
















