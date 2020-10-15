
% Portfolio optimization in Matlab using the Financial Toolbox
% I have not included the output or the analysis. This just includes the codes as I have done similar analysis in my Jupyter/ Python repositories. 
% Portfolio optimization is where we want to maximize our returns and minimize our risk. The sum of the portfolio weights add up to one and
% we can only go long on our stocks, meaning we cant short-sell them.

open('stock_prices.csv')
T = readtable('stock_prices.csv')

% Extract the asset symbols
symbol = T.Properties.VariableNames(2:end)

% Compute daily returns
dailyReturn = tick2ret(T{:,2:end})

% Construct the portfolio
p = Portfolio('AssetList', symbol, 'RiskFreeRate', 0.01/252)
p = estimateAssetMoments(p, dailyReturn)
p = setDefaultConstraints(p)

% Optimal weights
w1 = estimateMaxSharpeRatio(p)

% Gives us the optimal risk and expected returns 
[risk1, ret1] = estimatePortMoments(p, w1)

% Plot efficient frontier
f = figure;
tabgp = uitabgroup(f);
tabl = uitab(tabgp, 'Title', 'Efficient Frontier Plot');
ax = axes('Parent', tabl);
[m, cov] = getAssetMoments(p);
scatter(ax,sqrt(diag(cov)), m, 'oc', 'filled');
xlabel('Risk')
ylabel('Expected Return')
text(sqrt(diag(cov)),m,symbol,'Fontsize',7);
hold on
plotFrontier(p)
hold on
plot(risk1, ret1, '*r')
hold off