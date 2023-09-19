<span style="font-family:Times New Roman; font-size:14pt;">
<h2 align="center"><b>Optimizing Power Generation and Reservoir Management for Cost-Efficient Electricity Supply</b></h2>
</span>

<span style="font-family: Times New Roman; font-size: 13pt;">

This project tackles the complex task of optimizing power generation and reservoir management for cost-efficient electricity supply. The problem involves a set of power stations responsible for meeting daily electricity load demands. These stations comprise different types of generators, each with its operational constraints, hourly costs, and start-up costs. The challenge is to determine which generators should operate during specific time periods to minimize the overall cost, while also ensuring a 15% reserve capacity to handle unforeseen load increases. Furthermore, this problem extends to include hydro generators, a reservoir, and environmental constraints, such as maintaining the reservoir's depth within specific limits.

Key Questions:

- Optimal Generator Operation: The first question involves identifying which generators should be active at different times of the day to minimize the total cost of electricity production.

- Marginal Cost of Production: The second question seeks to determine the marginal cost of electricity production during each time period, which directly informs tariff pricing.

- Impact of 15% Reserve Output: The third question evaluates the cost implications of reducing the 15% reserve capacity, providing insights into the trade-offs between security of supply and cost savings.

To address this multifaceted problem, a mathematical model was developed, and the General Algebraic Modeling System (GAMS) was employed for implementation and optimization. The model considers various factors, such as generator types, operational constraints, hourly and start-up costs, and the need to maintain reservoir depth. It also accounts for the 15% reserve capacity requirement and the flexibility to switch on hydro generators or use thermal generators for reservoir pumping when demand surges. The model's objective is to minimize the overall cost while adhering to all constraints.

<br>
You can find the results and step-by-step explanations for this project in the .pdf file. We've also included the code, along with complete documentation and line-by-line explanations for your further review.
