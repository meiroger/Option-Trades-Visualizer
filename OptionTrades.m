% Roger Mei
% Option Trades at Expiration
% This code models vertical spreads, covered calls, naked puts,
% collar trades, unencumbered stock collar trade, straddle trades,
% strangle trades, stock repair/enhancement trades,..
% The Returns are based on the underlying Stock Price at expiration
% compared to initial Stock Price at the start of the trade.

% Choose Type of Option Trade
%-------------------------------------------------------------------------
trade_prompt = 'Please enter the number for the type of Option Trade: \n(1) Vertical Spread\n(2) Covered Call\n(3) Naked Put\n(4) Collar Trade\n(5) Unencumbered Stock Collar Trade\n(6) Straddle Trade\n(7) Strangle Trade\n(8) Stock Repair/Enhancement\n';
trade = input(trade_prompt);
%-------------------------------------------------------------------------

% All Variables used
%-------------------------------------------------------------------------
l_strike_price = 0; % Vertical long strike
s_strike_price = 0; % Vertical short strike
l_cost = 0; % Vertical long cost
s_cost = 0; % Vertical short cost
tt = ''; % Type of spread trade 
x = zeros(1,2000); % Returns values
y = zeros(1,2000); % Stock Prices values
%-------------------------------------------------------------------------

% This part of the code asks for inputs for the initial stock price.
%-------------------------------------------------------------------------
isp_prompt = 'Please input the price of the underlying stock at the start of the trade: ';
isp = input(isp_prompt);
% This creates the y-axis, $15 above and below the initial stock price.
for ii = 1: 2000
    y(ii) = (isp - 15) + ii*(30/2000);
end
%-------------------------------------------------------------------------

% Initial Inputs for Vertical Spread
if trade == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%VERTICAL SPREAD%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calls or Puts?
cp_prompt = 'Please enter 1 for calls or 2 for puts: ';
cp = input(cp_prompt);

if cp == 1
    % This asks for the strike price and price per share of the long call contract.
    long_strike_prompt = 'Please input the strike price of the LONG call contract: ';
    l_strike_price = input(long_strike_prompt);
    lc_prompt = 'Please input the cost (per share) of the LONG call: ';
    l_cost = input(lc_prompt);

    % This asks for the strike price and price per share of the short call contract.
    short_strike_prompt = 'Please input the strike price of the SHORT call contract: ';
    s_strike_price = input(short_strike_prompt);
    sc_prompt = 'Please input the cost (per share) of the SHORT call: ';
    s_cost = input(sc_prompt);
elseif cp == 2
    % This asks for the strike price and price per share of the long put contract.
    long_strike_prompt = 'Please input the strike price of the LONG put contract: ';
    l_strike_price = input(long_strike_prompt);
    lc_prompt = 'Please input the cost (per share) of the LONG put: ';
    l_cost = input(lc_prompt);

    % This asks for the strike price and price per share of the short put contract.
    short_strike_prompt = 'Please input the strike price of the SHORT put contract: ';
    s_strike_price = input(short_strike_prompt);
    sc_prompt = 'Please input the cost (per share) of the SHORT put: ';
    s_cost = input(sc_prompt);
else
    wrongcp = '1(calls) or 2(puts) was not entered.';
    disp(wrongcp);
end

%-------------------------------------------------------------------------


% Creates Returns
%-------------------------------------------------------------------------
if (cp == 1) && (s_strike_price > l_strike_price)
    % Bull Call
    tt = 'Bull Call Debit Spread: Returns vs Stock Price';
    
    cost = s_cost - l_cost;
    % Debit spreads must have a net debit. This issues a warning if there is a
    % net credit instead of net debit.
    if cost > 0
        error 'The long call must cost more than the short call.';
    end
    % In a debit spread, the maximum return is the difference in the strike
    % prices minus the cost. 
    max_return = s_strike_price - l_strike_price + cost;
    
    % This creates the Return values per share at each Stock Price.
    % The if loop minimizes the losses of the trade to the initial cost of the
    % trade.
    for jj = 1:2000
        x(jj) = y(jj) - l_strike_price + cost;
            if x(jj) < cost
            x(jj) = cost;
            else x(jj) = x(jj);
            end
    
            if x(jj) > max_return
            x(jj) = max_return;
            else x(jj) = x(jj);
            end
    end
    
