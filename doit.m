% input data
q = [3029, 7027, 3429, 9041, 3677, 2164, 3497, 4731, 4753, 6372,].';
p = [98.2046, 100.1812, 99.6207, 100.1746, 98.9762, 98.0859, 100.5188, 100.0064, 100.5751, 98.2218,].';
a = 12158;
b = 35562;

% setup
f = zeros(size(q));
intcon = 1:size(q);
Aeq = [p, ones(size(q))].';
beq = [dot(q, p) * a / (a + b); a];
lb = zeros(size(q));
ub = q;


% ilya solution
                      % x = glpk(f, intcon, [], [], Aeq, beq, lb, ub);
ctype = "SS";
vartype = "IIIIIIIIII";
x = glpk(intcon, Aeq, beq, lb, ub, [], vartype);

xi = int64(x);
% only for safety
if norm(x - double(xi)) > 0.1
   error("Error. The result can't be safely casted to integer vector")
end
x = double(xi);
% ditto
if sum(x) ~= a
   error("Error. The result sum not equal 'a'")
end

% compute objective function value
fval = 10e9 * (dot(x, p) / a - dot(q - x, p) / b) .^ 2;

% return
x, fval
