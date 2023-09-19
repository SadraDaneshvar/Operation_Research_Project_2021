Set
   t 'periods'             / 12pm-6am, 6am-9am, 9am-3pm, 3pm-6pm, 6pm-12pm /
   g 'generators'          / type-1, type-2, type-3 /
   h 'Hydro Generators'    / type-A, type-B /
   k 'parameters'          / min-pow,  max-pow,  cost-min,  cost-inc,  start,   number/
   v 'hydro parameters'    / rate, cost_ph, depletion, st_cost /
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
   
Table hydro_data (h,v)
                rate    cost_ph     depletion      st_cost
   type-A       0.9        90          0.31          1500
   type-B       1.4       150          0.47          1200
;

Variable
   O(g,t)      'generator output'
   Gen(g,t)    'number of generators in use'
   S(g,t)      'number of generators started up'
   Z           'total operating cost'
   N (h,t)     'new hydro generator'
   Hyd (h,t)   'working generator'
   P (t)       'Pump'
   ht (t)      'water level'
;
   
Integer Variable Gen,S;

Positive Variable O,ht,P;

Binary Variable N,Hyd;


Equation
   dem_pow(t)             'demand for power              (1000mw)'
   reserve(t)             'spinning reserve requirements (1000mw)'
   start_up(g,t)          'start-up definition'
   min_out(g,t)           'minimum generation level      (1000mw)'
   max_out(g,t)           'maximum generation level      (1000mw)'
   cost                   'cost definition                    (l)'
   ht1 (t)                'initial height                     (m)'
   ht_low (t)             'minimum of height                  (m)'
   ht_up (t)              'maximum of height                  (m)'
   heit (t)               'relation between differenet heights in different time periods'
   h_start_up (h,t)       'start-up definition'
;

dem_pow(t)..  sum(g, O(g,t))+sum(h,(hydro_data(h, "rate"))*Hyd(h,t))-P(t) =g= dem(t);

reserve(t)..  sum(g, data(g,"max-pow")*Gen(g,t))+sum(h,hydro_data(h,'rate')) =g= 1.15*dem(t);

start_up(g,t).. S(g,t) =g= Gen(g,t) - Gen(g,t--1);

min_out(g,t).. O(g,t) =g= data(g,"min-pow")*Gen(g,t);

max_out(g,t).. O(g,t) =l= data(g,"max-pow")*Gen(g,t);

ht1(t)..       ht('12pm-6am') =e= 16;

ht_low (t) ..  ht(t) =g= 15;   
ht_up (t) ..  ht(t) =l= 20;

heit (t)   ..  ht(t++1)-ht(t)-((P(t)*dur(t))/3)+sum (h,hydro_data(h,'depletion')*dur(t)*Hyd(h,t))=e=0;

h_start_up(h,t) ..  N(h,t)=g=Hyd(h,t)-Hyd(h,t--1);

cost ..    Z =e=   sum((g,t), dur(t)*data(g,"cost-min")*Gen(g,t) + data(g,"start")*S(g,t)
                   + 1000*dur(t)*data(g,"cost-inc")*(O(g,t)-data(g,"min-pow")*Gen(g,t)))
                   +sum((h,t), hydro_data(h, 'st_cost')*N(h,t) + hydro_data(h, 'cost_ph')*dur(t)*Hyd(h,t));

Gen.up(g,t) = data(g,"number");

* now to sum it up:

Model HydroPower_Geneneration / all /;
HydroPower_Geneneration.optCr = 0;

* Now we do the Sensitivity Analysis: (the result of this step is available in the "Solution Report" provided by GAMS)

$onecho > cplex.opt
objrng all
rhsrng all
$offecho
HydroPower_Geneneration.optfile = 1;

* and at last to solve the model we have:

solve HydroPower_Geneneration minimizing Z using mip;
display O.l,Gen.l,S.l,Z.l,N.l,Hyd.l,P.l,ht.l;