elseif (cp == 1) && (l_strike_price > s_strike_price)
    % Bear Call
    tt = 'Bear Call Credit Spread: Returns vs Stock Price';
    
    cost = s_cost - l_cost;
    % Credit spreads must have a net credit. This issues a warning if there is a
    % net debit instead of net credit.
    if cost < 0
        error 'The short put must cost more than the long put.';
    end
    % In a credit spread, the maximum return is the initial credit.
    max_return = cost;
    
    % The worst case is the difference in the strike prices plus the 
    % initial net credit. 
    for jj = 1:2000
        x(jj) = s_strike_price - y(jj) + cost;
            if x(jj) < s_strike_price - l_strike_price + cost;
            x(jj) = s_strike_price - l_strike_price + cost;
            else x(jj) = x(jj);
            end
        
            if x(jj) > max_return
            x(jj) = max_return;
            else x(jj) = x(jj);
           end
    end

elseif (cp == 2) && (l_strike_price > s_strike_price)  
    % Bear Put
    tt = 'Bear Put Debit Spread: Returns vs Stock Price';
    
    cost = s_cost - l_cost;
    % Debit spreads must have a net debit. This issues a warning if there is a
    % net credit instead of net debit.
    if cost > 0
        error 'The long put must cost more than the short put';
    end
    % In a debit spread, the maximum return is the difference in the strike
    % prices minus the cost. 
    max_return = l_strike_price - s_strike_price + cost;
    
    % Minimum is the initial cost.
    for jj = 1:2000
        x(jj) = l_strike_price - y(jj) + cost;
            if x(jj) < cost
            x(jj) = cost;
            else x(jj) = x(jj);
            end
            
            if x(jj) > max_return
            x(jj) = max_return;
            else x(jj) = x(jj);
            end
    end

elseif (cp == 2) && (s_strike_price > l_strike_price)
    % Bull Put
    tt = 'Bull Put Credit Spread: Returns vs Stock Price';
    
    cost = s_cost - l_cost;
    % Credit spreads must have a net credit. This issues a warning if there is a
    % net debit instead of net credit.
    if cost < 0
        error 'The short put must cost more than the long put';
    end
    % In a credit spread, the maximum return is the initial credit.
    max_return = cost;
    
    % The worst case is the difference in the strike prices plus the
    % initial net credit.
    for jj = 1:2000
        x(jj) = y(jj) - s_strike_price + cost;
            if x(jj) < l_strike_price - s_strike_price + cost;
            x(jj) = l_strike_price - s_strike_price + cost;
            else x(jj) = x(jj);
            end
            
            if x(jj) > max_return
            x(jj) = max_return;
            else x(jj) = x(jj);
            end
    end
    
else disp('This is not a vertical spread trade.')    
end
%%%%%%%%%%%%%%%%%%%%%%%%%END VERTICAL SPREAD%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%COVERED CALL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 2 
tt = 'Covered Call: Stock Price vs. Returns';
ccstrike_prompt = 'Please input the strike price of the covered call: ';
ccstrike = input(ccstrike_prompt);
cccost_prompt = 'Please input the cost of the covered call: ';
cccost = input(cccost_prompt);

max_return = ccstrike + cccost - isp;
min = -isp + cccost; % Minimum when stock price = 0 + initial credit
for jj = 1:2000
    x(jj) = y(jj) - isp + cccost; 
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
    if x(jj) > max_return
        x(jj) = max_return;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%END COVERED CALL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%NAKED PUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 3 
tt = 'Naked Put: Stock Price vs. Returns';
npstrike_prompt = 'Please input the strike price of the naked put: ';
npstrike = input(npstrike_prompt);
npcost_prompt = 'Please input the cost of the naked put: ';
npcost = input(npcost_prompt);

max_return = npcost; 
min = -npstrike + npcost; % Minimum when stock price = 0 + initial credit
for jj = 1:2000
    x(jj) = y(jj) - npstrike + npcost; 
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
    if x(jj) > max_return
        x(jj) = max_return;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END NAKED PUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%COLLAR TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 4 
tt = 'Collar Trade: Stock Price vs. Returns';
ccstrike_prompt = 'Please input the strike price of the covered call: ';
ccstrike = input(ccstrike_prompt);
cccost_prompt = 'Please input the cost of the covered call: ';
cccost = input(cccost_prompt);
lpstrike_prompt = 'Please input the strike price of the long put: ';
lpstrike = input(lpstrike_prompt);
lpcost_prompt = 'Please input the cost of the long put: ';
lpcost = input(lpcost_prompt);

max_return = ccstrike + cccost - isp - lpcost; 
min = lpstrike -isp + cccost - lpcost;
% Minimum when stock price goes below long put strike price, including both
% costs of long put and covered call.
for jj = 1:2000
    x(jj) = y(jj) - isp + cccost - lpcost; 
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
    if x(jj) > max_return
        x(jj) = max_return;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%END COLLAR TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%UNENCUMBERED STOCK COLLAR TRADE %%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 5 %WRONG, HORIZONTAL Y AXIS? , RETURNS WRONG
disp('This trade assumes long 200 shares of stock, 1 short call, 1 long put.')
tt = 'Unencumbered Stock Collar Trade: Stock Price vs. Returns';
ccstrike_prompt = 'Please input the strike price of the covered call: ';
ccstrike = input(ccstrike_prompt);
cccost_prompt = 'Please input the cost of the covered call: ';
cccost = input(cccost_prompt);
lpstrike_prompt = 'Please input the strike price of the long put: ';
lpstrike = input(lpstrike_prompt);
lpcost_prompt = 'Please input the cost of the long put: ';
lpcost = input(lpcost_prompt);

max_return = 2*ccstrike + cccost - 2*isp - lpcost; 
min = lpstrike -isp + cccost - lpcost;
% Minimum when stock price goes below long put strike price, including both
% costs of long put and covered call.
for jj = 1:2000
    x(jj) = 2*y(jj) - 2*isp + cccost - lpcost; 
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
    if x(jj) > max_return
        x(jj) = 2*ccstrike + cccost - 2*isp - lpcost + y(jj) -isp;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%END UNENCUMBERED STOCK COLLAR TRADE %%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%STRADDLE TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 6 
tt = 'Straddle Trade: Stock Price vs. Returns';
cpstrike_prompt = 'Please input the strike price of the long call and long put: ';
cpstrike = input(cpstrike_prompt);
lccost_prompt = 'Please input the cost of the long call: ';
lccost = input(lccost_prompt);
lpcost_prompt = 'Please input the cost of the long put: ';
lpcost = input(lpcost_prompt);

min = -lpcost - lccost; % Minimum is combined costs of the long options.
for jj = 1:2000
    x(jj) = y(jj) - cpstrike - lccost - lpcost; 
    if y(jj) < cpstrike
        x(jj) = cpstrike - y(jj) - lpcost - lccost;
    end
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%END STRADDLE TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%STRANGLE TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 7 
tt = 'Strangle Trade: Stock Price vs. Returns';
lcstrike_prompt = 'Please input the strike price of the long call: ';
lcstrike = input(lcstrike_prompt);
lccost_prompt = 'Please input the cost of the long call: ';
lccost = input(lccost_prompt);
lpstrike_prompt = 'Please input the strike price of the long put: ';
lpstrike = input(lpstrike_prompt);
lpcost_prompt = 'Please input the cost of the long put: ';
lpcost = input(lpcost_prompt);

min = -lpcost - lccost; % Minimum is combined costs of the long options.
for jj = 1:2000
    x(jj) = y(jj) - cpstrike - lccost -lpcost; 
    if y(jj) < lpstrike
        x(jj) = lpstrike - y(jj) - lpcost - lccost;
    end
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%END STRANGLE TRADE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%STOCK REPAIR/ENHANCEMENT%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif trade == 8 
tt = 'Stock Repair/Enhancement: Stock Price vs. Returns';
ccstrike_prompt = 'Please input the strike price of the covered call: ';
ccstrike = input(ccstrike_prompt);
cccost_prompt = 'Please input the cost of the covered call: ';
cccost = input(cccost_prompt);

max_return = ccstrike + cccost - isp;
min = -isp + cccost; % Minimum when stock price = 0 + initial credit
for jj = 1:2000
    x(jj) = y(jj) - isp + cccost; 
    if x(jj) < min
        x(jj) = min;
    else x(jj) = x(jj);
    end
    if x(jj) > max_return
        x(jj) = max_return;
    else x(jj) = x(jj);
    end
end
cost = s_cost - l_cost; %BULL CALL DEBIT
    
    % In a debit spread, the maximum return is the difference in the strike
    % prices minus the cost. 
    max_return = s_strike_price - l_strike_price + cost;
    
    % BULL CALL RETURNS
    for jj = 1:2000
        x(jj) = y(jj) - l_strike_price + cost;
            if x(jj) < cost
            x(jj) = cost;
            else x(jj) = x(jj);
            end
    
            if x(jj) > max_return
            x(jj) = max_return;
            else x(jj) = x(jj);
            end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%END STOCK REPAIR/ENHANCEMENT%%%%%%%%%%%%%%%%%%%%%%

else disp('Please enter a number 1-')
end  %end trade type 

% Creates Risk Graph
%-------------------------------------------------------------------------
% This is the Total Returns of the trade per contract. Since a contract is
% 100 shares, the returns per share is multiplied by 100.
TR = x*100;


% This plots the Total Returns for each Stock Price.
plot(TR,y,0,y,'k-.')
grid on
xlabel('Returns')
ylabel('Stock Price')
title(tt);
%-------------------------------------------------------------------------
